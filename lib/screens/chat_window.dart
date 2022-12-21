import 'package:flutter/material.dart';
import 'package:video_chat/utils/meta_colors.dart';
import 'package:video_chat/utils/meta_styles.dart';

class ChatWindow extends StatefulWidget {
  const ChatWindow({super.key});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  TextEditingController messageController = TextEditingController();
  final sliverListKey = GlobalKey<SliverAnimatedListState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  title: Text(
                    "Vaibhav",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: Colors.black),
                  ),
                ),
                SliverAnimatedList(
                    key: sliverListKey,
                    initialItemCount: 10,
                    itemBuilder: ((context, index, animation) {
                      return SizeTransition(
                          sizeFactor: animation,
                          child: ChatMessageWidget(
                            message: "Heyoo",
                            sender: true,
                          ));
                    }))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: messageController,
                decoration: MetaStyles.formFieldDecoration("Send",
                    suffix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
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
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final bool sender;
  const ChatMessageWidget(
      {super.key, required this.message, required this.sender});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sender ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: sender ? MetaColors.primaryColor : Colors.grey.shade100,
              borderRadius:sender? BorderRadius.circular(12).copyWith(bottomRight: Radius.circular(0)): BorderRadius.circular(12).copyWith(bottomLeft: Radius.circular(0))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: TextStyle(color:sender?Colors.white: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
