import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_chat/cubits/auth_cubit/auth_cubit.dart';
import 'package:video_chat/utils/meta_colors.dart';
import 'package:video_chat/utils/meta_styles.dart';
import 'package:video_chat/utils/validators.dart';

import 'auth_helper_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.pageController});
  final PageController pageController;
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TitleWidget(
                        title: "Sign In.",
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SubtitleWidget(
                          title: "Enter your Email and Password to Sign In"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormFieldWidget(
                      enabled: !(state is AuthTempLoader),
                      textController: emailController,
                      label: "Email Address",
                      validator: validateEmail,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormFieldWidget(
                      enabled: !(state is AuthTempLoader),
                      textController: passwordController,
                      label: "Password",
                      obscureText: true,
                      validator: validatePassword,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      loading: (state is AuthTempLoader),
                      label: "Sign In",
                      handler: () {
                        if(!_formKey.currentState!.validate())return;
                        context.read<AuthCubit>().signIn(emailController.text.trim(), passwordController.text.trim());
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {
                              widget.pageController.jumpToPage(2);
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            widget.pageController.jumpToPage(1);
                          },
                          child: RichText(
                              text: TextSpan(
                                  text: "New User? ",
                                  style: TextStyle(
                                      color: MetaColors.tertiaryTextColor,
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                  children: [
                                TextSpan(
                                    text: "Sign Up.",
                                    style:
                                        TextStyle(color: MetaColors.primaryColor))
                              ])),
                        ),
                      ),
                    )
                  ],
                )),
              ),
            );
          },
        ),
      ),
    );
  }
}
