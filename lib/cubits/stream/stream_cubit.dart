import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_chat/models/stream_model/stream_model.dart';
import 'package:video_chat/repositories/stream_repository.dart';

part 'stream_state.dart';

class StreamCubit extends Cubit<StreamState> {
  final StreamRepository _streamRepository;
  StreamCubit(StreamRepository streamRepository)
      : _streamRepository = streamRepository,
        super(StreamInitialState());

  joinStream(StreamModel stream) async {
    try {
      await _streamRepository.joinStream(stream.id, DateTime.now());
      emit(StreamJoinedState());
      Future.delayed(stream.endAt.difference(stream.startAt), () {
        log("Duration Ended");
        log(stream.endAt.toLocal().difference(DateTime.now()).toString());
        if (state is StreamJoinedState) leaveStream(stream.id);
      });
    } catch (e) {
      emit(StreamError(e.toString()));
    }
  }

  leaveStream(String streamId) async {
    try {
      log("herrrr--------------------------");
      await _streamRepository.leaveStream(streamId, DateTime.now());
      emit(StreamLeftState());
    } catch (e) {
      emit(StreamError(e.toString()));
    }
  }
}
