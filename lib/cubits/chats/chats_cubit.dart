import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_chat/models/chat_model/chat_model.dart';
import 'package:video_chat/models/messages_model/messages_model.dart';
import 'package:video_chat/repositories/chats_repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../auth_cubit/auth_cubit.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatsRepository _chatsRepository;
  ChatsCubit(ChatsRepository chatsRepository, AuthCubit authCubit)
      : _chatsRepository = chatsRepository,
        _authCubit = authCubit,
        super(ChatsLoading());
  late IO.Socket socket;
  AuthCubit _authCubit;
  getAllChats() async {
    try {
      socket = _authCubit.socket;
      registerHandlers();
      emit(ChatsLoading());
      List<ChatModel> data = await _chatsRepository.getAllChats();
      emit(ChatsLoaded(data));
    } catch (e) {
      emit(ChatsError(e.toString()));
    }
  }

createChat(){}

  getSpecificChats(String threadId) async {
    try {
      emit(ChatsIndividualLoading((state as ChatsLoaded).chats));
      List<MessagesModel> data =
          await _chatsRepository.getSpecificChats(threadId);
      List<ChatModel> currentData = (state as ChatsIndividualLoading).props;
      int replaceIndex =
          currentData.indexWhere((element) => element.id == threadId);
      currentData[replaceIndex].messages!.addAll(data);
      emit(ChatsLoaded(currentData));
    } catch (e) {
      emit(ChatsIndividualError(
          (state as ChatsIndividualLoading).props, e.toString()));
    }
  }

  void registerHandlers() {
    socket.on('message', (data) {
      MessagesModel message = MessagesModel.fromJson(data[0]);
      List<ChatModel> currentData = (state as ChatsIndividualLoading).props;
      int replaceIndex =
          currentData.indexWhere((element) => element.id == message.thread);
      currentData[replaceIndex].messages!.add(message);
      emit(ChatsLoaded(currentData));
    });
    socket.onDisconnect((_) => socket.clearListeners());
  }
}
