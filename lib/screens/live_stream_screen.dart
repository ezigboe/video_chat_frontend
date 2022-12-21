import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_chat/screens/home_screen.dart';
import 'package:video_chat/utils/agora_config.dart';
import 'package:video_chat/utils/meta_colors.dart';
import 'package:video_chat/utils/meta_styles.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({super.key});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  List<String> _infoStrings = [];
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

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
          _infoStrings.add("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          _infoStrings.add("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
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

    await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    // await _engine.setupLocalVideo(VideoCanvas(uid: 3));
    await _engine.enableVideo();
    await _engine.startPreview();
    log("here");
    await _engine.joinChannel(
      token: token,
      channelId: "Test",
      options: ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleAudience),
      uid: 3,
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
          // resizeToAvoidBottomInset: false,
          body: CustomScrollView(
        slivers: [
          AppBarWidget(),
          SliverFillRemaining(
            child: Center(
              child: Stack(
                children: [
                  Center(
                    child: _remoteVideo(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MessagesWidget(scrollController: scrollController, infoStrings: _infoStrings),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: messageController,
                            decoration: MetaStyles.formFieldDecoration(
                                "Send Message",
                                suffix: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      _infoStrings.add(messageController.text);
                                      setState(() {});
                                      log(_infoStrings.toString());
                                      scrollController.animateTo(
                                          scrollController
                                              .position.maxScrollExtent,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeIn);
                                    },
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: MetaColors.primaryColor,
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                    ),
                                  ),
                                )),
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
      )),
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
            rtcEngine: _engine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: const RtcConnection(channelId: "Test"),
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
  }) : _infoStrings = infoStrings, super(key: key);

  final ScrollController scrollController;
  final List<String> _infoStrings;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        width:MediaQuery.of(context).size.width*.5,
        height:MediaQuery.of(context).size.height*.25,
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
                          borderRadius:
                              BorderRadius.circular(12)),
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
