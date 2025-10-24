import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'recurring_transaction_model.freezed.dart';
part 'recurring_transaction_model.g.dart';

enum RecurrenceType {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  yearly,
}

@freezed
@HiveType(typeId: 3)
class RecurringTransactionModel with _$RecurringTransactionModel {
  const factory RecurringTransactionModel({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required double amount,
    @HiveField(3) required String categoryId,
    @HiveField(4) required RecurrenceType recurrenceType,
    @HiveField(5) required DateTime startDate,
    @HiveField(6) DateTime? endDate,
    @HiveField(7) String? description,
    @HiveField(8) @Default([]) List<String> tags,
    @HiveField(9) @Default(true) bool isActive,
    @HiveField(10) int? dayOfMonth,
    @HiveField(11) int? dayOfWeek,
  }) = _RecurringTransactionModel;

  factory RecurringTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringTransactionModelFromJson(json);
}
