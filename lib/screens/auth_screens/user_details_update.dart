import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:video_chat/utils/constants.dart';
import 'package:video_chat/utils/meta_styles.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import 'auth_helper_widgets.dart';

class UserDetailsUpdate extends StatefulWidget {
  const UserDetailsUpdate({super.key});

  @override
  State<UserDetailsUpdate> createState() => _UserDetailsUpdateState();
}

class _UserDetailsUpdateState extends State<UserDetailsUpdate> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  String gender = "Cis Female";
  DateTime? dob;
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
                          title: "Enter your Name, Date of Birth and Gender"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormFieldWidget(
                      enabled: !(state is AuthTempLoader),
                      textController: nameController,
                      label: "Full Name",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter valid Full Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormFieldWidget(
                      enabled: !(state is AuthTempLoader),
                      isPhone: true,
                      textController: phoneNumberController,
                      label: "Phone Number",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter valid Phone Number";
                        }
                        if (value.trim().length != 10) {
                          return "Phone number must be 10 digits";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormFieldWidget(
                      readOnly: true,
                      onTap: () async {
                        DateTime? dateTime = await showDatePicker(
                            context: context,
                            initialDate: DateTime(DateTime.now().year - 25),
                            firstDate: DateTime(1947),
                            lastDate: DateTime(DateTime.now().year - 18));
                        if (dateTime != null) {
                          setState(() {
                            dob = dateTime;
                            dobController.text =
                                DateFormat("MMM dd , yyyy").format(dateTime);
                          });
                        }
                      },
                      enabled: !(state is AuthTempLoader),
                      textController: dobController,
                      label: "Date Of Birth",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter valid Date Of Birth";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                          borderRadius: BorderRadius.circular(20),
                          alignment: AlignmentDirectional.centerStart,
                          style: MetaStyles.labelStyle
                              .copyWith(fontFamily: "Poppins"),
                          decoration: MetaStyles.formFieldDecoration("Gender"),
                          value: gender,
                          items: genders
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e,
                                      style: MetaStyles.labelStyle,
                                    ),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if ((state is AuthTempLoader)) return;
                            setState(() {
                              gender = value!;
                            });
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      loading: (state is AuthTempLoader),
                      label: "Update",
                      handler: () {
                        if (!_formKey.currentState!.validate()) return;

                        context.read<AuthCubit>().updateUserDetails({
                          "phone": phoneNumberController.text.trim(),
                          "full_name": nameController.text.trim(),
                          "dob": dob!.toIso8601String(),
                          "gender": gender
                        });
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
