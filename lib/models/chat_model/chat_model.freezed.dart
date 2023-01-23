// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) {
  return _ChatModel.fromJson(json);
}

/// @nodoc
mixin _$ChatModel {
  String? get id => throw _privateConstructorUsedError;
  String get user1 => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  String get user1Name => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get user2Name => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get user2ImageUrl => throw _privateConstructorUsedError;
  List<MessagesModel>? get messages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatModelCopyWith<ChatModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatModelCopyWith<$Res> {
  factory $ChatModelCopyWith(ChatModel value, $Res Function(ChatModel) then) =
      _$ChatModelCopyWithImpl<$Res, ChatModel>;
  @useResult
  $Res call(
      {String? id,
      String user1,
      bool active,
      String user1Name,
      DateTime createdAt,
      String user2Name,
      String? userId,
      String? user2ImageUrl,
      List<MessagesModel>? messages});
}

/// @nodoc
class _$ChatModelCopyWithImpl<$Res, $Val extends ChatModel>
    implements $ChatModelCopyWith<$Res> {
  _$ChatModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? user1 = null,
    Object? active = null,
    Object? user1Name = null,
    Object? createdAt = null,
    Object? user2Name = null,
    Object? userId = freezed,
    Object? user2ImageUrl = freezed,
    Object? messages = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      user1: null == user1
          ? _value.user1
          : user1 // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      user1Name: null == user1Name
          ? _value.user1Name
          : user1Name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user2Name: null == user2Name
          ? _value.user2Name
          : user2Name // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      user2ImageUrl: freezed == user2ImageUrl
          ? _value.user2ImageUrl
          : user2ImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      messages: freezed == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessagesModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChatModelCopyWith<$Res> implements $ChatModelCopyWith<$Res> {
  factory _$$_ChatModelCopyWith(
          _$_ChatModel value, $Res Function(_$_ChatModel) then) =
      __$$_ChatModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String user1,
      bool active,
      String user1Name,
      DateTime createdAt,
      String user2Name,
      String? userId,
      String? user2ImageUrl,
      List<MessagesModel>? messages});
}

/// @nodoc
class __$$_ChatModelCopyWithImpl<$Res>
    extends _$ChatModelCopyWithImpl<$Res, _$_ChatModel>
    implements _$$_ChatModelCopyWith<$Res> {
  __$$_ChatModelCopyWithImpl(
      _$_ChatModel _value, $Res Function(_$_ChatModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? user1 = null,
    Object? active = null,
    Object? user1Name = null,
    Object? createdAt = null,
    Object? user2Name = null,
    Object? userId = freezed,
    Object? user2ImageUrl = freezed,
    Object? messages = freezed,
  }) {
    return _then(_$_ChatModel(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      user1: null == user1
          ? _value.user1
          : user1 // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      user1Name: null == user1Name
          ? _value.user1Name
          : user1Name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user2Name: null == user2Name
          ? _value.user2Name
          : user2Name // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      user2ImageUrl: freezed == user2ImageUrl
          ? _value.user2ImageUrl
          : user2ImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      messages: freezed == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessagesModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ChatModel with DiagnosticableTreeMixin implements _ChatModel {
  const _$_ChatModel(
      {required this.id,
      required this.user1,
      required this.active,
      required this.user1Name,
      required this.createdAt,
      required this.user2Name,
      required this.userId,
      required this.user2ImageUrl,
      required final List<MessagesModel>? messages})
      : _messages = messages;

  factory _$_ChatModel.fromJson(Map<String, dynamic> json) =>
      _$$_ChatModelFromJson(json);

  @override
  final String? id;
  @override
  final String user1;
  @override
  final bool active;
  @override
  final String user1Name;
  @override
  final DateTime createdAt;
  @override
  final String user2Name;
  @override
  final String? userId;
  @override
  final String? user2ImageUrl;
  final List<MessagesModel>? _messages;
  @override
  List<MessagesModel>? get messages {
    final value = _messages;
    if (value == null) return null;
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ChatModel(id: $id, user1: $user1, active: $active, user1Name: $user1Name, createdAt: $createdAt, user2Name: $user2Name, userId: $userId, user2ImageUrl: $user2ImageUrl, messages: $messages)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ChatModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('user1', user1))
      ..add(DiagnosticsProperty('active', active))
      ..add(DiagnosticsProperty('user1Name', user1Name))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('user2Name', user2Name))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('user2ImageUrl', user2ImageUrl))
      ..add(DiagnosticsProperty('messages', messages));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user1, user1) || other.user1 == user1) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.user1Name, user1Name) ||
                other.user1Name == user1Name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.user2Name, user2Name) ||
                other.user2Name == user2Name) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user2ImageUrl, user2ImageUrl) ||
                other.user2ImageUrl == user2ImageUrl) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      user1,
      active,
      user1Name,
      createdAt,
      user2Name,
      userId,
      user2ImageUrl,
      const DeepCollectionEquality().hash(_messages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatModelCopyWith<_$_ChatModel> get copyWith =>
      __$$_ChatModelCopyWithImpl<_$_ChatModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChatModelToJson(
      this,
    );
  }
}

abstract class _ChatModel implements ChatModel {
  const factory _ChatModel(
      {required final String? id,
      required final String user1,
      required final bool active,
      required final String user1Name,
      required final DateTime createdAt,
      required final String user2Name,
      required final String? userId,
      required final String? user2ImageUrl,
      required final List<MessagesModel>? messages}) = _$_ChatModel;

  factory _ChatModel.fromJson(Map<String, dynamic> json) =
      _$_ChatModel.fromJson;

  @override
  String? get id;
  @override
  String get user1;
  @override
  bool get active;
  @override
  String get user1Name;
  @override
  DateTime get createdAt;
  @override
  String get user2Name;
  @override
  String? get userId;
  @override
  String? get user2ImageUrl;
  @override
  List<MessagesModel>? get messages;
  @override
  @JsonKey(ignore: true)
  _$$_ChatModelCopyWith<_$_ChatModel> get copyWith =>
      throw _privateConstructorUsedError;
}
