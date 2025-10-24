import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
@HiveType(typeId: 1)
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String icon,
    @HiveField(3) required int color,
    @HiveField(4) @Default(false) bool isDefault,
    @HiveField(5) @Default(false) bool isIncome,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
