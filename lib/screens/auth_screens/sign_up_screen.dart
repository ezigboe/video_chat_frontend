import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_chat/cubits/auth_cubit/auth_cubit.dart';
import 'package:video_chat/screens/auth_screens/auth_helper_widgets.dart';
import 'package:video_chat/utils/meta_colors.dart';
import 'package:video_chat/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.pageController.jumpToPage(0);
        return Future.value(false);
      },
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            title: InkWell(
              onTap: () {
                widget.pageController.jumpToPage(0);
              },
              child: Card(
                shadowColor: MetaColors.formFieldColor,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: MetaColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
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
                          title: "Sign Up.",
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SubtitleWidget(
                            title: "Enter your Email and Password to Sign Up"),
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
                      FormFieldWidget(
                        enabled: !(state is AuthTempLoader),
                        textController: confirmPasswordController,
                        label: "Confirm Password",
                        obscureText: true,
                        validator: (value) {
                          return validateConfirmPassword(
                              value, passwordController.text.trim());
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        loading: (state is AuthTempLoader),
                        label: "Sign Up",
                        handler: () {
                          if (!_formKey.currentState!.validate()) return;
                          context.read<AuthCubit>().signUp(
                              emailController.text.trim(),
                              passwordController.text.trim());
                        },
                      ),
                      AgreementWidget(),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.pageController.jumpToPage(0);
                            },
                            child: RichText(
                                text: TextSpan(
                                    text: "Already Registered? ",
                                    style: TextStyle(
                                        color: MetaColors.tertiaryTextColor,
                                        fontFamily: "Poppins",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                    children: [
                                  TextSpan(
                                      text: "Sign In.",
                                      style: TextStyle(
                                          color: MetaColors.primaryColor))
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
      ),
    );
  }
}
