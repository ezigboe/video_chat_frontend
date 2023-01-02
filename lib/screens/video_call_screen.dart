import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_chat/screens/home_screen.dart';
import 'package:video_chat/utils/agora_config.dart';

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

  @override
  void initState() {
    super.initState();
    try {
      // initAgora();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> initAgora() async {
    log("herrrrrrrrrrrrrrrrrrrrr");
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

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
    await _engine.joinChannel(
      token: token,
      channelId: "Test",
      options: ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster),
      uid: 0,
    );

    log("here ttttt");
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.stopPreview();
    _engine.release();
    log("Channel left");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          // floatingActionButton: FloatingActionButton(onPressed: (){
          // if(_localUserJoined){
          //   _engine.leaveChannel();
          //   setState(() {
          //     _localUserJoined=false;
          //   });
          // }else{
          //   _engine.joinChannel(token: token, channelId: "Test", uid: 0, options: ChannelMediaOptions(clientRoleType: ClientRoleType.clientRoleBroadcaster));
          // }
          // }),
          body: CustomScrollView(
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
                          ? _remoteVideo()
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
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.amber),
                                width: 100,
                                height: 150,
                                child: Center(
                                  child: _localUserJoined
                                      ? !user
                                          ? LocalUserView(engine: _engine)
                                          : _remoteVideo()
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
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                                      child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            CupertinoIcons.mic_off,
                                            color: Colors.black,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: Icon(
                                            CupertinoIcons.phone_down_fill,
                                            color: Colors.white,
                                          )),
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
      )),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      log("Heyeyey");
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: "Test"),
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
