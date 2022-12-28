import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_chat/cubits/stream_list/stream_list_cubit.dart';
import 'package:video_chat/models/stream_model/stream_model.dart';
import 'package:video_chat/repositories/stream_repository.dart';
import 'package:video_chat/utils/upload_media.dart';

part 'create_stream_state.dart';

class CreateStreamCubit extends Cubit<CreateStreamState> {
  final StreamListCubit _streamListCubit;
  final StreamRepository _streamRepository;
  CreateStreamCubit(
      StreamListCubit streamListCubit, StreamRepository streamRepository)
      : _streamListCubit = streamListCubit,
        _streamRepository = streamRepository,
        super(CreateStreamLoading());

  createStream(String title, DateTime startAt, DateTime endAt,
      {SelectedMedia? media}) async {
    try {
      if (media != null) {
        Stream<TaskSnapshot> result =
            uploadData(media.storagePath, media.bytes);

        result.listen((data) async {
          log((data.bytesTransferred / data.totalBytes).toString());
          if (data.state == TaskState.running) {
            emit(CreateStreamUploading(
              (data.bytesTransferred / data.totalBytes),
            ));
          } else if (data.state == TaskState.success) {
            print("success");
            String url = await data.ref.getDownloadURL();
            if (url.isNotEmpty) {
              StreamModel? stream = await _streamRepository.createStream(
                  title: title,
                  startAt: startAt,
                  endAt: endAt,
                  thumbnailUrl: url);
              _streamListCubit.getData();
              emit(CreateStreamSuccess("Stream Scheduled Succesfully"));
            } else {
              StreamModel? stream = await _streamRepository.createStream(
                  title: title,
                  startAt: startAt,
                  endAt: endAt,
                  thumbnailUrl: url);
              _streamListCubit.getData();
              emit(CreateStreamSuccess("Stream Scheduled Succesfully"));
            }
          } else {
            throw Exception("Failed");
          }
        });
      } else {
        StreamModel? stream = await _streamRepository.createStream(
            title: title, startAt: startAt, endAt: endAt, thumbnailUrl: "");
        _streamListCubit.getData();
        emit(CreateStreamSuccess("Stream Scheduled Succesfully"));
      }
    } catch (e) {
      emit(CreateStreamError(e.toString()));
      //TODO:Error state
    }
  }
}
