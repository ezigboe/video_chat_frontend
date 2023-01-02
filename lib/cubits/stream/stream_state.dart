part of 'stream_cubit.dart';

class StreamState extends Equatable {
  StreamState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class StreamInitialState extends StreamState {}

class StreamJoinedState extends StreamState {}

class StreamError extends StreamState {
  String error;
  StreamError(this.error);
}

class StreamLeftState extends StreamState {}
