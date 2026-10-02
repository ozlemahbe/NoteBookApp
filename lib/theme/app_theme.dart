import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme_config.dart';

/// Central theme controller and design system for SweetieNotes.
/// Provides dynamic theme switching between the 5 aesthetic themes (Sunset, Cosmic, Botanical, Sakura, Neon)
/// plus the original Pastel Dream, while maintaining 100% backward compatibility with all existing code.
class AppTheme {
  static const String _prefThemeKey = 'selected_app_theme';

  /// Global notifier for reactive theme updates across the entire application
  static final ValueNotifier<AppThemeType> themeNotifier =
      ValueNotifier<AppThemeType>(AppThemeType.sunsetGlow);

  /// Currently active theme configuration
  static ThemeConfig get current => ThemeConfig.fromType(themeNotifier.value);

  /// Load theme from local storage
  static Future<void> loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString(_prefThemeKey);
      if (savedId != null) {
        final config = ThemeConfig.fromId(savedId);
        themeNotifier.value = config.type;
      }
    } catch (e) {
      debugPrint('Tema yükleme hatası: $e');
    }
  }

  /// Change active theme and persist choice
  static Future<void> setTheme(AppThemeType type) async {
    themeNotifier.value = type;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefThemeKey, ThemeConfig.fromType(type).id);
    } catch (e) {
      debugPrint('Tema kaydetme hatası: $e');
    }
  }

  // --- Core Colors (Static constants for const widgets compatibility) ---
  static const Color background = Color(0xFFFBF9F5);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color searchBarBg = Color(0xFFF2ECF9);

  // Accents
  static const Color primaryLavender = Color(0xFFC8B6FF);
  static const Color deepLavender = Color(0xFF8F7193);
  static const Color activeNavBox = Color(0xFFDDD2F7);

  static const Color pastelPink = Color(0xFFFFD6E0);
  static const Color accentPink = Color(0xFFFF9AA2);
  static const Color pastelPeach = Color(0xFFFFE5D9);
  static const Color pastelMint = Color(0xFFD8F3DC);
  static const Color pastelBlue = Color(0xFFD0E8FF);
  static const Color pastelYellow = Color(0xFFFFF1C5);

  // Note paper colors list
  static const List<Color> noteColors = [
    Color(0xFFF5EEFD),
    Color(0xFFFFEEF2),
    Color(0xFFE8F5E9),
    Color(0xFFE3F2FD),
    Color(0xFFFFF8E1),
    Color(0xFFFFEFE9),
  ];

  // Typography Colors
  static const Color textDark = Color(0xFF383042);
  static const Color textMuted = Color(0xFF8C8296);
  static const Color textHint = Color(0xFFB5ADC0);

  // Corner Radii
  static const double radiusLarge = 20.0;
  static const double radiusCard = 16.0;
  static const double radiusPill = 30.0;

  static BorderRadius get borderLarge => BorderRadius.circular(radiusLarge);
  static BorderRadius get borderCard => BorderRadius.circular(radiusCard);
  static BorderRadius get borderPill => BorderRadius.circular(radiusPill);

  // Dynamic Shadows
  static List<BoxShadow> get antigravityShadow => current.cardShadow;

  static List<BoxShadow> get lavenderGlowShadow => [
        BoxShadow(
          color: current.primaryColor.withValues(alpha: 0.35),
          blurRadius: 16,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ];

  /// App ThemeData configuration with GoogleFonts (Quicksand)
  static ThemeData get themeData {
    final cfg = current;
    final baseTextTheme = GoogleFonts.quicksandTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: cfg.isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: cfg.scaffoldBg,
      primaryColor: cfg.primaryColor,
      colorScheme: ColorScheme(
        brightness: cfg.isDark ? Brightness.dark : Brightness.light,
        primary: cfg.primaryColor,
        onPrimary: cfg.isDark ? Colors.white : Colors.white,
        secondary: cfg.accentColor,
        onSecondary: Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: cfg.cardBackground,
        onSurface: cfg.textDark,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          color: cfg.textDark,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: cfg.textDark,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: cfg.textDark,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: cfg.textDark,
          fontSize: 15,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: cfg.textMuted,
          fontSize: 13.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.quicksand(
          color: cfg.textDark,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: cfg.textDark),
      ),
      cardTheme: CardThemeData(
        color: cfg.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderCard,
        ),
      ),
    );
  }
}
