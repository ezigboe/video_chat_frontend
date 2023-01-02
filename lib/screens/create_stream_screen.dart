import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:video_chat/cubits/create_stream/create_stream_cubit.dart';
import 'package:video_chat/cubits/stream_list/stream_list_cubit.dart';
import 'package:video_chat/repositories/stream_repository.dart';
import 'package:video_chat/screens/auth_screens/auth_helper_widgets.dart';
import 'package:video_chat/utils/helper_widgets.dart';
import 'package:video_chat/utils/meta_assets.dart';
import 'package:video_chat/utils/upload_media.dart';

class CreateStreamScreen extends StatefulWidget {
  const CreateStreamScreen({super.key});

  @override
  State<CreateStreamScreen> createState() => _CreateStreamScreenState();
}

class _CreateStreamScreenState extends State<CreateStreamScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  DateTime? startAt;
  DateTime? endAt;
  String imageUrl = "";
  SelectedMedia? selectedMedia;
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        // appBar: AppBar(),
        body: BlocProvider(
          create: (context) => CreateStreamCubit(
              context.read<StreamListCubit>(),
              context.read<StreamRepository>()),
          child: BlocConsumer<CreateStreamCubit, CreateStreamState>(
            listener: ((context, state) {
              if (state is CreateStreamError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    elevation: 0,
                    // margin: EdgeInsets.only(top: kToolbarHeight),
                    // padding: EdgeInsets.only(
                    //    top: kToolbarHeight+5),
                    backgroundColor: Colors.transparent,
                    behavior: SnackBarBehavior.fixed,
                    dismissDirection: DismissDirection.horizontal,
                    content: MessageWidget(
                      message: state.error,
                      isError: true,
                    )));
              }
              if (state is CreateStreamSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    elevation: 0,
                    // margin: EdgeInsets.only(top: kToolbarHeight),
                    // padding: EdgeInsets.only(
                    //    top: kToolbarHeight+5),
                    backgroundColor: Colors.transparent,
                    behavior: SnackBarBehavior.fixed,
                    dismissDirection: DismissDirection.horizontal,
                    content: MessageWidget(
                      message: state.message,
                      isError: false,
                    )));
                Navigator.pop(context);
              }
            }),
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
                          title: "Schedule a Stream.",
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SubtitleWidget(
                            title:
                                "Enter stream title ,start time and end time"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: state is CreateStreamLoading
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
                            width: MediaQuery.of(context).size.width * .8,
                            height: MediaQuery.of(context).size.height * .2,
                            child: Image.asset(selectedMedia == null
                                ? MetaAssets.dummyProfileImage
                                : imageUrl)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormFieldWidget(
                        enabled: !(state is CreateStreamLoading),
                        textController: titleController,
                        label: "Title",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter valid title";
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
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 7)));
                          if (dateTime != null) {
                            startAt = dateTime;
                            TimeOfDay? time = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (time != null) {
                              startAt = dateTime.add(Duration(
                                hours: time.hour,
                                minutes: time.minute,
                              ));
                              setState(() {
                                startDateController.text =
                                    DateFormat("MMM dd , yyyy hh:mm a")
                                        .format(startAt!);
                              });
                            }
                          }
                        },
                        enabled: !(state is CreateStreamLoading),
                        textController: startDateController,
                        label: "Stream Start At",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter valid Start Date";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormFieldWidget(
                        readOnly: true,
                        onTap: startAt == null
                            ? null
                            : () async {
                                DateTime? dateTime = await showDatePicker(
                                    initialEntryMode:
                                        DatePickerEntryMode.calendarOnly,
                                    context: context,
                                    initialDate: startAt!,
                                    firstDate: startAt!,
                                    lastDate: startAt!.add(Duration(hours: 5)));
                                if (dateTime != null) {
                                  TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                  if (time != null) {
                                    endAt = dateTime.add(Duration(
                                      hours: time.hour,
                                      minutes: time.minute,
                                    ));
                                    setState(() {
                                      endDateController.text =
                                          DateFormat("MMM dd , yyyy hh:mm a")
                                              .format(endAt!);
                                    });
                                  }
                                }
                              },
                        enabled: !(state is CreateStreamLoading),
                        textController: endDateController,
                        label: "Stream End At",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter valid End Date";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        loading: (state is CreateStreamLoading),
                        label: "Create",
                        handler: () {
                          if (!_formKey.currentState!.validate()) return;

                          context.read<CreateStreamCubit>().createStream(
                              titleController.text.trim(), startAt!, endAt!,
                              media: selectedMedia);
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
      ),
    );
  }
}
