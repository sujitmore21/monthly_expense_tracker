// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) {
  return _ExpenseModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  double get amount => throw _privateConstructorUsedError;
  @HiveField(3)
  String get categoryId => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get date => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get location => throw _privateConstructorUsedError;
  @HiveField(7)
  List<String> get tags => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get isRecurring => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get recurringId => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get currency => throw _privateConstructorUsedError;

  /// Serializes this ExpenseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseModelCopyWith<ExpenseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseModelCopyWith<$Res> {
  factory $ExpenseModelCopyWith(
          ExpenseModel value, $Res Function(ExpenseModel) then) =
      _$ExpenseModelCopyWithImpl<$Res, ExpenseModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) double amount,
      @HiveField(3) String categoryId,
      @HiveField(4) DateTime date,
      @HiveField(5) String? description,
      @HiveField(6) String? location,
      @HiveField(7) List<String> tags,
      @HiveField(8) bool isRecurring,
      @HiveField(9) String? recurringId,
      @HiveField(10) String? currency});
}

/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res, $Val extends ExpenseModel>
    implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? amount = null,
    Object? categoryId = null,
    Object? date = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? tags = null,
    Object? isRecurring = null,
    Object? recurringId = freezed,
    Object? currency = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      recurringId: freezed == recurringId
          ? _value.recurringId
          : recurringId // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseModelImplCopyWith<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  factory _$$ExpenseModelImplCopyWith(
          _$ExpenseModelImpl value, $Res Function(_$ExpenseModelImpl) then) =
      __$$ExpenseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) double amount,
      @HiveField(3) String categoryId,
      @HiveField(4) DateTime date,
      @HiveField(5) String? description,
      @HiveField(6) String? location,
      @HiveField(7) List<String> tags,
      @HiveField(8) bool isRecurring,
      @HiveField(9) String? recurringId,
      @HiveField(10) String? currency});
}

/// @nodoc
class __$$ExpenseModelImplCopyWithImpl<$Res>
    extends _$ExpenseModelCopyWithImpl<$Res, _$ExpenseModelImpl>
    implements _$$ExpenseModelImplCopyWith<$Res> {
  __$$ExpenseModelImplCopyWithImpl(
      _$ExpenseModelImpl _value, $Res Function(_$ExpenseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? amount = null,
    Object? categoryId = null,
    Object? date = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? tags = null,
    Object? isRecurring = null,
    Object? recurringId = freezed,
    Object? currency = freezed,
  }) {
    return _then(_$ExpenseModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      recurringId: freezed == recurringId
          ? _value.recurringId
          : recurringId // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseModelImpl implements _ExpenseModel {
  const _$ExpenseModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) required this.amount,
      @HiveField(3) required this.categoryId,
      @HiveField(4) required this.date,
      @HiveField(5) this.description,
      @HiveField(6) this.location,
      @HiveField(7) final List<String> tags = const [],
      @HiveField(8) this.isRecurring = false,
      @HiveField(9) this.recurringId,
      @HiveField(10) this.currency = 'USD'})
      : _tags = tags;

  factory _$ExpenseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final double amount;
  @override
  @HiveField(3)
  final String categoryId;
  @override
  @HiveField(4)
  final DateTime date;
  @override
  @HiveField(5)
  final String? description;
  @override
  @HiveField(6)
  final String? location;
  final List<String> _tags;
  @override
  @JsonKey()
  @HiveField(7)
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  @HiveField(8)
  final bool isRecurring;
  @override
  @HiveField(9)
  final String? recurringId;
  @override
  @JsonKey()
  @HiveField(10)
  final String? currency;

  @override
  String toString() {
    return 'ExpenseModel(id: $id, title: $title, amount: $amount, categoryId: $categoryId, date: $date, description: $description, location: $location, tags: $tags, isRecurring: $isRecurring, recurringId: $recurringId, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurringId, recurringId) ||
                other.recurringId == recurringId) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      amount,
      categoryId,
      date,
      description,
      location,
      const DeepCollectionEquality().hash(_tags),
      isRecurring,
      recurringId,
      currency);

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      __$$ExpenseModelImplCopyWithImpl<_$ExpenseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseModelImplToJson(
      this,
    );
  }
}

abstract class _ExpenseModel implements ExpenseModel {
  const factory _ExpenseModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String title,
      @HiveField(2) required final double amount,
      @HiveField(3) required final String categoryId,
      @HiveField(4) required final DateTime date,
      @HiveField(5) final String? description,
      @HiveField(6) final String? location,
      @HiveField(7) final List<String> tags,
      @HiveField(8) final bool isRecurring,
      @HiveField(9) final String? recurringId,
      @HiveField(10) final String? currency}) = _$ExpenseModelImpl;

  factory _ExpenseModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  double get amount;
  @override
  @HiveField(3)
  String get categoryId;
  @override
  @HiveField(4)
  DateTime get date;
  @override
  @HiveField(5)
  String? get description;
  @override
  @HiveField(6)
  String? get location;
  @override
  @HiveField(7)
  List<String> get tags;
  @override
  @HiveField(8)
  bool get isRecurring;
  @override
  @HiveField(9)
  String? get recurringId;
  @override
  @HiveField(10)
  String? get currency;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
