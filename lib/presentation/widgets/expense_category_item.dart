import 'package:flutter/material.dart';
import '../../data/models/expense_category.dart';

class ExpenseCategoryItem extends StatelessWidget {
  final ExpenseCategory category;
  final VoidCallback? onTap;

  const ExpenseCategoryItem({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: category.isFixed ? Colors.blue : Colors.green,
          child: Icon(
            category.isFixed ? Icons.lock : Icons.category,
            color: Colors.white,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          category.hasRecommendedPercentage
              ? 'Recommended percentage: ${category.safeRecommendedPercentage.toStringAsFixed(0)}%'
              : 'Recommended percentage: Flexible',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
