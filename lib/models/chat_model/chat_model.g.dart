// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatModel _$$_ChatModelFromJson(Map<String, dynamic> json) => _$_ChatModel(
      id: json['id'] as String?,
      user1: json['user1'] as String,
      active: json['active'] as bool,
      user1Name: json['user1Name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      user2Name: json['user2Name'] as String,
      userId: json['userId'] as String?,
      user2ImageUrl: json['user2ImageUrl'] as String?,
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => MessagesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_ChatModelToJson(_$_ChatModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user1': instance.user1,
      'active': instance.active,
      'user1Name': instance.user1Name,
      'createdAt': instance.createdAt.toIso8601String(),
      'user2Name': instance.user2Name,
      'userId': instance.userId,
      'user2ImageUrl': instance.user2ImageUrl,
      'messages': instance.messages,
    };
