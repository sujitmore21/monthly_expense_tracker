// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecurringTransactionModel _$RecurringTransactionModelFromJson(
    Map<String, dynamic> json) {
  return _RecurringTransactionModel.fromJson(json);
}

/// @nodoc
mixin _$RecurringTransactionModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  double get amount => throw _privateConstructorUsedError;
  @HiveField(3)
  String get categoryId => throw _privateConstructorUsedError;
  @HiveField(4)
  RecurrenceType get recurrenceType => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get startDate => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime? get endDate => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(8)
  List<String> get tags => throw _privateConstructorUsedError;
  @HiveField(9)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(10)
  int? get dayOfMonth => throw _privateConstructorUsedError;
  @HiveField(11)
  int? get dayOfWeek => throw _privateConstructorUsedError;

  /// Serializes this RecurringTransactionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurringTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurringTransactionModelCopyWith<RecurringTransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringTransactionModelCopyWith<$Res> {
  factory $RecurringTransactionModelCopyWith(RecurringTransactionModel value,
          $Res Function(RecurringTransactionModel) then) =
      _$RecurringTransactionModelCopyWithImpl<$Res, RecurringTransactionModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) double amount,
      @HiveField(3) String categoryId,
      @HiveField(4) RecurrenceType recurrenceType,
      @HiveField(5) DateTime startDate,
      @HiveField(6) DateTime? endDate,
      @HiveField(7) String? description,
      @HiveField(8) List<String> tags,
      @HiveField(9) bool isActive,
      @HiveField(10) int? dayOfMonth,
      @HiveField(11) int? dayOfWeek});
}

/// @nodoc
class _$RecurringTransactionModelCopyWithImpl<$Res,
        $Val extends RecurringTransactionModel>
    implements $RecurringTransactionModelCopyWith<$Res> {
  _$RecurringTransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurringTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? amount = null,
    Object? categoryId = null,
    Object? recurrenceType = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? description = freezed,
    Object? tags = null,
    Object? isActive = null,
    Object? dayOfMonth = freezed,
    Object? dayOfWeek = freezed,
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
      recurrenceType: null == recurrenceType
          ? _value.recurrenceType
          : recurrenceType // ignore: cast_nullable_to_non_nullable
              as RecurrenceType,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      dayOfMonth: freezed == dayOfMonth
          ? _value.dayOfMonth
          : dayOfMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      dayOfWeek: freezed == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecurringTransactionModelImplCopyWith<$Res>
    implements $RecurringTransactionModelCopyWith<$Res> {
  factory _$$RecurringTransactionModelImplCopyWith(
          _$RecurringTransactionModelImpl value,
          $Res Function(_$RecurringTransactionModelImpl) then) =
      __$$RecurringTransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) double amount,
      @HiveField(3) String categoryId,
      @HiveField(4) RecurrenceType recurrenceType,
      @HiveField(5) DateTime startDate,
      @HiveField(6) DateTime? endDate,
      @HiveField(7) String? description,
      @HiveField(8) List<String> tags,
      @HiveField(9) bool isActive,
      @HiveField(10) int? dayOfMonth,
      @HiveField(11) int? dayOfWeek});
}

/// @nodoc
class __$$RecurringTransactionModelImplCopyWithImpl<$Res>
    extends _$RecurringTransactionModelCopyWithImpl<$Res,
        _$RecurringTransactionModelImpl>
    implements _$$RecurringTransactionModelImplCopyWith<$Res> {
  __$$RecurringTransactionModelImplCopyWithImpl(
      _$RecurringTransactionModelImpl _value,
      $Res Function(_$RecurringTransactionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecurringTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? amount = null,
    Object? categoryId = null,
    Object? recurrenceType = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? description = freezed,
    Object? tags = null,
    Object? isActive = null,
    Object? dayOfMonth = freezed,
    Object? dayOfWeek = freezed,
  }) {
    return _then(_$RecurringTransactionModelImpl(
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
      recurrenceType: null == recurrenceType
          ? _value.recurrenceType
          : recurrenceType // ignore: cast_nullable_to_non_nullable
              as RecurrenceType,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      dayOfMonth: freezed == dayOfMonth
          ? _value.dayOfMonth
          : dayOfMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      dayOfWeek: freezed == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurringTransactionModelImpl implements _RecurringTransactionModel {
  const _$RecurringTransactionModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) required this.amount,
      @HiveField(3) required this.categoryId,
      @HiveField(4) required this.recurrenceType,
      @HiveField(5) required this.startDate,
      @HiveField(6) this.endDate,
      @HiveField(7) this.description,
      @HiveField(8) final List<String> tags = const [],
      @HiveField(9) this.isActive = true,
      @HiveField(10) this.dayOfMonth,
      @HiveField(11) this.dayOfWeek})
      : _tags = tags;

  factory _$RecurringTransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurringTransactionModelImplFromJson(json);

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
  final RecurrenceType recurrenceType;
  @override
  @HiveField(5)
  final DateTime startDate;
  @override
  @HiveField(6)
  final DateTime? endDate;
  @override
  @HiveField(7)
  final String? description;
  final List<String> _tags;
  @override
  @JsonKey()
  @HiveField(8)
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  @HiveField(9)
  final bool isActive;
  @override
  @HiveField(10)
  final int? dayOfMonth;
  @override
  @HiveField(11)
  final int? dayOfWeek;

  @override
  String toString() {
    return 'RecurringTransactionModel(id: $id, title: $title, amount: $amount, categoryId: $categoryId, recurrenceType: $recurrenceType, startDate: $startDate, endDate: $endDate, description: $description, tags: $tags, isActive: $isActive, dayOfMonth: $dayOfMonth, dayOfWeek: $dayOfWeek)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringTransactionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.recurrenceType, recurrenceType) ||
                other.recurrenceType == recurrenceType) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.dayOfMonth, dayOfMonth) ||
                other.dayOfMonth == dayOfMonth) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      amount,
      categoryId,
      recurrenceType,
      startDate,
      endDate,
      description,
      const DeepCollectionEquality().hash(_tags),
      isActive,
      dayOfMonth,
      dayOfWeek);

  /// Create a copy of RecurringTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringTransactionModelImplCopyWith<_$RecurringTransactionModelImpl>
      get copyWith => __$$RecurringTransactionModelImplCopyWithImpl<
          _$RecurringTransactionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringTransactionModelImplToJson(
      this,
    );
  }
}

abstract class _RecurringTransactionModel implements RecurringTransactionModel {
  const factory _RecurringTransactionModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String title,
      @HiveField(2) required final double amount,
      @HiveField(3) required final String categoryId,
      @HiveField(4) required final RecurrenceType recurrenceType,
      @HiveField(5) required final DateTime startDate,
      @HiveField(6) final DateTime? endDate,
      @HiveField(7) final String? description,
      @HiveField(8) final List<String> tags,
      @HiveField(9) final bool isActive,
      @HiveField(10) final int? dayOfMonth,
      @HiveField(11) final int? dayOfWeek}) = _$RecurringTransactionModelImpl;

  factory _RecurringTransactionModel.fromJson(Map<String, dynamic> json) =
      _$RecurringTransactionModelImpl.fromJson;

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
  RecurrenceType get recurrenceType;
  @override
  @HiveField(5)
  DateTime get startDate;
  @override
  @HiveField(6)
  DateTime? get endDate;
  @override
  @HiveField(7)
  String? get description;
  @override
  @HiveField(8)
  List<String> get tags;
  @override
  @HiveField(9)
  bool get isActive;
  @override
  @HiveField(10)
  int? get dayOfMonth;
  @override
  @HiveField(11)
  int? get dayOfWeek;

  /// Create a copy of RecurringTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurringTransactionModelImplCopyWith<_$RecurringTransactionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
