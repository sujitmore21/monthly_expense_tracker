// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) {
  return _BudgetModel.fromJson(json);
}

/// @nodoc
mixin _$BudgetModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  double get amount => throw _privateConstructorUsedError;
  @HiveField(3)
  String get categoryId => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get startDate => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get endDate => throw _privateConstructorUsedError;
  @HiveField(6)
  double get spent => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(8)
  double get warningThreshold => throw _privateConstructorUsedError;
  @HiveField(9)
  double get dangerThreshold => throw _privateConstructorUsedError;

  /// Serializes this BudgetModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetModelCopyWith<BudgetModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetModelCopyWith<$Res> {
  factory $BudgetModelCopyWith(
          BudgetModel value, $Res Function(BudgetModel) then) =
      _$BudgetModelCopyWithImpl<$Res, BudgetModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) double amount,
      @HiveField(3) String categoryId,
      @HiveField(4) DateTime startDate,
      @HiveField(5) DateTime endDate,
      @HiveField(6) double spent,
      @HiveField(7) bool isActive,
      @HiveField(8) double warningThreshold,
      @HiveField(9) double dangerThreshold});
}

/// @nodoc
class _$BudgetModelCopyWithImpl<$Res, $Val extends BudgetModel>
    implements $BudgetModelCopyWith<$Res> {
  _$BudgetModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? categoryId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? spent = null,
    Object? isActive = null,
    Object? warningThreshold = null,
    Object? dangerThreshold = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      spent: null == spent
          ? _value.spent
          : spent // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      warningThreshold: null == warningThreshold
          ? _value.warningThreshold
          : warningThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      dangerThreshold: null == dangerThreshold
          ? _value.dangerThreshold
          : dangerThreshold // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetModelImplCopyWith<$Res>
    implements $BudgetModelCopyWith<$Res> {
  factory _$$BudgetModelImplCopyWith(
          _$BudgetModelImpl value, $Res Function(_$BudgetModelImpl) then) =
      __$$BudgetModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) double amount,
      @HiveField(3) String categoryId,
      @HiveField(4) DateTime startDate,
      @HiveField(5) DateTime endDate,
      @HiveField(6) double spent,
      @HiveField(7) bool isActive,
      @HiveField(8) double warningThreshold,
      @HiveField(9) double dangerThreshold});
}

/// @nodoc
class __$$BudgetModelImplCopyWithImpl<$Res>
    extends _$BudgetModelCopyWithImpl<$Res, _$BudgetModelImpl>
    implements _$$BudgetModelImplCopyWith<$Res> {
  __$$BudgetModelImplCopyWithImpl(
      _$BudgetModelImpl _value, $Res Function(_$BudgetModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? categoryId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? spent = null,
    Object? isActive = null,
    Object? warningThreshold = null,
    Object? dangerThreshold = null,
  }) {
    return _then(_$BudgetModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      spent: null == spent
          ? _value.spent
          : spent // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      warningThreshold: null == warningThreshold
          ? _value.warningThreshold
          : warningThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      dangerThreshold: null == dangerThreshold
          ? _value.dangerThreshold
          : dangerThreshold // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetModelImpl implements _BudgetModel {
  const _$BudgetModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.amount,
      @HiveField(3) required this.categoryId,
      @HiveField(4) required this.startDate,
      @HiveField(5) required this.endDate,
      @HiveField(6) this.spent = 0.0,
      @HiveField(7) this.isActive = false,
      @HiveField(8) this.warningThreshold = 0.8,
      @HiveField(9) this.dangerThreshold = 1.0});

  factory _$BudgetModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final double amount;
  @override
  @HiveField(3)
  final String categoryId;
  @override
  @HiveField(4)
  final DateTime startDate;
  @override
  @HiveField(5)
  final DateTime endDate;
  @override
  @JsonKey()
  @HiveField(6)
  final double spent;
  @override
  @JsonKey()
  @HiveField(7)
  final bool isActive;
  @override
  @JsonKey()
  @HiveField(8)
  final double warningThreshold;
  @override
  @JsonKey()
  @HiveField(9)
  final double dangerThreshold;

  @override
  String toString() {
    return 'BudgetModel(id: $id, name: $name, amount: $amount, categoryId: $categoryId, startDate: $startDate, endDate: $endDate, spent: $spent, isActive: $isActive, warningThreshold: $warningThreshold, dangerThreshold: $dangerThreshold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.spent, spent) || other.spent == spent) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.warningThreshold, warningThreshold) ||
                other.warningThreshold == warningThreshold) &&
            (identical(other.dangerThreshold, dangerThreshold) ||
                other.dangerThreshold == dangerThreshold));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, amount, categoryId,
      startDate, endDate, spent, isActive, warningThreshold, dangerThreshold);

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetModelImplCopyWith<_$BudgetModelImpl> get copyWith =>
      __$$BudgetModelImplCopyWithImpl<_$BudgetModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetModelImplToJson(
      this,
    );
  }
}

abstract class _BudgetModel implements BudgetModel {
  const factory _BudgetModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final double amount,
      @HiveField(3) required final String categoryId,
      @HiveField(4) required final DateTime startDate,
      @HiveField(5) required final DateTime endDate,
      @HiveField(6) final double spent,
      @HiveField(7) final bool isActive,
      @HiveField(8) final double warningThreshold,
      @HiveField(9) final double dangerThreshold}) = _$BudgetModelImpl;

  factory _BudgetModel.fromJson(Map<String, dynamic> json) =
      _$BudgetModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  double get amount;
  @override
  @HiveField(3)
  String get categoryId;
  @override
  @HiveField(4)
  DateTime get startDate;
  @override
  @HiveField(5)
  DateTime get endDate;
  @override
  @HiveField(6)
  double get spent;
  @override
  @HiveField(7)
  bool get isActive;
  @override
  @HiveField(8)
  double get warningThreshold;
  @override
  @HiveField(9)
  double get dangerThreshold;

  /// Create a copy of BudgetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetModelImplCopyWith<_$BudgetModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
