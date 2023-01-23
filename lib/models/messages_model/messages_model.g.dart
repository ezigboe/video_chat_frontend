// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MessagesModel _$$_MessagesModelFromJson(Map<String, dynamic> json) =>
    _$_MessagesModel(
      id: json['id'] as String?,
      message: json['message'] as String,
      from: json['from'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      thread: json['thread'] as String,
      fromName: json['fromName'] as String?,
      fromImageUrl: json['fromImageUrl'] as String?,
      seen: json['seen'] as bool?,
    );

Map<String, dynamic> _$$_MessagesModelToJson(_$_MessagesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'from': instance.from,
      'createdAt': instance.createdAt.toIso8601String(),
      'thread': instance.thread,
      'fromName': instance.fromName,
      'fromImageUrl': instance.fromImageUrl,
      'seen': instance.seen,
    };
