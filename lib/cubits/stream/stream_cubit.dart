import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_chat/models/stream_chat_model/stream_chat_model.dart';
import 'package:video_chat/models/stream_model/stream_model.dart';
import 'package:video_chat/repositories/stream_repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'stream_state.dart';

class StreamCubit extends Cubit<StreamState> {
  final StreamRepository _streamRepository;
  StreamCubit(StreamRepository streamRepository)
      : _streamRepository = streamRepository,
        super(StreamInitialState());
  late StreamController<StreamChatModel> messageStreamController;
  late IO.Socket socket;
  late StreamModel streamModel;
  List<StreamChatModel> streamMessages = [];

  joinStream(StreamModel stream) async {
    try {
      streamModel = stream;
      await _streamRepository.joinStream(streamModel.id, DateTime.now());
      streamMessages.clear();
      streamMessages = [];
      emit(StreamJoinedState());
      initiateChatThread();
      Future.delayed(streamModel.endAt.difference(streamModel.startAt), () {
        log("Duration Ended");
        log(streamModel.endAt.toLocal().difference(DateTime.now()).toString());
        if (state is StreamJoinedState) leaveStream();
      });
    } catch (e) {
      emit(StreamError(e.toString()));
    }
  }

  leaveStream() async {
    try {
      log("herrrr--------------------------");
      if (streamModel != null) {
        await _streamRepository.leaveStream(streamModel.id, DateTime.now());
        socket.emit('disconnect');
        socket.clearListeners();
        socket.disconnect();
        messageStreamController.close();
      }
      emit(StreamLeftState());
    } catch (e) {
      emit(StreamError(e.toString()));
    }
  }

  void initiateChatThread() async {
    try {
      socket = await _streamRepository.getSocket(streamModel);
      registerHandlers();
    } catch (e) {
      emit(StreamError(e.toString()));
    }
  }

  void registerHandlers() {
    socket.onConnect((_) {
      socket.emit('join_stream', streamModel.id);
      messageStreamController = StreamController<StreamChatModel>.broadcast();
    });
    socket.on('msg_data', (data) {
      log("rece message building ${data[0]}");
      streamMessages.add(StreamChatModel.fromJson(data[0]));
      messageStreamController.sink.add(StreamChatModel.fromJson(data[0]));
      log(streamMessages.length.toString());
    });
    socket.onDisconnect((_) => log('disconnecteddddddd'));
  }

  void sendMessage(
      String message, String from, String fromName, String fromImageUrl) {
    try {
      socket.emit('stream_chat',
          [message, streamModel.id, from, fromName, fromImageUrl]);
    } catch (e) {
      emit(StreamError(e.toString()));
    }
  }
}
