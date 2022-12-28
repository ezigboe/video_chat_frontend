part of 'stream_list_cubit.dart';

class StreamListState extends Equatable {
  List<StreamModel> data;
  StreamListState(this.data);
  @override
  // TODO: implement props
  List<Object?> get props => [data];
}

class StreamListLoaded extends StreamListState {
  StreamListLoaded(super.data);
}

class StreamListLoading extends StreamListState {
  StreamListLoading(super.data);
}

class StreamListError extends StreamListState {
  String error;
  StreamListError(this.error, super.data);
  @override
  // TODO: implement props
  List<Object?> get props => [error, data];
}
