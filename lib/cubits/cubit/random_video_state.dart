part of 'random_video_cubit.dart';

class RandomVideoState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RandomVideoUserFoundState extends RandomVideoState {
  RandomVideoModel randomUser;
  RandomVideoUserFoundState(this.randomUser);
  @override
  List<Object?> get props => [randomUser];
}

class RandomVideoUserSearchingState extends RandomVideoState {}

class RandomVideoUserIdleState extends RandomVideoState {}

class RandomVideoUserError extends RandomVideoState {
  String error;
  RandomVideoUserError(this.error);

  @override
  List<String> get props => [error];
}
