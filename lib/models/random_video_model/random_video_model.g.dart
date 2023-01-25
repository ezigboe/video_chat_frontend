// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RandomVideoModel _$$_RandomVideoModelFromJson(Map<String, dynamic> json) =>
    _$_RandomVideoModel(
      channel: json['channel'] as String?,
      key: json['key'] as String,
      repeat: json['repeat'] as bool?,
      skip: json['skip'] as bool?,
      token: json['token'] as String,
    );

Map<String, dynamic> _$$_RandomVideoModelToJson(_$_RandomVideoModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'key': instance.key,
      'repeat': instance.repeat,
      'skip': instance.skip,
      'token': instance.token,
    };
