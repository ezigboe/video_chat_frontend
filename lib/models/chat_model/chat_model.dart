// This file is "main.dart"
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:video_chat/models/messages_model/messages_model.dart';

// required: associates our `main.dart` with the code generated by Freezed
part 'chat_model.freezed.dart';
// optional: Since our Person class is serializable, we must add this line.
// But if Person was not serializable, we could skip it.
part 'chat_model.g.dart';

@freezed
class ChatModel with _$ChatModel {
  const factory ChatModel({
    required String? id,
    required String user1,
    required bool active,
    required String user1Name,
    required DateTime createdAt,
    required String user2Name,
    required String? userId,
    required String? user2ImageUrl,
    required List<MessagesModel>? messages
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, Object?> json) =>
      _$ChatModelFromJson(json);
}