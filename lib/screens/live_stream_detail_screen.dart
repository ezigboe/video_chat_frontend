import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_chat/models/stream_model/stream_model.dart';
import 'package:video_chat/screens/auth_screens/auth_helper_widgets.dart';
import 'package:video_chat/screens/create_stream_screen.dart';
import 'package:video_chat/screens/live_stream_screen.dart';

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
          appBar: AppBar(),
          floatingActionButton: FloatingActionButton(
              child: Icon(CupertinoIcons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateStreamScreen()));
              }),
          body: Container(
            child: Column(
              children: [
                CachedNetworkImage(imageUrl: widget.data.thumbnailUrl),
                Text(widget.data.title),
                Text("Starts At ${DateFormat('MM dd, yyyy hh:mm A')}"),
                Center(
                  child: CustomButton(
                      handler: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LiveStreamScreen()));
                      },
                      label: "Join"),
                ),
              ],
            ),
          )),
    );
  }
}
