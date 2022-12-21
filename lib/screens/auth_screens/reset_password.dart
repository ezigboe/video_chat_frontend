import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_chat/cubits/auth_cubit/auth_cubit.dart';
import 'package:video_chat/utils/meta_colors.dart';
import 'package:video_chat/utils/validators.dart';

import 'auth_helper_widgets.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController codeController = TextEditingController();
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
                          title: "Reset Password?",
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SubtitleWidget(
                            title:
                                "Enter the code from email and update your new Password"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormFieldWidget(
                        enabled: !(state is AuthTempLoader),
                        textController: codeController,
                        label: "Code",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter a code";
                          }
                          return null;
                        },
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
                      CustomButton(
                        loading: (state is AuthTempLoader),
                        label: "Confirm",
                        handler: () {
                          if (!_formKey.currentState!.validate()) return;
                          context.read<AuthCubit>().confirmResetPassword(
                              codeController.text.trim(),
                              confirmPasswordController.text.trim());
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
