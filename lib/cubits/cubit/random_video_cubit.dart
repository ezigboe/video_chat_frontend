import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_chat/cubits/chats/chats_cubit.dart';
import 'package:video_chat/models/random_video_model/random_video_model.dart';
import 'package:video_chat/repositories/random_video_repository.dart';

part 'random_video_state.dart';

class RandomVideoCubit extends Cubit<RandomVideoState> {
  RandomVideoRepository _randomVideoRepository;
  ChatsCubit _chatsCubit;
  RandomVideoCubit(
      RandomVideoRepository randomVideoRepository, ChatsCubit chatsCubit)
      : _randomVideoRepository = randomVideoRepository,
        _chatsCubit = chatsCubit,
        super(RandomVideoUserIdleState());

  findUser() async {
    try {
      emit(RandomVideoUserSearchingState());
      RandomVideoModel data = await _randomVideoRepository.getRandomUser();
      emit(RandomVideoUserFoundState(data));
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
}
