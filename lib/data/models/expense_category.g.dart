// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseCategory _$ExpenseCategoryFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name'],
  );
  return ExpenseCategory(
    name: json['name'] as String,
    recommendedPercentage:
        (json['recommendedPercentage'] as num?)?.toDouble() ?? 0.0,
    isFixed: json['isFixed'] as bool? ?? false,
  );
}

Map<String, dynamic> _$ExpenseCategoryToJson(ExpenseCategory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'recommendedPercentage': instance.recommendedPercentage,
      'isFixed': instance.isFixed,
    };
