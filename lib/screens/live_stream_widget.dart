import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:video_chat/auth.dart';
import 'package:video_chat/cubits/auth_cubit/auth_cubit.dart';
import 'package:video_chat/cubits/stream_list/stream_list_cubit.dart';
import 'package:video_chat/models/stream_model/stream_model.dart';
import 'package:video_chat/screens/auth_screens/auth_helper_widgets.dart';
import 'package:video_chat/screens/live_stream_screen.dart';
import 'package:video_chat/utils/helper_widgets.dart';
import 'package:video_chat/utils/meta_assets.dart';
import 'package:video_chat/utils/meta_colors.dart';

import 'live_stream_detail_screen.dart';

class StreamGridWidget extends StatelessWidget {
  const StreamGridWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StreamListCubit, StreamListState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is StreamListError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              behavior: SnackBarBehavior.fixed,
              dismissDirection: DismissDirection.horizontal,
              content: MessageWidget(
                message: state.error,
                isError: true,
              )));
        }
      },
      builder: (context, state) {
        if (state is StreamListLoaded) {
          if (state.data.isEmpty) {
            return SliverToBoxAdapter(
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SubtitleWidget(title: "No Live Streams"),
              )),
            );
          }
          return SliverGrid(
              delegate: SliverChildBuilderDelegate(((context, index) {
                return StreamTileWidget(data: state.data[index]);
              }), childCount: state.data.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2));
        }
        return SliverToBoxAdapter(child: Loader());
      },
    );
  }
}

class StreamTileWidget extends StatefulWidget {
  const StreamTileWidget({
    Key? key,
    required this.data,
  }) : super(key: key);
  final StreamModel data;

  @override
  State<StreamTileWidget> createState() => _StreamTileWidgetState();
}

class _StreamTileWidgetState extends State<StreamTileWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LiveStreamDetailsScreen(
                      data: widget.data,
                    )));
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .4,
            height: MediaQuery.of(context).size.width * .5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                      position: DecorationPosition.foreground,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              colors: [Colors.black, Colors.transparent])),
                      child: widget.data.thumbnailUrl == null ||
                              widget.data.thumbnailUrl.trim().isEmpty
                          ? Image.asset(MetaAssets.dummyProfileImage,
                              fit: BoxFit.cover)
                          : CachedNetworkImage(
                              imageUrl: widget.data.thumbnailUrl,
                              fit: BoxFit.cover,
                            )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.5),
                          ]).createShader(bounds);
                        },
                        child: SizedBox(
                          height: 20,
                          child: widget.data.title.length < 18
                              ? Text(
                                  "${widget.data.title}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                )
                              : Marquee(
                                  text: "${widget.data.title}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 20.0,
                                  velocity: 50.0,
                                  pauseAfterRound: Duration(seconds: 1),
                                  startPadding: 10.0,
                                  accelerationDuration: Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      Duration(milliseconds: 100),
                                  decelerationCurve: Curves.easeOut,
                                ),
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder(
                      stream: context
                          .read<AuthCubit>()
                          .timer
                          ?.stream
                          .asBroadcastStream(),
                      initialData: DateTime.now(),
                      builder: (context, AsyncSnapshot time) {
                        if (time.hasData) {
                          log(time.toString());
                          if (widget.data.startAt
                                  .toLocal()
                                  .isBefore(time.data!) &&
                              widget.data.endAt.toLocal().isAfter(time.data!)) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      child: Text(
                                        "Live",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: LinearGradient(colors: [
                                          Colors.redAccent,
                                          Colors.red
                                        ])),
                                  )),
                            );
                          }
                        } else {
                          if (widget.data.startAt
                                  .toLocal()
                                  .isBefore(DateTime.now()!) &&
                              widget.data.endAt
                                  .toLocal()
                                  .isAfter(DateTime.now()!)) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      child: Text(
                                        "Live",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: LinearGradient(colors: [
                                          Colors.redAccent,
                                          Colors.red
                                        ])),
                                  )),
                            );
                          }
                        }
                        return SizedBox.shrink();
                      }),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.5),
                                  ]).createShader(bounds);
                                },
                                child: Text(
                                  "${widget.data.hostName}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(20)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8, right: 8),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(colors: [
                                      MetaColors.primaryColor,
                                      Colors.white.withOpacity(0.5)
                                    ])),
                                child: Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: widget.data.hostProfileImage != null &&
                                          widget
                                              .data.hostProfileImage.isNotEmpty
                                      ? CircleAvatar(
                                          radius: 16,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  widget.data.hostProfileImage))
                                      : CircleAvatar(
                                          radius: 16,
                                          backgroundImage: AssetImage(
                                              MetaAssets.dummyProfileImage),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LiveStreamingTitleWidget extends StatelessWidget {
  const LiveStreamingTitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            TVIconWidget(),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 0, bottom: 0),
              child: Text(
                "Live Streams",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TVIconWidget extends StatefulWidget {
  const TVIconWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TVIconWidget> createState() => _TVIconWidgetState();
}

class _TVIconWidgetState extends State<TVIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    )
      ..forward()
      ..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
      child: AnimatedBuilder(
          animation: CurvedAnimation(parent: controller, curve: Curves.easeIn)
            ..drive(Tween<double>(begin: 0, end: 1)),
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: ((bounds) {
                return LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        stops: [controller.value, 0.9, 1 - controller.value],
                        colors: [Colors.red, Colors.grey.shade100, Colors.red])
                    .createShader(bounds);
              }),
              child: Icon(Icons.live_tv_rounded, color: Colors.white),
            );
          }),
    );
  }
}

class LiveProgressWidget extends StatefulWidget {
  const LiveProgressWidget({super.key});

  @override
  State<LiveProgressWidget> createState() => _LiveProgressWidgetState();
}

class _LiveProgressWidgetState extends State<LiveProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    )
      ..forward()
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
      child: AnimatedBuilder(
          animation: CurvedAnimation(parent: controller, curve: Curves.elasticOut)
            ..drive(Tween<double>(begin: 0, end: 1)),
          builder: (context, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.red,
                value: controller.value,
              ),
            );
          }),
    );
  }
}
