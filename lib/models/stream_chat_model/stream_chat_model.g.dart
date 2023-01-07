// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StreamChatModel _$$_StreamChatModelFromJson(Map<String, dynamic> json) =>
    _$_StreamChatModel(
      id: json['id'] as String?,
      message: json['message'] as String,
      from: json['from'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      thread: json['thread'] as String,
      fromName: json['fromName'] as String?,
      fromImageUrl: json['fromImageUrl'] as String?,
    );

Map<String, dynamic> _$$_StreamChatModelToJson(_$_StreamChatModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'from': instance.from,
      'createdAt': instance.createdAt.toIso8601String(),
      'thread': instance.thread,
      'fromName': instance.fromName,
      'fromImageUrl': instance.fromImageUrl,
    };
