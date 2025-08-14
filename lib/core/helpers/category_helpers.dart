import 'package:flutter/material.dart';

/// Helper class for category-related utilities
class CategoryHelpers {
  /// Get the appropriate color for a given category
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'transportation':
        return Colors.blue;
      case 'entertainment':
        return Colors.purple;
      case 'shopping':
        return Colors.pink;
      case 'health':
        return Colors.green;
      case 'utilities':
        return Colors.indigo;
      case 'housing':
        return Colors.brown;
      default:
        return const Color(0xFF8B5CF6); // Default primary color
    }
  }

  /// Get the appropriate icon for a given category
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_car;
      case 'entertainment':
        return Icons.movie;
      case 'shopping':
        return Icons.shopping_bag;
      case 'health':
        return Icons.health_and_safety;
      case 'utilities':
        return Icons.electric_bolt;
      case 'housing':
        return Icons.home;
      default:
        return Icons.category;
    }
  }
}
