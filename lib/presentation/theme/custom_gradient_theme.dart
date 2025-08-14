import 'package:flutter/material.dart';

/// Custom gradient theme extension
class CustomGradientTheme extends ThemeExtension<CustomGradientTheme> {
  final LinearGradient primaryGradient;
  final LinearGradient secondaryGradient;
  final LinearGradient accentGradient;

  const CustomGradientTheme({
    required this.primaryGradient,
    required this.secondaryGradient,
    required this.accentGradient,
  });

  @override
  ThemeExtension<CustomGradientTheme> copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? secondaryGradient,
    LinearGradient? accentGradient,
  }) {
    return CustomGradientTheme(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
      accentGradient: accentGradient ?? this.accentGradient,
    );
  }

  @override
  ThemeExtension<CustomGradientTheme> lerp(
    covariant ThemeExtension<CustomGradientTheme>? other,
    double t,
  ) {
    if (other is! CustomGradientTheme) {
      return this;
    }
    return CustomGradientTheme(
      primaryGradient: LinearGradient.lerp(
        primaryGradient,
        other.primaryGradient,
        t,
      )!,
      secondaryGradient: LinearGradient.lerp(
        secondaryGradient,
        other.secondaryGradient,
        t,
      )!,
      accentGradient: LinearGradient.lerp(
        accentGradient,
        other.accentGradient,
        t,
      )!,
    );
  }
}
