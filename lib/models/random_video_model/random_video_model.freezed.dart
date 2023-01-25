// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'random_video_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RandomVideoModel _$RandomVideoModelFromJson(Map<String, dynamic> json) {
  return _RandomVideoModel.fromJson(json);
}

/// @nodoc
mixin _$RandomVideoModel {
  String? get channel => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  bool? get repeat => throw _privateConstructorUsedError;
  bool? get skip => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RandomVideoModelCopyWith<RandomVideoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RandomVideoModelCopyWith<$Res> {
  factory $RandomVideoModelCopyWith(
          RandomVideoModel value, $Res Function(RandomVideoModel) then) =
      _$RandomVideoModelCopyWithImpl<$Res, RandomVideoModel>;
  @useResult
  $Res call(
      {String? channel, String key, bool? repeat, bool? skip, String token});
}

/// @nodoc
class _$RandomVideoModelCopyWithImpl<$Res, $Val extends RandomVideoModel>
    implements $RandomVideoModelCopyWith<$Res> {
  _$RandomVideoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? key = null,
    Object? repeat = freezed,
    Object? skip = freezed,
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String?,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      repeat: freezed == repeat
          ? _value.repeat
          : repeat // ignore: cast_nullable_to_non_nullable
              as bool?,
      skip: freezed == skip
          ? _value.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as bool?,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RandomVideoModelCopyWith<$Res>
    implements $RandomVideoModelCopyWith<$Res> {
  factory _$$_RandomVideoModelCopyWith(
          _$_RandomVideoModel value, $Res Function(_$_RandomVideoModel) then) =
      __$$_RandomVideoModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? channel, String key, bool? repeat, bool? skip, String token});
}

/// @nodoc
class __$$_RandomVideoModelCopyWithImpl<$Res>
    extends _$RandomVideoModelCopyWithImpl<$Res, _$_RandomVideoModel>
    implements _$$_RandomVideoModelCopyWith<$Res> {
  __$$_RandomVideoModelCopyWithImpl(
      _$_RandomVideoModel _value, $Res Function(_$_RandomVideoModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? key = null,
    Object? repeat = freezed,
    Object? skip = freezed,
    Object? token = null,
  }) {
    return _then(_$_RandomVideoModel(
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String?,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      repeat: freezed == repeat
          ? _value.repeat
          : repeat // ignore: cast_nullable_to_non_nullable
              as bool?,
      skip: freezed == skip
          ? _value.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as bool?,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_RandomVideoModel
    with DiagnosticableTreeMixin
    implements _RandomVideoModel {
  const _$_RandomVideoModel(
      {required this.channel,
      required this.key,
      required this.repeat,
      required this.skip,
      required this.token});

  factory _$_RandomVideoModel.fromJson(Map<String, dynamic> json) =>
      _$$_RandomVideoModelFromJson(json);

  @override
  final String? channel;
  @override
  final String key;
  @override
  final bool? repeat;
  @override
  final bool? skip;
  @override
  final String token;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RandomVideoModel(channel: $channel, key: $key, repeat: $repeat, skip: $skip, token: $token)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RandomVideoModel'))
      ..add(DiagnosticsProperty('channel', channel))
      ..add(DiagnosticsProperty('key', key))
      ..add(DiagnosticsProperty('repeat', repeat))
      ..add(DiagnosticsProperty('skip', skip))
      ..add(DiagnosticsProperty('token', token));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RandomVideoModel &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.repeat, repeat) || other.repeat == repeat) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, channel, key, repeat, skip, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RandomVideoModelCopyWith<_$_RandomVideoModel> get copyWith =>
      __$$_RandomVideoModelCopyWithImpl<_$_RandomVideoModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RandomVideoModelToJson(
      this,
    );
  }
}

abstract class _RandomVideoModel implements RandomVideoModel {
  const factory _RandomVideoModel(
      {required final String? channel,
      required final String key,
      required final bool? repeat,
      required final bool? skip,
      required final String token}) = _$_RandomVideoModel;

  factory _RandomVideoModel.fromJson(Map<String, dynamic> json) =
      _$_RandomVideoModel.fromJson;

  @override
  String? get channel;
  @override
  String get key;
  @override
  bool? get repeat;
  @override
  bool? get skip;
  @override
  String get token;
  @override
  @JsonKey(ignore: true)
  _$$_RandomVideoModelCopyWith<_$_RandomVideoModel> get copyWith =>
      throw _privateConstructorUsedError;
}
