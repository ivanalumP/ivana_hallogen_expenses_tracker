import 'package:flutter/material.dart';
import '../theme/theme_constants.dart';

/// Base screen widget that provides common functionality for all tab screens
/// Follows Single Responsibility Principle by handling common screen layout
abstract class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  /// The title to display in the app bar
  String get screenTitle;

  /// The icon to display in the center of the screen
  IconData get centerIcon;

  /// The color of the center icon
  Color get iconColor;

  /// The main title text to display
  String get mainTitle;

  /// The subtitle text to display
  String get subtitle;

  /// The tooltip for the floating action button
  String get fabTooltip;

  /// The action to perform when the floating action button is pressed
  VoidCallback? get onFabPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
        backgroundColor: AppColors.primary, // Solid primary color
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              centerIcon,
              size: 100,
              color: iconColor,
            ),
            const SizedBox(height: 20),
            Text(
              mainTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
