import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_chat/models/stream_model/stream_model.dart';
import 'package:video_chat/repositories/stream_repository.dart';

part 'stream_list_state.dart';

class StreamListCubit extends Cubit<StreamListState> {
  final StreamRepository _streamRepository;
  StreamListCubit(StreamRepository streamRepository)
      : _streamRepository = streamRepository,
        super(StreamListLoading([]));

  getData() async {
    try {
      emit(StreamListLoading(state.data));
      List<StreamModel>? data = await _streamRepository.getLiveStreamList();
      emit(StreamListLoaded(data!));
    } catch (e) {
      emit(StreamListError(e.toString(), state.data));
    }
  }
}
