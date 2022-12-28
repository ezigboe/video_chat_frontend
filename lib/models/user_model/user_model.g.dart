// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      dob: DateTime.parse(json['dob'] as String),
      goldBalance: json['goldBalance'] as int,
      diamondBalance: json['diamondBalance'] as int,
      phone: json['phone'] as String,
      gender: json['gender'] as String,
      referralCode: json['referralCode'] as String,
      profileImage: json['profileImage'] as String,
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'dob': instance.dob.toIso8601String(),
      'goldBalance': instance.goldBalance,
      'diamondBalance': instance.diamondBalance,
      'phone': instance.phone,
      'gender': instance.gender,
      'referralCode': instance.referralCode,
      'profileImage': instance.profileImage,
    };
