import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_chat/cubits/auth_cubit/auth_cubit.dart';
import 'package:video_chat/cubits/chats/chats_cubit.dart';
import 'package:video_chat/models/random_video_model/random_video_model.dart';
import 'package:video_chat/repositories/random_video_repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
part 'random_video_state.dart';

class RandomVideoCubit extends Cubit<RandomVideoState> {
  RandomVideoRepository _randomVideoRepository;
  ChatsCubit _chatsCubit;
  AuthCubit _authCubit;
  RandomVideoCubit(RandomVideoRepository randomVideoRepository,
      ChatsCubit chatsCubit, AuthCubit authCubit)
      : _randomVideoRepository = randomVideoRepository,
        _chatsCubit = chatsCubit,
        _authCubit = authCubit,
        super(RandomVideoUserIdleState());
  late IO.Socket socket;

  init() async {
    try {
      socket = _authCubit.socket;
      registerHandlers();
      emit(RandomVideoUserSearchingState());
    } catch (e) {
      emit(RandomVideoUserError(e.toString()));
    }
  }

  endCall() async {
    try {
      bool? value = await _randomVideoRepository.deleteCall();
      emit(RandomVideoUserIdleState());
    } catch (e) {
      emit(RandomVideoUserError(e.toString()));
    }
  }

  void registerHandlers() {
    log("Initiated");
    findUser();
    socket.onConnect((data) => log("Connected"));
    socket.io.onAny((event, data) => log("$event event triggered"));
    socket.on('matched', (data) {
      log("Hereee matched");
      emit(RandomVideoUserFoundState(RandomVideoModel.fromJson(data[0])));
    });
    socket.on('not_matched', (data) {
      log("not_matched");
      emit(RandomVideoUserIdleState());
    });
    // socket.onDisconnect((_) => socket.clearListeners());
    log("${socket.subs}");
  }

  void findUser() {
    try {
      socket.emit(
          'join_random_chat', [(_authCubit.state as AuthLoggedIn).userData.id]);
    } catch (e) {
      emit(RandomVideoUserError(e.toString()));
    }
  }

  void endVideoCall() {
    try {
      socket.emit('end_random_chat', [
        (_authCubit.state as AuthLoggedIn).userData.id,
        (state as RandomVideoUserFoundState).randomUser.key
      ]);
    } catch (e) {
      emit(RandomVideoUserError(e.toString()));
    }
  }
}
