import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
@HiveType(typeId: 0)
class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required double amount,
    @HiveField(3) required String categoryId,
    @HiveField(4) required DateTime date,
    @HiveField(5) String? description,
    @HiveField(6) String? location,
    @HiveField(7) @Default([]) List<String> tags,
    @HiveField(8) @Default(false) bool isRecurring,
    @HiveField(9) String? recurringId,
    @HiveField(10) @Default('USD') String? currency,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
}
