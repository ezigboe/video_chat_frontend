import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:video_chat/utils/constants.dart';
import 'package:video_chat/utils/helper_widgets.dart';
import 'package:video_chat/utils/meta_assets.dart';
import 'package:video_chat/utils/meta_styles.dart';
import 'package:video_chat/utils/upload_media.dart';

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
  SelectedMedia? selectedMedia;
  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        // appBar: AppBar(),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthUserDetailsPending) {
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    elevation: 0,
                    // margin: EdgeInsets.only(top: kToolbarHeight),
                    // padding: EdgeInsets.only(
                    //    top: kToolbarHeight+5),
                    backgroundColor: Colors.transparent,
                    behavior: SnackBarBehavior.fixed,
                    dismissDirection: DismissDirection.horizontal,
                    content: MessageWidget(
                      message: state.error!,
                      isError: true,
                    )));
              }
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .1,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: state is AuthTempLoader
                            ? null
                            : () async {
                                selectedMedia =
                                    await selectMediaWithSourceBottomSheet(
                                  context: context,
                                  allowPhoto: true,
                                  allowVideo: false,
                                  pickerFontFamily: 'Cormorant Garamond',
                                );
                                if (selectedMedia != null &&
                                    validateFileFormat(
                                        selectedMedia!.storagePath, context)) {
                                  setState(() {
                                    imageUrl = selectedMedia!.localPath;
                                  });
                                }
                              },
                        child: Container(
                          // width: MediaQuery.of(context).size.width * .8,
                          // height: MediaQuery.of(context).size.height * .2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: selectedMedia == null
                                ? Image(
                                    image: AssetImage(
                                        MetaAssets.dummyProfileImage),
                                  )
                                : Image(image: FileImage(File(imageUrl))),
                          ),
                        ),
                      ),
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
                        if (selectedMedia == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              elevation: 0,
                              // margin: EdgeInsets.only(top: kToolbarHeight),
                              // padding: EdgeInsets.only(
                              //    top: kToolbarHeight+5),
                              backgroundColor: Colors.transparent,
                              behavior: SnackBarBehavior.fixed,
                              dismissDirection: DismissDirection.horizontal,
                              content: MessageWidget(
                                message: "Please choose a profile picture",
                                isError: true,
                              )));
                          return;
                        }

                        context.read<AuthCubit>().updateUserDetails(
                            phoneNumberController.text.trim(),
                            nameController.text.trim(),
                            dob!,
                            gender,
                            selectedMedia!);
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
