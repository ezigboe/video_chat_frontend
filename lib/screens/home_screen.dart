import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_chat/cubits/stream_list/stream_list_cubit.dart';
import 'package:video_chat/screens/auth_screens/user_details_update.dart';
import 'package:video_chat/screens/chat_screen.dart';
import 'package:video_chat/screens/create_stream_screen.dart';
import 'package:video_chat/screens/live_stream_screen.dart';
import 'package:video_chat/screens/live_stream_widget.dart';
import 'package:video_chat/screens/profile_screen.dart';
import 'package:video_chat/screens/video_call_screen.dart';
import 'package:video_chat/utils/meta_assets.dart';
import 'package:video_chat/utils/meta_colors.dart';

import '../cubits/auth_cubit/auth_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController pageController = PageController();
  @override
  void initState() {
    pageController.addListener(() {
      if (pageController.hasClients && pageController.page == 0 ||
          pageController.page == 1 ||
          pageController.page == 2)
        setState(() {
          _currentIndex = pageController.page!.toInt();
        });
    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<StreamListCubit>().getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is AuthUserDetailsPending) return UserDetailsUpdate();

        return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: ((value) {
                  setState(() {
                    _currentIndex = value;
                  });
                  pageController.jumpToPage(value);
                }),
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.video_camera_solid),
                      label: "Random"),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.chat_bubble_text),
                      label: "Chats")
                ]),
            body: PageView(
              controller: pageController,
              children: [
                Home(
                  pageController: pageController,
                ),
                VideoCallScreen(),
                ChatScreen()
              ],
            )
            // This trailing comma makes auto-formatting nicer for build methods.
            );
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.pageController}) : super(key: key);
  final PageController pageController;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  TextStyle appBarStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black);
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            showAppBar = true;
            TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black);
          });
        } else if (status == AnimationStatus.dismissed) {
          setState(() {
            showAppBar = false;
            appBarStyle = TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white);
          });
        }
      });
  }

  bool showAppBar = false;
  var initialStyle = TextStyle(
      fontFamily: "Poppins",
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white);
  var finalStyle = TextStyle(
      fontFamily: "Poppins",
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
                    child: Icon(CupertinoIcons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateStreamScreen()));
                    }),
      body: Container(
        child: Stack(
          // fit: StackFit.expand,
          children: [
            DecoratedBoxTransition(
              position: DecorationPosition.background,
              decoration: DecorationTween(
                      begin: BoxDecoration(color: MetaColors.primaryColor),
                      end: BoxDecoration(color: Colors.white))
                  .animate(controller),
              child: Scaffold(
                  
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(right: 0),
                      child: ProfileImage(),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(left: 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return DefaultTextStyleTransition(
                                    child: Text(
                                        "Hi, ${state is AuthLoggedIn ? state.userData.fullName ?? "User" : "User"}"),
                                    style: CurvedAnimation(
                                            parent: controller,
                                            curve: Curves.elasticOut)
                                        .drive(TextStyleTween(
                                            begin: initialStyle,
                                            end: finalStyle)));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SideTile(
                          handler: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen()));
                          },
                          icon: Icon(
                            CupertinoIcons.person_alt,
                            color: Colors.white,
                          ),
                          title: "Profile",
                        ),
                        SideTile(
                          handler: () {},
                          icon: Icon(
                            CupertinoIcons.money_dollar_circle_fill,
                            color: Colors.white,
                          ),
                          title: "Wallet",
                        ),
                        SideTile(
                          handler: () {},
                          icon: Icon(
                            CupertinoIcons.doc_chart_fill,
                            color: Colors.white,
                          ),
                          title: "Privacy Policy",
                        ),
                        SideTile(
                          handler: () {
                            context.read<AuthCubit>().signOut();
                          },
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          title: "Logout ",
                        )
                      ],
                    ),
                  )),
            ),
            SlideTransition(
              position: CurvedAnimation(parent: controller, curve: Curves.easeIn)
                  .drive(Tween(
                      begin: Offset(0.45, 0),
                      end: Offset(
                        0,
                        0,
                      ))),
              child: ScaleTransition(
                scale: CurvedAnimation(parent: controller, curve: Curves.easeIn)
                    .drive(Tween(begin: .85, end: 1)),
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0) {
                      if (controller.isCompleted) {
                        controller.reverse();
                      }
                    } else {
                      if (controller.isDismissed) {
                        controller.forward();
                      } else {
                        if (!controller.isAnimating)
                          widget.pageController.animateToPage(1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                      }
                    }
                  },
                  onTap: () {
                    if (controller.isDismissed) {
                      controller.forward();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1.8 * kToolbarHeight),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            if (!showAppBar)
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5)
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: CustomScrollView(
                        slivers: [
                          // if (showAppBar)
                          //   AppBarWidget(
                          //     animationController: controller,
                          //   )
                          // else
                          //   SliverPadding(padding: MediaQuery.of(context).padding),
                          LiveStreamingTitleWidget(),
                          StreamGridWidget()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return DecoratedBox(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Padding(
              padding: EdgeInsets.all(5.0),
              child: (state is AuthLoggedIn)
                  ? CircleAvatar(
                      radius: 16,
                      backgroundImage: CachedNetworkImageProvider(
                        state.userData.profileImage,
                      ))
                  : CircleAvatar(
                      radius: 16,
                      backgroundImage:
                          AssetImage(MetaAssets.dummyProfileImage))),
        );
      },
    );
  }
}

class SideTile extends StatelessWidget {
  const SideTile(
      {Key? key, required this.icon, required this.title, this.handler})
      : super(key: key);
  final Icon icon;
  final String title;
  final VoidCallback? handler;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        minLeadingWidth: 0,
        contentPadding: EdgeInsets.zero,
        onTap: handler,
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // collapsedHeight: 100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(right: 0),
        child: InkWell(
          onTap: () {
            // Scaffold.of(context).openDrawer();
            if (animationController != null) {
              if (animationController!.isCompleted) {
                animationController!.reverse();
              } else if (animationController!.isDismissed) {
                animationController!.forward();
              }
            }
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  MetaColors.primaryColor,
                  MetaColors.primaryColor.withOpacity(0.5)
                ])),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(MetaAssets.dummyProfileImage),
              ),
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return Text(
                  "Hi, ${state is AuthLoggedIn ? state.userData.fullName ?? "User" : "User"}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: MetaColors.textColor),
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
            icon: const Icon(
              Icons.notifications_outlined,
              // color: Colors.teal,
            ))
      ],
    );
  }
}
