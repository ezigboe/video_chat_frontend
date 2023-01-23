// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'messages_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessagesModel _$MessagesModelFromJson(Map<String, dynamic> json) {
  return _MessagesModel.fromJson(json);
}

/// @nodoc
mixin _$MessagesModel {
  String? get id => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get from => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get thread => throw _privateConstructorUsedError;
  String? get fromName => throw _privateConstructorUsedError;
  String? get fromImageUrl => throw _privateConstructorUsedError;
  bool? get seen => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessagesModelCopyWith<MessagesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessagesModelCopyWith<$Res> {
  factory $MessagesModelCopyWith(
          MessagesModel value, $Res Function(MessagesModel) then) =
      _$MessagesModelCopyWithImpl<$Res, MessagesModel>;
  @useResult
  $Res call(
      {String? id,
      String message,
      String from,
      DateTime createdAt,
      String thread,
      String? fromName,
      String? fromImageUrl,
      bool? seen});
}

/// @nodoc
class _$MessagesModelCopyWithImpl<$Res, $Val extends MessagesModel>
    implements $MessagesModelCopyWith<$Res> {
  _$MessagesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? message = null,
    Object? from = null,
    Object? createdAt = null,
    Object? thread = null,
    Object? fromName = freezed,
    Object? fromImageUrl = freezed,
    Object? seen = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      thread: null == thread
          ? _value.thread
          : thread // ignore: cast_nullable_to_non_nullable
              as String,
      fromName: freezed == fromName
          ? _value.fromName
          : fromName // ignore: cast_nullable_to_non_nullable
              as String?,
      fromImageUrl: freezed == fromImageUrl
          ? _value.fromImageUrl
          : fromImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      seen: freezed == seen
          ? _value.seen
          : seen // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MessagesModelCopyWith<$Res>
    implements $MessagesModelCopyWith<$Res> {
  factory _$$_MessagesModelCopyWith(
          _$_MessagesModel value, $Res Function(_$_MessagesModel) then) =
      __$$_MessagesModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String message,
      String from,
      DateTime createdAt,
      String thread,
      String? fromName,
      String? fromImageUrl,
      bool? seen});
}

/// @nodoc
class __$$_MessagesModelCopyWithImpl<$Res>
    extends _$MessagesModelCopyWithImpl<$Res, _$_MessagesModel>
    implements _$$_MessagesModelCopyWith<$Res> {
  __$$_MessagesModelCopyWithImpl(
      _$_MessagesModel _value, $Res Function(_$_MessagesModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? message = null,
    Object? from = null,
    Object? createdAt = null,
    Object? thread = null,
    Object? fromName = freezed,
    Object? fromImageUrl = freezed,
    Object? seen = freezed,
  }) {
    return _then(_$_MessagesModel(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      thread: null == thread
          ? _value.thread
          : thread // ignore: cast_nullable_to_non_nullable
              as String,
      fromName: freezed == fromName
          ? _value.fromName
          : fromName // ignore: cast_nullable_to_non_nullable
              as String?,
      fromImageUrl: freezed == fromImageUrl
          ? _value.fromImageUrl
          : fromImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      seen: freezed == seen
          ? _value.seen
          : seen // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MessagesModel with DiagnosticableTreeMixin implements _MessagesModel {
  const _$_MessagesModel(
      {required this.id,
      required this.message,
      required this.from,
      required this.createdAt,
      required this.thread,
      required this.fromName,
      required this.fromImageUrl,
      this.seen});

  factory _$_MessagesModel.fromJson(Map<String, dynamic> json) =>
      _$$_MessagesModelFromJson(json);

  @override
  final String? id;
  @override
  final String message;
  @override
  final String from;
  @override
  final DateTime createdAt;
  @override
  final String thread;
  @override
  final String? fromName;
  @override
  final String? fromImageUrl;
  @override
  final bool? seen;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MessagesModel(id: $id, message: $message, from: $from, createdAt: $createdAt, thread: $thread, fromName: $fromName, fromImageUrl: $fromImageUrl, seen: $seen)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MessagesModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('from', from))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('thread', thread))
      ..add(DiagnosticsProperty('fromName', fromName))
      ..add(DiagnosticsProperty('fromImageUrl', fromImageUrl))
      ..add(DiagnosticsProperty('seen', seen));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MessagesModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.thread, thread) || other.thread == thread) &&
            (identical(other.fromName, fromName) ||
                other.fromName == fromName) &&
            (identical(other.fromImageUrl, fromImageUrl) ||
                other.fromImageUrl == fromImageUrl) &&
            (identical(other.seen, seen) || other.seen == seen));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, message, from, createdAt,
      thread, fromName, fromImageUrl, seen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MessagesModelCopyWith<_$_MessagesModel> get copyWith =>
      __$$_MessagesModelCopyWithImpl<_$_MessagesModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MessagesModelToJson(
      this,
    );
  }
}

abstract class _MessagesModel implements MessagesModel {
  const factory _MessagesModel(
      {required final String? id,
      required final String message,
      required final String from,
      required final DateTime createdAt,
      required final String thread,
      required final String? fromName,
      required final String? fromImageUrl,
      final bool? seen}) = _$_MessagesModel;

  factory _MessagesModel.fromJson(Map<String, dynamic> json) =
      _$_MessagesModel.fromJson;

  @override
  String? get id;
  @override
  String get message;
  @override
  String get from;
  @override
  DateTime get createdAt;
  @override
  String get thread;
  @override
  String? get fromName;
  @override
  String? get fromImageUrl;
  @override
  bool? get seen;
  @override
  @JsonKey(ignore: true)
  _$$_MessagesModelCopyWith<_$_MessagesModel> get copyWith =>
      throw _privateConstructorUsedError;
}
