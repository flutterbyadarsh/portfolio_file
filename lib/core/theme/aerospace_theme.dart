import 'package:flutter/material.dart';

/// Aerospace Modernist Material 3 design tokens & theme builders.
/// Dark Mode: Deep Navy Blue (#0A192F), Pure White (#FFFFFF), Slate Grey (#94A3B8) / white54, Bold Red (#DC2626).
/// Light Mode: Pale Slate-Blue (#F6FAFE), Pure White Cards (#FFFFFF), Deep Navy (#0A192F), Bold Red (#DC2626).
class AerospaceTheme {
  AerospaceTheme._();

  // Core Navy Blue Palette
  static const Color canvasDark = Color(0xFF0A192F); // Deep Navy Blue (#0A192F)
  static const Color surfaceDark = Color(0xFF0F2342);
  static const Color surfaceDarkElevated = Color(0xFF163159);
  static const Color navyPrimary = Color(0xFF0A192F);
  static const Color navyHover = Color(0xFF1E293B);

  // Core Light Palette
  static const Color canvasLight = Color(0xFFF0F4F8);
  static const Color canvasLightBright = Color(0xFFF6FAFE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLightMuted = Color(0xFFEAEFF5);

  // Typography Colors
  static const Color textPrimaryLight = Color(0xFF0A192F);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // Pure White (#FFFFFF)
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate Grey (#94A3B8)
  static const Color textMutedDark = Colors.white54;

  // High-Signal Red Accent & Status
  static const Color accentScarlet = Color(0xFFDC2626); // Bold Red (#DC2626)
  static const Color accentScarletDeep = Color(0xFFBB0112);
  static const Color accentScarletBright = Color(0xFFEF4444);
  static const Color accentScarletGlow = Color(0x33DC2626);
  static const Color accentGreen = Color(0xFF10B981);

  // Borders & Hairlines
  static const Color hairlineLight = Color(0xFFE2E8F0);
  static const Color hairlineLightStrong = Color(0xFFCBD5E1);
  static const Color hairlineDark = Color(0x2EFFFFFF);
  static const Color hairlineDarkSoft = Color(0x1FFFFFFF);

  // Level 1 Card Shadow (Cool Navy Tinted)
  static List<BoxShadow> get elevationLevel1 => [
        const BoxShadow(
          color: Color(0x0D0A192F),
          offset: Offset(0, 1),
          blurRadius: 3,
        ),
        const BoxShadow(
          color: Color(0x080A192F),
          offset: Offset(0, 2),
          blurRadius: 6,
          spreadRadius: -1,
        ),
      ];

  // Level 2 Hover & Floating Shadow
  static List<BoxShadow> get floatingBadgeShadowLight => [
        const BoxShadow(
          color: Color(0x140A192F),
          offset: Offset(0, 8),
          blurRadius: 20,
          spreadRadius: -4,
        ),
        const BoxShadow(
          color: Color(0x0A0A192F),
          offset: Offset(0, 4),
          blurRadius: 6,
          spreadRadius: -2,
        ),
      ];

  static List<BoxShadow> get floatingBadgeShadowDark => [
        const BoxShadow(
          color: Color(0x66000000),
          offset: Offset(0, 10),
          blurRadius: 24,
          spreadRadius: -2,
        ),
        const BoxShadow(
          color: Color(0x28DC2626),
          offset: Offset(0, 0),
          blurRadius: 16,
        ),
      ];

  /// Material 3 Light Theme (Pale Slate-Blue Canvas, Pure White Surfaces, Navy & Red)
  static ThemeData lightTheme() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: navyPrimary,
      onPrimary: Colors.white,
      primaryContainer: surfaceLightMuted,
      onPrimaryContainer: navyPrimary,
      secondary: accentScarlet,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFFDAD6),
      onSecondaryContainer: Color(0xFF410002),
      tertiary: navyHover,
      onTertiary: Colors.white,
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      outline: hairlineLightStrong,
      outlineVariant: hairlineLight,
      shadow: navyPrimary,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBg: canvasLightBright,
      inputFill: surfaceLight,
      borderColor: hairlineLightStrong,
    );
  }

  /// Material 3 Dark Theme (Deep Navy #0A192F, Pure White #FFFFFF, Slate Grey #94A3B8, Bold Red #DC2626)
  static ThemeData darkTheme() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: accentScarlet,
      onPrimary: Colors.white,
      primaryContainer: surfaceDark,
      onPrimaryContainer: textPrimaryDark,
      secondary: accentScarletBright,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF410002),
      onSecondaryContainer: Color(0xFFFFDAD6),
      tertiary: surfaceDarkElevated,
      onTertiary: textPrimaryDark,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: Colors.white54,
      outlineVariant: hairlineDark,
      shadow: Colors.black,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBg: canvasDark,
      inputFill: canvasDark,
      borderColor: hairlineDark,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBg,
    required Color inputFill,
    required Color borderColor,
  }) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final primaryText = isDark ? textPrimaryDark : textPrimaryLight;
    final secondaryText = isDark ? textSecondaryDark : textSecondaryLight;

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      dividerColor: isDark ? hairlineDarkSoft : hairlineLight,
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? hairlineDarkSoft : hairlineLight,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentScarlet,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48), // Native iOS/Android 48px touch target
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryText,
          side: BorderSide(color: borderColor),
          minimumSize: const Size(48, 48), // Native iOS/Android 48px touch target
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(44, 44),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        hintStyle: TextStyle(color: secondaryText, fontSize: 13),
        labelStyle: TextStyle(color: secondaryText, fontSize: 13),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accentScarlet, width: 1.5),
        ),
      ),
    );
  }
}

/// Convenient adaptive palette resolved from current Material 3 brightness.
class AerospacePalette {
  final bool isDark;
  final Color canvas;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color hairline;
  final Color accent;
  final Color navyAction;
  final List<BoxShadow> cardShadow;

  const AerospacePalette._({
    required this.isDark,
    required this.canvas,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.hairline,
    required this.accent,
    required this.navyAction,
    required this.cardShadow,
  });

  factory AerospacePalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const AerospacePalette._(
        isDark: true,
        canvas: AerospaceTheme.canvasDark,
        surface: AerospaceTheme.surfaceDark,
        surfaceElevated: AerospaceTheme.surfaceDarkElevated,
        textPrimary: AerospaceTheme.textPrimaryDark,
        textSecondary: AerospaceTheme.textSecondaryDark,
        textMuted: Colors.white54,
        hairline: AerospaceTheme.hairlineDark,
        accent: AerospaceTheme.accentScarlet,
        navyAction: AerospaceTheme.surfaceDarkElevated,
        cardShadow: [],
      );
    }
    return AerospacePalette._(
      isDark: false,
      canvas: AerospaceTheme.canvasLightBright,
      surface: AerospaceTheme.surfaceLight,
      surfaceElevated: AerospaceTheme.surfaceLightMuted,
      textPrimary: AerospaceTheme.textPrimaryLight,
      textSecondary: AerospaceTheme.textSecondaryLight,
      textMuted: AerospaceTheme.textSecondaryLight,
      hairline: AerospaceTheme.hairlineLight,
      accent: AerospaceTheme.accentScarlet,
      navyAction: AerospaceTheme.navyPrimary,
      cardShadow: AerospaceTheme.elevationLevel1,
    );
  }
}
