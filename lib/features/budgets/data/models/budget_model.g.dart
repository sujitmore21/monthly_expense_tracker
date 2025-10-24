// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetModelAdapter extends TypeAdapter<BudgetModel> {
  @override
  final int typeId = 2;

  @override
  BudgetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetModel(
      id: fields[0] as String,
      name: fields[1] as String,
      amount: fields[2] as double,
      categoryId: fields[3] as String,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      spent: fields[6] as double,
      isActive: fields[7] as bool,
      warningThreshold: fields[8] as double,
      dangerThreshold: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BudgetModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.spent)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.warningThreshold)
      ..writeByte(9)
      ..write(obj.dangerThreshold);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetModelImpl _$$BudgetModelImplFromJson(Map<String, dynamic> json) =>
    _$BudgetModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      spent: (json['spent'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? false,
      warningThreshold: (json['warningThreshold'] as num?)?.toDouble() ?? 0.8,
      dangerThreshold: (json['dangerThreshold'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$BudgetModelImplToJson(_$BudgetModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'categoryId': instance.categoryId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'spent': instance.spent,
      'isActive': instance.isActive,
      'warningThreshold': instance.warningThreshold,
      'dangerThreshold': instance.dangerThreshold,
    };
