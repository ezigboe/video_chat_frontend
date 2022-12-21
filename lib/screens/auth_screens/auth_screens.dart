import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_chat/cubits/auth_cubit/auth_cubit.dart';
import 'package:video_chat/screens/auth_screens/forgot_password.dart';
import 'package:video_chat/screens/auth_screens/reset_password.dart';
import 'package:video_chat/screens/auth_screens/sign_in_screen.dart';
import 'package:video_chat/screens/auth_screens/sign_up_screen.dart';

class AuthScreens extends StatefulWidget {
  const AuthScreens({super.key});

  @override
  State<AuthScreens> createState() => _AuthScreensState();
}

class _AuthScreensState extends State<AuthScreens> {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetEmailSent) {
          if (pageController.hasClients) {
            pageController.jumpToPage(0);
          }
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          child: Scaffold(
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                SignInScreen(pageController: pageController),
                SignUpScreen(pageController: pageController),
                ForgotPassword(
                  pageController: pageController,
                ),
                ResetPassword(pageController: pageController)
              ],
            ),
          ),
        );
      },
    );
  }
}
