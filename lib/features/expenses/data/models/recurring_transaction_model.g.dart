// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringTransactionModelAdapter
    extends TypeAdapter<RecurringTransactionModel> {
  @override
  final int typeId = 3;

  @override
  RecurringTransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurringTransactionModel(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      categoryId: fields[3] as String,
      recurrenceType: fields[4] as RecurrenceType,
      startDate: fields[5] as DateTime,
      endDate: fields[6] as DateTime?,
      description: fields[7] as String?,
      tags: (fields[8] as List).cast<String>(),
      isActive: fields[9] as bool,
      dayOfMonth: fields[10] as int?,
      dayOfWeek: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RecurringTransactionModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.recurrenceType)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.dayOfMonth)
      ..writeByte(11)
      ..write(obj.dayOfWeek);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringTransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecurringTransactionModelImpl _$$RecurringTransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecurringTransactionModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      recurrenceType:
          $enumDecode(_$RecurrenceTypeEnumMap, json['recurrenceType']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      description: json['description'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isActive: json['isActive'] as bool? ?? true,
      dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
      dayOfWeek: (json['dayOfWeek'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RecurringTransactionModelImplToJson(
        _$RecurringTransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'categoryId': instance.categoryId,
      'recurrenceType': _$RecurrenceTypeEnumMap[instance.recurrenceType]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'description': instance.description,
      'tags': instance.tags,
      'isActive': instance.isActive,
      'dayOfMonth': instance.dayOfMonth,
      'dayOfWeek': instance.dayOfWeek,
    };

const _$RecurrenceTypeEnumMap = {
  RecurrenceType.daily: 'daily',
  RecurrenceType.weekly: 'weekly',
  RecurrenceType.monthly: 'monthly',
  RecurrenceType.yearly: 'yearly',
};
