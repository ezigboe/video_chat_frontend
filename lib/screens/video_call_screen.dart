import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_chat/auth.dart';
import 'package:video_chat/cubits/cubit/random_video_cubit.dart';
import 'package:video_chat/screens/home_screen.dart';
import 'package:video_chat/utils/agora_config.dart';
import 'package:video_chat/utils/meta_styles.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool user = false;
  String channelName = "";
  String channelToken = "";
  bool isMicOn = true;

  @override
  void initState() {
    super.initState();
    try {
      initAgora();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    setState(() {});
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          log("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onLeaveChannel: (connection, stats) {
          log(connection.localUid.toString());
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.setupLocalVideo(VideoCanvas(uid: 0));
    await _engine.enableVideo();
    await _engine.startPreview();
    log("here");

    log("here ttttt");
  }

  _joinChannel(String channel, String token) async {
    // setState(() {
    //   channelName = channel;
    //   channelToken = token;
    // });
    await _engine.joinChannel(
      token: channelToken,
      channelId: channelName,
      options: ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster),
      uid: 0,
    );
  }

  @override
  void dispose() {
    if (_engine != null) {
      endStream();
      _engine.release();
    }
    super.dispose();
  }

  endStream() {
    context.read<RandomVideoCubit>().endCall();
    _engine?.leaveChannel();
    _engine?.stopPreview();

    log("Channel left");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: BlocConsumer<RandomVideoCubit, RandomVideoState>(
        listener: (context, state) async {
          // TODO: implement listener
          if (state is RandomVideoUserFoundState) {
            log("channel Name ${state.randomUser.channel!}");
            await _joinChannel(
                state.randomUser.channel!, state.randomUser.token);
          }
        },
        builder: (context, state) {
          if (state is RandomVideoUserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Text(
                        "Search",
                        style: MetaStyles.labelStyle,
                      ),
                      onTap: () {
                        context.read<RandomVideoCubit>().findUser();
                      },
                    ),
                  ))
                ],
              ),
            );
          }
          if (state is RandomVideoUserSearchingState) {
            return Center(
              child: Loader(),
            );
          }
          if (state is RandomVideoUserIdleState) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Text(
                  "Search",
                  style: MetaStyles.labelStyle,
                ),
                onTap: () {
                  context.read<RandomVideoCubit>().findUser();
                },
              ),
            ));
          }
          if (state is RandomVideoUserFoundState) {
            if (_engine == null) {
              return Center(
                child: Loader(),
              );
            }
            return CustomScrollView(
              slivers: [
                // AppBarWidget(),
                SliverFillRemaining(
                  child: Container(
                    // height: MediaQuery.of(context).size.height-kToolbarHeight,
                    child: Center(
                      child: Stack(
                        children: [
                          Center(
                            child: !user
                                ? _remoteVideo(state.randomUser.channel!)
                                : LocalUserView(engine: _engine),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        user = !user;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.amber),
                                      width: 100,
                                      height: 150,
                                      child: Center(
                                        child: _localUserJoined
                                            ? !user
                                                ? LocalUserView(engine: _engine)
                                                : _remoteVideo(
                                                    state.randomUser.channel!)
                                            : const CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  CupertinoIcons.camera_rotate,
                                                  color: Colors.black,
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isMicOn = !isMicOn;
                                                });
                                                _engine
                                                    .muteAllRemoteAudioStreams(
                                                        isMicOn);
                                              },
                                              child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    isMicOn
                                                        ? CupertinoIcons.mic
                                                        : CupertinoIcons
                                                            .mic_off,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                endStream();
                                              },
                                              child: CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  child: Icon(
                                                    CupertinoIcons
                                                        .phone_down_fill,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      )),
    );
  }

  Widget _remoteVideo(String channelName) {
    if (_remoteUid != null) {
      log("Heyeyey");
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}

class LocalUserView extends StatelessWidget {
  const LocalUserView({
    Key? key,
    required RtcEngine engine,
  })  : _engine = engine,
        super(key: key);

  final RtcEngine _engine;

  @override
  Widget build(BuildContext context) {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }
}
