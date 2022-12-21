import 'package:flutter/material.dart';
import 'package:video_chat/screens/chat_window.dart';
import 'package:video_chat/utils/meta_assets.dart';
import 'package:video_chat/utils/meta_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final key = GlobalKey<SliverAnimatedListState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text(
                "Chats.",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 80,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: ((context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage(MetaAssets.dummyProfileImage),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Shashanka",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ))),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Messages.",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SliverAnimatedList(
                key: key,
                initialItemCount: 80,
                itemBuilder: ((context, index, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatWindow()));
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundImage:
                                      AssetImage(MetaAssets.dummyProfileImage),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0)
                                            .copyWith(bottom: 2),
                                        child: Text(
                                          "Vaibhav",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0)
                                            .copyWith(top: 0),
                                        child: Text(
                                          "Hey there?",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color:
                                                  MetaColors.secondaryTextColor,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }))
          ],
        ),
      ),
    );
  }
}
