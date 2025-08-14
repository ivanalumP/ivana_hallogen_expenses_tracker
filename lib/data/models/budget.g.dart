// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetAdapter extends TypeAdapter<Budget> {
  @override
  final int typeId = 0;

  @override
  Budget read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Budget(
      monthlyBudget: fields[0] as double,
      currentBalance: fields[1] as double,
      totalSpent: fields[2] as double,
      month: fields[3] as String,
      year: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.monthlyBudget)
      ..writeByte(1)
      ..write(obj.currentBalance)
      ..writeByte(2)
      ..write(obj.totalSpent)
      ..writeByte(3)
      ..write(obj.month)
      ..writeByte(4)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Budget _$BudgetFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'monthlyBudget',
      'currentBalance',
      'totalSpent',
      'month',
      'year'
    ],
  );
  return Budget(
    monthlyBudget: (json['monthlyBudget'] as num).toDouble(),
    currentBalance: (json['currentBalance'] as num).toDouble(),
    totalSpent: (json['totalSpent'] as num).toDouble(),
    month: json['month'] as String,
    year: (json['year'] as num).toInt(),
  );
}

Map<String, dynamic> _$BudgetToJson(Budget instance) => <String, dynamic>{
      'monthlyBudget': instance.monthlyBudget,
      'currentBalance': instance.currentBalance,
      'totalSpent': instance.totalSpent,
      'month': instance.month,
      'year': instance.year,
    };
