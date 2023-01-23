part of 'chats_cubit.dart';

class ChatsState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChatsLoaded extends ChatsState {
  List<ChatModel> chats;
  ChatsLoaded(this.chats);

  @override
  List<ChatModel> get props => chats;
}

class ChatsLoading extends ChatsState {}

class ChatsError extends ChatsState {
  String error;
  ChatsError(this.error);

  @override
  List<String> get props => [error];
}

class ChatsIndividualLoading extends ChatsState {
  List<ChatModel> chats;
  ChatsIndividualLoading(this.chats);

  @override
  List<ChatModel> get props => chats;
}

class ChatsIndividualError extends ChatsState {
  List<ChatModel> chats;
  ChatsIndividualError(this.chats, this.error);
  String error;
  @override
  List<Object?> get props => [chats, error];
}
