import 'package:flutter/material.dart';

/// Agricultural Theme - Clean White + Light Green palette
/// Represents agriculture, livestock, growth, and sustainability
class AppTheme {
  // Primary Agricultural Colors (from web palette)
  static const Color primaryGreen = Color(0xFF2A6F4F); // hsl(152,45%,30%)
  static const Color lightGreen = Color(0xFF34B262); // hsl(142,55%,45%)
  static const Color paleGreen = Color(0x1A34B262); // 10% of lightGreen for soft fills

  // Background Colors
  static const Color pureWhite = Color(0xFFFFFFFF); // Base surface
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color lightBackground = Color(0xFFFFFFFF);

  // Accent Tones
  static const Color accentOrange = Color(0xFFF47B25); // hsl(25,90%,55%)

  // Text Colors (web-to-app mapping)
  static const Color darkText = Color(0xFF1C402F); // Headings / footer
  static const Color mediumText = Color(0xFF1F4734); // Primary text
  static const Color lightText = Color(0xFF527A67); // Secondary text
  static const Color subtleText = Color(0xFF5C8A74); // Muted/supporting

  // Status Colors
  static const Color successGreen = primaryGreen; // Success aligns with brand
  static const Color warningYellow = accentOrange; // Warm warning highlight
  static const Color criticalRed = Color(0xFFEF5350); // Keep distinct for critical
  static const Color infoBlue = Color(0xFF5C8A74); // Calm info tone from palette

  // Shadow and Border Colors
  static const Color softShadow = Color(0x1A000000); // Soft shadows
  static const Color borderGray = Color(0xFFD9E8DE); // hsl(140,25%,88%)

  /// Light Theme - Main theme for the app
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        onPrimary: pureWhite,
        primaryContainer: lightGreen,
        onPrimaryContainer: pureWhite,

        secondary: lightGreen,
        onSecondary: pureWhite,
        secondaryContainer: paleGreen,
        onSecondaryContainer: mediumText,

        tertiary: accentOrange,
        onTertiary: pureWhite,

        surface: pureWhite,
        onSurface: mediumText,
        surfaceVariant: offWhite,
        onSurfaceVariant: lightText,

        background: offWhite,
        onBackground: mediumText,

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
        secondarySelectedColor: lightGreen,
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
          color: mediumText,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: mediumText,
          height: 1.45,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: lightText,
          height: 1.35,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: mediumText,
          height: 1.45,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: lightText,
          height: 1.35,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: lightText,
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
          primaryGreen,
          lightGreen,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  /// Card Gradient - Subtle green tint
  static BoxDecoration get cardGradient {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [pureWhite, lightGreen.withOpacity(0.08)],
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
          lightGreen,
          primaryGreen,
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
      gradient: LinearGradient(
        colors: [
          accentOrange.withOpacity(0.85),
          accentOrange,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
    );
  }
}
