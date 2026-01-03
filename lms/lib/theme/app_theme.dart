import 'package:flutter/material.dart';

/// Agricultural Theme - Clean White + Light Green palette
/// Represents agriculture, livestock, growth, and sustainability
class AppTheme {
  // Primary Agricultural Colors
  static const Color primaryGreen = Color(
    0xFF7CB342,
  ); // Soft agricultural green (leaf/pasture)
  static const Color lightGreen = Color(0xFF9CCC65); // Light pasture green
  static const Color mintGreen = Color(0xFFA5D6A7); // Light mint/sage green
  static const Color paleGreen = Color(0xFFC5E1A5); // Very light green

  // Background Colors
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color lightBackground = Color(0xFFF5F5F5);

  // Accent Earth Tones (subtle, used sparingly)
  static const Color lightBrown = Color(0xFFBCAAA4);
  static const Color mutedYellow = Color(0xFFFFF9C4);
  static const Color warmBeige = Color(0xFFEFEBE9);

  // Text Colors (high contrast for outdoor readability)
  static const Color darkText = Color(
    0xFF1B5E20,
  ); // Dark green for primary text
  static const Color mediumText = Color(
    0xFF558B2F,
  ); // Medium green for secondary text
  static const Color lightText = Color(
    0xFF689F38,
  ); // Light green for tertiary text
  static const Color subtleText = Color(0xFF9E9E9E); // Gray for subtle text

  // Status Colors (green-based except critical alerts)
  static const Color successGreen = Color(0xFF66BB6A);
  static const Color warningYellow = Color(0xFFFFEE58);
  static const Color criticalRed = Color(
    0xFFEF5350,
  ); // Only for critical issues
  static const Color infoBlue = Color(0xFF81C784); // Muted blue-green

  // Shadow and Border Colors
  static const Color softShadow = Color(0x1A000000); // Soft shadows
  static const Color borderGray = Color(0xFFE0E0E0);

  /// Light Theme - Main theme for the app
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        onPrimary: pureWhite,
        primaryContainer: paleGreen,
        onPrimaryContainer: darkText,

        secondary: mintGreen,
        onSecondary: darkText,
        secondaryContainer: Color(0xFFE8F5E9),
        onSecondaryContainer: darkText,

        tertiary: lightBrown,
        onTertiary: pureWhite,

        surface: pureWhite,
        onSurface: darkText,
        surfaceVariant: offWhite,
        onSurfaceVariant: mediumText,

        background: offWhite,
        onBackground: darkText,

        error: criticalRed,
        onError: pureWhite,

        outline: borderGray,
        shadow: softShadow,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: offWhite,

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: pureWhite,
        foregroundColor: darkText,
        shadowColor: softShadow,
        titleTextStyle: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: softShadow,
        color: pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: pureWhite,
          elevation: 2,
          shadowColor: softShadow,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Filled Button Theme (Primary solid buttons)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: pureWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button Theme (Secondary buttons)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: pureWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderGray, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderGray, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: criticalRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: criticalRed, width: 2),
        ),
        labelStyle: const TextStyle(color: mediumText, fontSize: 16),
        hintStyle: TextStyle(color: subtleText.withOpacity(0.6), fontSize: 16),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: paleGreen.withOpacity(0.3),
        deleteIconColor: mediumText,
        disabledColor: borderGray,
        selectedColor: primaryGreen,
        secondarySelectedColor: mintGreen,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: const TextStyle(
          color: darkText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: pureWhite,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryGreen,
        linearTrackColor: paleGreen,
        circularTrackColor: paleGreen,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: mediumText, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: borderGray,
        thickness: 1,
        space: 16,
      ),

      // Text Theme - High contrast for outdoor readability
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
          color: darkText,
          height: 1.1,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          color: darkText,
          height: 1.15,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: darkText,
          height: 1.2,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: darkText,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: darkText,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: darkText,
          height: 1.35,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: darkText,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          color: darkText,
          height: 1.5,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: darkText,
          height: 1.45,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: darkText,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: darkText,
          height: 1.45,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: mediumText,
          height: 1.35,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: darkText,
          height: 1.45,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: mediumText,
          height: 1.35,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: mediumText,
          height: 1.3,
        ),
      ),
    );
  }

  /// Gradient Decorations - Agricultural inspired
  static BoxDecoration get agriculturalGradient {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFFAFAFA), // Off-white
          Color(0xFFF1F8E9), // Very light green
          Color(0xFFE8F5E9), // Pale mint
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  /// Card Gradient - Subtle green tint
  static BoxDecoration get cardGradient {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [pureWhite, paleGreen.withOpacity(0.1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: softShadow, blurRadius: 8, offset: const Offset(0, 2)),
      ],
    );
  }

  /// Success/Growth Gradient
  static BoxDecoration get growthGradient {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xFF81C784), // Light green
          Color(0xFF66BB6A), // Medium green
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
    );
  }

  /// Warning/Attention Gradient
  static BoxDecoration get warningGradient {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xFFFFF9C4), // Light yellow
          Color(0xFFFFEE58), // Muted yellow
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
    );
  }
}
