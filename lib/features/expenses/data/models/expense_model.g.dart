// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseModelAdapter extends TypeAdapter<ExpenseModel> {
  @override
  final int typeId = 0;

  @override
  ExpenseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseModel(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      categoryId: fields[3] as String,
      date: fields[4] as DateTime,
      description: fields[5] as String?,
      location: fields[6] as String?,
      tags: (fields[7] as List).cast<String>(),
      isRecurring: fields[8] as bool,
      recurringId: fields[9] as String?,
      currency: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.isRecurring)
      ..writeByte(9)
      ..write(obj.recurringId)
      ..writeByte(10)
      ..write(obj.currency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseModelImpl _$$ExpenseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
      location: json['location'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringId: json['recurringId'] as String?,
      currency: json['currency'] as String? ?? 'USD',
    );

Map<String, dynamic> _$$ExpenseModelImplToJson(_$ExpenseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'categoryId': instance.categoryId,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'location': instance.location,
      'tags': instance.tags,
      'isRecurring': instance.isRecurring,
      'recurringId': instance.recurringId,
      'currency': instance.currency,
    };
