import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import 'auth_helper_widgets.dart';

class UserDetailsUpdate extends StatefulWidget {
  const UserDetailsUpdate({super.key});

  @override
  State<UserDetailsUpdate> createState() => _UserDetailsUpdateState();
}

class _UserDetailsUpdateState extends State<UserDetailsUpdate> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
                        title: "User Details.",
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SubtitleWidget(
                          title: "Enter your First Name and Last Name"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormFieldWidget(
                      enabled: !(state is AuthTempLoader),
                      textController: firstNameController,
                      label: "First Name",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter valid First Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormFieldWidget(
                      enabled: !(state is AuthTempLoader),
                      textController: lastNameController,
                      label: "Last Name",
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter valid Last Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      loading: (state is AuthTempLoader),
                      label: "Update",
                      handler: () {
                        if (!_formKey.currentState!.validate()) return;
                        // context.read<AuthCubit>().signIn(
                        //     emailController.text.trim(),
                        //     passwordController.text.trim());
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
