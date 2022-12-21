import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_chat/cubits/auth_cubit/auth_cubit.dart';
import 'package:video_chat/utils/meta_colors.dart';
import 'package:video_chat/utils/validators.dart';

import 'auth_helper_widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
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
                          title: "Forgot Password?",
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SubtitleWidget(
                            title:
                                "Enter your Email to receive password reset link"),
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
                      CustomButton(
                        loading: (state is AuthTempLoader),
                        label: "Send Password Reset Link",
                        handler: () {
                          if (!_formKey.currentState!.validate()) return;
                          context
                              .read<AuthCubit>()
                              .forgotPassword(emailController.text.trim());
                        },
                      ),
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
