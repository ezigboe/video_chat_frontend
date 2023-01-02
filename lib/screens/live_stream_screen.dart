import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_chat/auth.dart';
import 'package:video_chat/cubits/stream/stream_cubit.dart';
import 'package:video_chat/models/stream_model/stream_model.dart';
import 'package:video_chat/models/user_model/user_model.dart';
import 'package:video_chat/screens/video_call_screen.dart';
import 'package:video_chat/utils/agora_config.dart';
import 'package:video_chat/utils/helper_widgets.dart';
import 'package:video_chat/utils/meta_colors.dart';
import 'package:video_chat/utils/meta_styles.dart';

class LiveStreamScreen extends StatefulWidget {
  final StreamModel data;
  final bool isHost;
  final UserModel user;
  const LiveStreamScreen(
      {super.key,
      required this.data,
      required this.isHost,
      required this.user});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen>
    with WidgetsBindingObserver {
  int? _remoteUid;
  bool _localUserJoined = false;
  RtcEngine? _engine;
  List<String> _infoStrings = [];
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    try {
      initAgora();
    } catch (e) {
      log(e.toString());
    }
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          log("local user ${connection.localUid} joined");
          _infoStrings.add("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          log("remote user $remoteUid joined");
          _infoStrings.add("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          log("remote user $remoteUid left channel");
          _infoStrings.add("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onLeaveChannel: (connection, stats) {
          log(connection.localUid.toString());
          _infoStrings.add(connection.localUid.toString());
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          _infoStrings.add(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
    setState(() {});

    await _engine!.setClientRole(
        role: widget.isHost
            ? ClientRoleType.clientRoleBroadcaster
            : ClientRoleType.clientRoleAudience);
    await _engine!.setupLocalVideo(VideoCanvas(uid: 0));
    await _engine!.enableVideo();
    await _engine!.startPreview();
    joinChannel();
  }

  joinChannel() async {
    log("here joining channel ${widget.data.channelId.length}  ${widget.data.channelToken}");
    await _engine!.joinChannel(
      token: "Test",
      channelId: token,
      options: ChannelMediaOptions(),
      uid: 0,
    );
    log("channel joined");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    endStream();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      context.read<StreamCubit>().leaveStream(widget.data.id);
    }
  }

  endStream() {
    _engine?.leaveChannel();
    _engine?.stopPreview();
    _engine?.release();
    log("Channel left");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<StreamCubit>().leaveStream(widget.data.id);
        return Future.value(false);
      },
      child: Container(
        child: Scaffold(
            // resizeToAvoidBottomInset: false,
            body: _engine == null
                ? Loader()
                : BlocConsumer<StreamCubit, StreamState>(
                    listener: (context, state) {
                      if (state is StreamLeftState) {
                        Navigator.pop(context);
                      }
                      if (state is StreamError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            elevation: 0,
                            // margin: EdgeInsets.only(top: kToolbarHeight),
                            // padding: EdgeInsets.only(
                            //    top: kToolbarHeight+5),
                            backgroundColor: Colors.transparent,
                            behavior: SnackBarBehavior.fixed,
                            dismissDirection: DismissDirection.horizontal,
                            content: MessageWidget(
                              message: state.error,
                              isError: true,
                            )));
                        Navigator.pop(context);
                      }
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      if (state is StreamInitialState) return Loader();
                      if (state is StreamJoinedState) {
                        return CustomScrollView(
                          slivers: [
                            LiveStreamAppBarWidget(
                              data: widget.data,
                            ),
                            SliverFillRemaining(
                              child: Center(
                                child: Stack(
                                  children: [
                                    widget.isHost
                                        ? Center(
                                            child:
                                                LocalUserView(engine: _engine!),
                                          )
                                        : Center(
                                            child: _remoteVideo(),
                                          ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          MessagesWidget(
                                              scrollController:
                                                  scrollController,
                                              infoStrings: _infoStrings),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller: messageController,
                                                decoration: MetaStyles
                                                    .formFieldDecoration(
                                                        "Send Message",
                                                        suffix: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: InkWell(
                                                            onTap: () {
                                                              _infoStrings.add(
                                                                  messageController
                                                                      .text);
                                                              setState(() {});
                                                              log(_infoStrings
                                                                  .toString());
                                                              scrollController.animateTo(
                                                                  scrollController
                                                                      .position
                                                                      .maxScrollExtent,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .easeIn);
                                                            },
                                                            child: CircleAvatar(
                                                              radius: 10,
                                                              backgroundColor:
                                                                  MetaColors
                                                                      .primaryColor,
                                                              child: Icon(
                                                                Icons.send,
                                                                color: Colors
                                                                    .white,
                                                                size: 19,
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    },
                  )),
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      log("Hereeeeeeeee");
      return Container(
        color: Colors.red,
        height: 700,
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine!,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(channelId: widget.data.channelId),
          ),
        ),
      );
    } else {
      return const Text(
        'Please wait for Host to join',
        textAlign: TextAlign.center,
      );
    }
  }
}

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({
    Key? key,
    required this.scrollController,
    required List<String> infoStrings,
  })  : _infoStrings = infoStrings,
        super(key: key);

  final ScrollController scrollController;
  final List<String> _infoStrings;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .5,
        height: MediaQuery.of(context).size.height * .25,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              // reverse: true,
              controller: scrollController,
              itemCount: _infoStrings.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      )),
                );
              }),
        ),
      ),
    );
  }
}

class LiveStreamAppBarWidget extends StatelessWidget {
  const LiveStreamAppBarWidget({Key? key, required this.data})
      : super(key: key);
  final StreamModel data;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // collapsedHeight: 100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: IconButton(
        icon: Icon(Icons.logout),
        onPressed: () {
          context.read<StreamCubit>().leaveStream(data.id);
        },
      ),
      title: Text(data.title),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 20,
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Text(
                    "Live",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient:
                      LinearGradient(colors: [Colors.redAccent, Colors.red])),
            ),
          ),
        )
      ],
    );
  }
}
