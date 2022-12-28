import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_chat/auth.dart';
import 'package:video_chat/cubits/auth_cubit/auth_cubit.dart';
import 'package:video_chat/screens/auth_screens/auth_helper_widgets.dart';
import 'package:video_chat/utils/meta_assets.dart';
import 'package:video_chat/utils/meta_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: Container(
        child: Column(
          children: [
            Expanded(
              child: Stack(children: [
                  Image.asset(
                  MetaAssets.dummyProfileImage,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * .4,
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoggedIn) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RichText(
                                            text: TextSpan(
                                              text:
                                                  "${state.userData.fullName} ",
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${DateTime.now().year - state.userData.dob.year} ${state.userData.gender}",
                                                  style: TextStyle(
                                                      color: MetaColors
                                                          .tertiaryTextColor,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                              style: TextStyle(
                                                  color: MetaColors.textColor,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${state.userData.diamondBalance} ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Icon(
                                                Icons.diamond_rounded,
                                                color: Colors.tealAccent,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: MetaColors.tertiaryTextColor
                                              .withOpacity(0.1)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "300",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  "Photos",
                                                  style: TextStyle(
                                                      color: MetaColors
                                                          .tertiaryTextColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "300",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  "Followers",
                                                  style: TextStyle(
                                                      color: MetaColors
                                                          .tertiaryTextColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "300",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  "Following",
                                                  style: TextStyle(
                                                      color: MetaColors
                                                          .tertiaryTextColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          height: MediaQuery.of(context).size.height * .65,
                          width: double.maxFinite,
                        ),
                      );
                    }
                    return Loader();
                  },
                ),
              ]),
            ),
            CustomButton(handler: () {}, label: "Follow")
          ],
        ),
      )),
    );
  }
}
