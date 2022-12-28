// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StreamModel _$$_StreamModelFromJson(Map<String, dynamic> json) =>
    _$_StreamModel(
      title: json['title'] as String,
      hostName: json['hostName'] as String,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      channelId: json['channelId'] as String,
      channelToken: json['channelToken'] as String,
      hostId: json['hostId'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );

Map<String, dynamic> _$$_StreamModelToJson(_$_StreamModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'hostName': instance.hostName,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'channelId': instance.channelId,
      'channelToken': instance.channelToken,
      'hostId': instance.hostId,
      'thumbnailUrl': instance.thumbnailUrl,
    };
