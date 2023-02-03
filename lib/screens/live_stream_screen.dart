import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_chat/auth.dart';
import 'package:video_chat/cubits/auth_cubit/auth_cubit.dart';
import 'package:video_chat/cubits/stream/stream_cubit.dart';
import 'package:video_chat/models/stream_chat_model/stream_chat_model.dart';
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
  List<StreamChatModel> _infoStrings = [];
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
          // _infoStrings.add("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          log("remote user $remoteUid joined");
          // _infoStrings.add("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          log("remote user $remoteUid left channel");
          // _infoStrings.add("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onError: (type, error) {
          log("$type erroooooor ${error}");
        },
        onLeaveChannel: (connection, stats) {
          log(connection.localUid.toString());
          // _infoStrings.add(connection.localUid.toString());
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          // _infoStrings.add(
          //     '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
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
    log("here joining channel ${widget.data.channelId}  ${widget.data.channelToken}");
    await _engine!.joinChannel(
      token: widget.data.channelToken,
      channelId: widget.data.channelId,
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      log("Paused-------------");
      context.read<StreamCubit>().leaveStream();
    }
  }

  endStream() {
    _engine?.leaveChannel();
    _engine?.stopPreview();
    _engine?.release();
    log("Channel left");
  }

  bool showChat = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<StreamCubit>().leaveStream();
        return Future.value(false);
      },
      child: Container(
        child: Scaffold(
            // resizeToAvoidBottomInset: false,
            body: _engine == null
                ? Center(child: Loader())
                : BlocConsumer<StreamCubit, StreamState>(
                    listener: (context, state) {
                      if (state is StreamLeftState) {
                        Navigator.pop(context);
                      }
                      if (state is StreamError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            elevation: 0,
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
                            // LiveStreamAppBarWidget(
                            //   data: widget.data,
                            // ),
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
                                    Visibility(
                                      visible: showChat,
                                      replacement: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              showChat = true;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.black,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    CupertinoIcons.arrow_up,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  showChat = false;
                                                  if (scrollController
                                                      .hasClients) {
                                                    scrollController.animateTo(
                                                        scrollController
                                                                .position
                                                                .maxScrollExtent +
                                                            100,
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.easeIn);
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.black,
                                                  child: Icon(
                                                    CupertinoIcons
                                                        .arrow_down,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            MessagesWidget(
                                                scrollController:
                                                    scrollController,
                                                infoStrings: _infoStrings),
                                            StreamChatField(
                                                messageController:
                                                    messageController),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: MediaQuery.of(context).padding,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ExitStreamIcon(),
                                          StreamLiveIcon()
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
      return Container(
        // color: Colors.red,
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

class StreamLiveIcon extends StatelessWidget {
  const StreamLiveIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 20,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
            gradient: LinearGradient(colors: [Colors.redAccent, Colors.red])),
      ),
    );
  }
}

class ExitStreamIcon extends StatelessWidget {
  const ExitStreamIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.logout,
        color: Colors.black,
      ),
      onPressed: () {
        context.read<StreamCubit>().leaveStream();
      },
    );
  }
}

class StreamChatField extends StatelessWidget {
  const StreamChatField({
    Key? key,
    required this.messageController,
  }) : super(key: key);

  final TextEditingController messageController;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            style: MetaStyles.labelStyle.copyWith(color: Colors.white),
            controller: messageController,
            decoration: MetaStyles.formFieldDecoration("Send Message",
                    suffix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          log("heree");
                          AuthLoggedIn state =
                              (context.read<AuthCubit>().state as AuthLoggedIn);
                          context.read<StreamCubit>().sendMessage(
                              messageController.text,
                              state.userData.id,
                              state.userData.fullName,
                              state.userData.profileImage);
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
                    ))
                .copyWith(
                    labelStyle:
                        MetaStyles.labelStyle.copyWith(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

class MessagesWidget extends StatefulWidget {
  const MessagesWidget({
    Key? key,
    required this.scrollController,
    required List<StreamChatModel> infoStrings,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  List<StreamChatModel> _infoStrings = [];
  late StreamSubscription<StreamChatModel> streamSubscription;
  @override
  void initState() {
    log("init building");
    super.initState();
    getData();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  getData() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.scrollController.hasClients) {
        widget.scrollController.animateTo(
            widget.scrollController.position.maxScrollExtent + 1000,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn);
      }
      _infoStrings = context.read<StreamCubit>().streamMessages;
      setState(() {});
      streamSubscription = context
          .read<StreamCubit>()
          .messageStreamController
          .stream
          .listen((event) {
        setState(() {
          _infoStrings = context.read<StreamCubit>().streamMessages;
        });
        if (widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
              widget.scrollController.position.maxScrollExtent + 100,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: _infoStrings.isEmpty
          ? SizedBox.shrink()
          : SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.height * .25,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    // reverse: true,
                    controller: widget.scrollController,
                    itemCount: _infoStrings.length,
                    itemBuilder: (context, index) {
                      return ChatTile(chat: _infoStrings[index]);
                    }),
              ),
            ),
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key? key,
    required StreamChatModel chat,
  })  : chat = chat,
        super(key: key);

  final StreamChatModel chat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white38, borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0)
                            .copyWith(right: 0, bottom: 0),
                        child: CircleAvatar(
                            radius: 5,
                            backgroundImage: CachedNetworkImageProvider(
                                chat.fromImageUrl ?? "")),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(
                            8.0,
                          ).copyWith(left: 4, bottom: 0),
                          child: Text(
                            chat.fromName ?? '',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0).copyWith(top: 5),
                    child: Text(
                      chat.message ?? '',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          )),
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
          context.read<StreamCubit>().leaveStream();
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
