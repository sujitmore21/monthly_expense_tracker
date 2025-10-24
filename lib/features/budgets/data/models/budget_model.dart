import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'budget_model.freezed.dart';
part 'budget_model.g.dart';

@freezed
@HiveType(typeId: 2)
class BudgetModel with _$BudgetModel {
  const factory BudgetModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required double amount,
    @HiveField(3) required String categoryId,
    @HiveField(4) required DateTime startDate,
    @HiveField(5) required DateTime endDate,
    @HiveField(6) @Default(0.0) double spent,
    @HiveField(7) @Default(false) bool isActive,
    @HiveField(8) @Default(0.8) double warningThreshold,
    @HiveField(9) @Default(1.0) double dangerThreshold,
  }) = _BudgetModel;

  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);
}
