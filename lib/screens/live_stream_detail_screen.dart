import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:video_chat/cubits/auth_cubit/auth_cubit.dart';
import 'package:video_chat/cubits/stream/stream_cubit.dart';
import 'package:video_chat/models/stream_model/stream_model.dart';
import 'package:video_chat/screens/auth_screens/auth_helper_widgets.dart';
import 'package:video_chat/screens/create_stream_screen.dart';
import 'package:video_chat/screens/live_stream_screen.dart';
import 'package:video_chat/screens/live_stream_widget.dart';
import 'package:video_chat/utils/meta_assets.dart';
import 'package:video_chat/utils/meta_colors.dart';
import 'package:video_chat/utils/meta_styles.dart';

class LiveStreamDetailsScreen extends StatefulWidget {
  final StreamModel data;
  const LiveStreamDetailsScreen({super.key, required this.data});

  @override
  State<LiveStreamDetailsScreen> createState() =>
      _LiveStreamDetailsScreenState();
}

class _LiveStreamDetailsScreenState extends State<LiveStreamDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: Container(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .1,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TitleWidget(
                        title: "${widget.data.title}.",
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: widget.data.thumbnailUrl != null &&
                                widget.data.thumbnailUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: widget.data.thumbnailUrl)
                            : Image.asset(MetaAssets.dummyProfileImage),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0)
                                      .copyWith(bottom: 0),
                                  child: Text(
                                    "Starts on",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: MetaColors.tertiaryTextColor),
                                  ),
                                ),
                                //
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${DateFormat('MMM dd, yyyy hh:mm a').format(widget.data.startAt)}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.data.startAt.isBefore(DateTime.now()) &&
                              widget.data.endAt.isAfter(DateTime.now()))
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 40, child: LiveProgressWidget()),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "Live",
                                  style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0)
                                      .copyWith(bottom: 0),
                                  child: Text(
                                    "Ends on",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: MetaColors.tertiaryTextColor),
                                  ),
                                ),
                                //
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${DateFormat('MMM dd, yyyy hh:mm a').format(widget.data.endAt)}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: MetaColors.formFieldColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Hosted By",
                                    style: MetaStyles.labelStyle.copyWith(
                                        fontSize: 12,
                                        color: MetaColors.tertiaryTextColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    DecoratedBox(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: CircleAvatar(
                                                radius: 16,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  widget.data.hostProfileImage,
                                                )))),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${widget.data.hostName}",
                                        style: MetaStyles.labelStyle
                                            .copyWith(fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // if (widget.data.startAt.isBefore(DateTime.now()) &&
            //     widget.data.endAt.isAfter(DateTime.now()))
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CustomButton(
                          handler: () {
                            if (state is AuthLoggedIn) {
                              context
                                  .read<StreamCubit>()
                                  .joinStream(widget.data);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LiveStreamScreen(
                                          user: state.userData,
                                          data: widget.data,
                                          isHost: widget.data.hostId ==
                                              state.userData.id)));
                            }
                          },
                          label: "Join"),
                    ),
                  );
                },
              ),
          ],
        ),
      )),
    );
  }
}
