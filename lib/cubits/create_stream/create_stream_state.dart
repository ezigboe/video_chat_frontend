part of 'create_stream_cubit.dart';

class CreateStreamState extends Equatable {
  CreateStreamState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateStreamLoading extends CreateStreamState {}

class CreateStreamUploading extends CreateStreamState {
  double percentage;
  CreateStreamUploading(this.percentage);
  @override
  // TODO: implement props
  List<Object?> get props => [percentage];
}

class CreateStreamSuccess extends CreateStreamState {
  String message;
  CreateStreamSuccess(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class CreateStreamError extends CreateStreamState {
  String error;
  CreateStreamError(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
