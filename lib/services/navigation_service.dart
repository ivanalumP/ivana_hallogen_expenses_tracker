import 'package:flutter/material.dart';

/// Abstract interface for navigation operations
/// Follows Dependency Inversion Principle
abstract class INavigationService {
  void navigateToTab(int index);
  void showSnackBar(String message);
}

/// Concrete implementation of the navigation service
class NavigationService implements INavigationService {
  final GlobalKey<NavigatorState> navigatorKey;
  final Function(int) onTabChange;

  NavigationService({
    required this.navigatorKey,
    required this.onTabChange,
  });

  @override
  void navigateToTab(int index) {
    onTabChange(index);
  }

  @override
  void showSnackBar(String message) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
