import 'package:flutter/material.dart';
import 'custom_gradient_theme.dart';

/// Main app theme constants
class AppTheme {
  /// Main color scheme for the app
  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF8B5CF6), // Solid primary color
    onPrimary: Colors.white,
    secondary: Color(0xFF3B82F6), // Blue
    onSecondary: Colors.white,
    tertiary: Color(0xFFEC4899), // Pink
    onTertiary: Colors.white,
    error: Color(0xFFEF4444), // Red
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xFF1E293B), // Dark text
    surfaceContainerHighest: Color(0xFFF1F5F9), // Lighter surface
    onSurfaceVariant: Color(0xFF475569), // Medium text
    outline: Color(0xFFCBD5E1), // Border color
    outlineVariant: Color(0xFFE2E8F0), // Lighter border
    shadow: Color(0xFF1E293B), // Shadow color
    scrim: Color(0xFF1E293B), // Scrim color
    inverseSurface: Color(0xFF1E293B), // Inverse surface
    onInverseSurface: Colors.white, // Inverse text
    inversePrimary: Color(0xFF8B5CF6), // Inverse primary
    surfaceTint: Color(0xFF8B5CF6), // Surface tint
  );

  /// Custom gradient theme (only for navigation bar)
  static const CustomGradientTheme gradientTheme = CustomGradientTheme(
    primaryGradient: LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    secondaryGradient: LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  /// App bar theme
  static const AppBarTheme appBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Color(0xFF8B5CF6), // Solid primary color
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  );

  /// Card theme
  static CardTheme get cardTheme => CardTheme(
        elevation: 2,
        shadowColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );

  /// Floating action button theme
  static const FloatingActionButtonThemeData floatingActionButtonTheme =
      FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF8B5CF6), // Solid primary color
    foregroundColor: Colors.white,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  /// Elevated button theme
  static ElevatedButtonThemeData get elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5CF6), // Solid primary color
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  /// Input decoration theme
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF8FAFC),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFCBD5E1)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFCBD5E1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide:
          BorderSide(color: Color(0xFF8B5CF6), width: 2), // Solid primary color
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFEF4444)),
    ),
  );

  /// Main app theme data
  static ThemeData get mainTheme => ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        extensions: const [gradientTheme],
        appBarTheme: appBarTheme,
        cardTheme: cardTheme,
        floatingActionButtonTheme: floatingActionButtonTheme,
        elevatedButtonTheme: elevatedButtonTheme,
        inputDecorationTheme: inputDecorationTheme,
      );

  /// Light theme variant
  static ThemeData get lightTheme => mainTheme;

  /// Dark theme variant (for future use)
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: colorScheme.copyWith(
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B),
          onSurface: Colors.white,
          surfaceContainerHighest: const Color(0xFF334155),
        ),
        extensions: const [gradientTheme],
        appBarTheme: appBarTheme.copyWith(
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: cardTheme,
        floatingActionButtonTheme: floatingActionButtonTheme,
        elevatedButtonTheme: elevatedButtonTheme,
        inputDecorationTheme: inputDecorationTheme.copyWith(
          fillColor: const Color(0xFF334155),
        ),
      );
}

/// Common gradient definitions for easy access
class AppGradients {
  /// Primary gradient (Primary to Secondary) - Only for navigation bar
  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary gradient (Primary to Cyan) - Only for navigation bar
  static const LinearGradient secondary = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient (Pink to Primary) - Only for navigation bar
  static const LinearGradient accent = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Background gradient (Surface to Surface Variant) - Solid colors
  static LinearGradient background(BuildContext context) {
    final theme = Theme.of(context);
    return LinearGradient(
      colors: [
        theme.colorScheme.surface,
        theme.colorScheme.surfaceContainerHighest,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  /// Navigation gradient (Primary to Secondary) - Only gradient in the app
  static LinearGradient navigation(BuildContext context) {
    return const LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

/// Common color constants
class AppColors {
  /// Primary colors - All solid
  static const Color primary = Color(0xFF8B5CF6); // Main primary color
  static const Color secondary = Color(0xFF3B82F6); // Blue
  static const Color tertiary = Color(0xFFEC4899); // Pink

  /// Surface colors
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color background = Color(0xFFF8FAFC);

  /// Text colors
  static const Color onSurface = Color(0xFF1E293B);
  static const Color onSurfaceVariant = Color(0xFF475569);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;

  /// Border colors
  static const Color outline = Color(0xFFCBD5E1);
  static const Color outlineVariant = Color(0xFFE2E8F0);

  /// Shadow colors
  static const Color shadow = Color(0xFF1E293B);
  static const Color scrim = Color(0xFF1E293B);

  /// Error colors
  static const Color error = Color(0xFFEF4444);
  static const Color onError = Colors.white;
}

/// Common text styles
class AppTextStyles {
  /// Heading text style
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.onSurface,
  );

  /// Subheading text style
  static const TextStyle subheading = TextStyle(
    fontSize: 16,
    color: AppColors.onSurfaceVariant,
    height: 1.5,
  );

  /// Body text style
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.onSurface,
  );

  /// Caption text style
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.onSurfaceVariant,
  );

  /// Button text style
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );
}

/// Common border radius values
class AppBorderRadius {
  /// Small border radius
  static const double small = 8.0;

  /// Medium border radius
  static const double medium = 12.0;

  /// Large border radius
  static const double large = 16.0;

  /// Extra large border radius
  static const double extraLarge = 20.0;

  /// Circular border radius
  static const double circular = 60.0;
}

/// Common spacing values
class AppSpacing {
  /// Extra small spacing
  static const double xs = 4.0;

  /// Small spacing
  static const double sm = 8.0;

  /// Medium spacing
  static const double md = 16.0;

  /// Large spacing
  static const double lg = 24.0;

  /// Extra large spacing
  static const double xl = 32.0;

  /// Extra extra large spacing
  static const double xxl = 40.0;
}
