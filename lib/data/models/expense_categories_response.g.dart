// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_categories_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseCategoriesResponse _$ExpenseCategoriesResponseFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['expenseCategories'],
  );
  return ExpenseCategoriesResponse(
    expenseCategories: (json['expenseCategories'] as List<dynamic>)
        .map((e) => ExpenseCategory.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ExpenseCategoriesResponseToJson(
        ExpenseCategoriesResponse instance) =>
    <String, dynamic>{
      'expenseCategories': instance.expenseCategories,
    };
