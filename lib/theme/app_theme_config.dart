import 'package:flutter/material.dart';

enum AppThemeType {
  sunsetGlow,       // Gün Batımı 🌅 (Image 1)
  cosmicDream,      // Kozmik Gece 🌌 (Image 2)
  botanical,        // Botanik Bahçe 🌿 (Image 3)
  sakura,           // Kiraz Çiçeği 🌸 (Image 4)
  neonGlass,        // Gece Parıltısı ✨ (Image 5)
  pastelDream,      // Pastel Rüya 💜 (Orijinal)
}

/// Rich theme configuration model supporting the visual styles from user images
class ThemeConfig {
  final AppThemeType type;
  final String id;
  final String name;
  final String emoji;
  final bool isDark;
  final List<Color> previewColors;

  // Background
  final Color scaffoldBg;
  final LinearGradient backgroundGradient;

  // Typography & Content
  final Color textDark;
  final Color textMuted;
  final Color textHint;
  final Color primaryColor;
  final Color accentColor;

  // Search Bar
  final Color searchBarBg;
  final Color searchBarBorderColor;
  final Color searchBarIconColor;
  final Color searchBarTextColor;
  final Color searchBarHintColor;
  final IconData searchBarTrailingIcon;

  // Note Cards
  final Color cardBackground;
  final Color cardBorderColor;
  final List<BoxShadow> cardShadow;
  final List<Color> notePaperColors;

  // Floating Bottom Bar
  final Color navBarBg;
  final Color navBarBorderColor;
  final Color activeNavBox;
  final Color activeNavBorder;
  final Color activeNavIcon;
  final Color inactiveNavIcon;

  // Floating Action Button
  final List<Color> fabGradient;
  final Color fabShadowColor;
  final Color fabIconColor;

  // Themed Header Elements
  final String? headerTitle;
  final String? headerSubtitle;
  final String? headerBadge;
  final String? headerTag;

  const ThemeConfig({
    required this.type,
    required this.id,
    required this.name,
    required this.emoji,
    required this.isDark,
    required this.previewColors,
    required this.scaffoldBg,
    required this.backgroundGradient,
    required this.textDark,
    required this.textMuted,
    required this.textHint,
    required this.primaryColor,
    required this.accentColor,
    required this.searchBarBg,
    required this.searchBarBorderColor,
    required this.searchBarIconColor,
    required this.searchBarTextColor,
    required this.searchBarHintColor,
    required this.searchBarTrailingIcon,
    required this.cardBackground,
    required this.cardBorderColor,
    required this.cardShadow,
    required this.notePaperColors,
    required this.navBarBg,
    required this.navBarBorderColor,
    required this.activeNavBox,
    required this.activeNavBorder,
    required this.activeNavIcon,
    required this.inactiveNavIcon,
    required this.fabGradient,
    required this.fabShadowColor,
    required this.fabIconColor,
    this.headerTitle,
    this.headerSubtitle,
    this.headerBadge,
    this.headerTag,
  });

  // -------------------------------------------------------------
  // 1. GÜN BATIMI (Sunset Glow - Image 1)
  // -------------------------------------------------------------
  static final ThemeConfig sunsetGlow = ThemeConfig(
    type: AppThemeType.sunsetGlow,
    id: 'sunset_glow',
    name: 'Gün Batımı',
    emoji: '🌅',
    isDark: false,
    previewColors: const [
      Color(0xFFFF9E80),
      Color(0xFFFFCC80),
      Color(0xFFFFE0B2),
      Color(0xFFFF6584),
    ],
    scaffoldBg: const Color(0xFFFFEFE6),
    backgroundGradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFF8E72), // Warm peach coral top
        Color(0xFFFFA685),
        Color(0xFFFFC599),
        Color(0xFFFFD8B3),
        Color(0xFFFFE8D6), // Soft warm cream bottom
      ],
      stops: [0.0, 0.25, 0.55, 0.8, 1.0],
    ),
    textDark: const Color(0xFF4A282E),
    textMuted: const Color(0xFF8E6168),
    textHint: const Color(0xFFBFA0A5),
    primaryColor: const Color(0xFFFF6584),
    accentColor: const Color(0xFFE24B6A),
    searchBarBg: const Color(0xFFFFF7F2),
    searchBarBorderColor: Colors.white,
    searchBarIconColor: const Color(0xFFE06C78),
    searchBarTextColor: const Color(0xFF4A282E),
    searchBarHintColor: const Color(0xFFBFA0A5),
    searchBarTrailingIcon: Icons.wb_sunny_outlined,
    cardBackground: Colors.white,
    cardBorderColor: const Color(0x60FFFFFF),
    cardShadow: [
      BoxShadow(
        color: const Color(0xFFD66D57).withValues(alpha: 0.12),
        blurRadius: 16,
        spreadRadius: 1,
        offset: const Offset(0, 6),
      ),
    ],
    notePaperColors: const [
      Color(0xFFF1E4FA), // Soft Lilac (shopping cart)
      Color(0xFFFFEAE2), // Soft Peach (goals sun)
      Color(0xFFE5F7EB), // Soft Mint (books)
      Color(0xFFE1F0FD), // Soft Sky Blue (holiday palm)
      Color(0xFFFFF6D8), // Soft Warm Vanilla (recipe)
      Color(0xFFFFE7EA), // Soft Blush Rose (quote)
    ],
    navBarBg: const Color(0xFFFFF5F0),
    navBarBorderColor: Colors.white.withValues(alpha: 0.9),
    activeNavBox: const Color(0xFFFFD4DC),
    activeNavBorder: const Color(0xFFFF8E9E),
    activeNavIcon: const Color(0xFFC72848),
    inactiveNavIcon: const Color(0xFF9E7780),
    fabGradient: const [Color(0xFFFF6584), Color(0xFFFF8E72)],
    fabShadowColor: const Color(0xFFFF6584),
    fabIconColor: Colors.white,
    headerTitle: 'Bugün harika olacak! ♡',
    headerSubtitle: 'KÜÇÜK NOTLAR\nBÜYÜK HAYALLER ♡',
    headerBadge: 'Günün Işığı ☀️',
  );

  // -------------------------------------------------------------
  // 2. KOZMİK GECE (Cosmic Dream - Image 2)
  // -------------------------------------------------------------
  static final ThemeConfig cosmicDream = ThemeConfig(
    type: AppThemeType.cosmicDream,
    id: 'cosmic_dream',
    name: 'Kozmik Gece',
    emoji: '🌌',
    isDark: true,
    previewColors: const [
      Color(0xFF2C194D),
      Color(0xFF553285),
      Color(0xFF9D65C9),
      Color(0xFFD8B4F8),
    ],
    scaffoldBg: const Color(0xFF1F1338),
    backgroundGradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF22153D),
        Color(0xFF321D54),
        Color(0xFF43266E),
        Color(0xFF553285),
        Color(0xFF673F9D),
      ],
    ),
    textDark: const Color(0xFF341A52),
    textMuted: const Color(0xFFBFAAD9),
    textHint: const Color(0xFF8F76B0),
    primaryColor: const Color(0xFF9D65C9),
    accentColor: const Color(0xFFD8B4F8),
    searchBarBg: const Color(0x6643266E),
    searchBarBorderColor: const Color(0x80B388FF),
    searchBarIconColor: const Color(0xFFD8B4F8),
    searchBarTextColor: Colors.white,
    searchBarHintColor: const Color(0xFFBFAAD9),
    searchBarTrailingIcon: Icons.auto_awesome,
    cardBackground: const Color(0xFFEDE4F9),
    cardBorderColor: const Color(0x99D8B4F8),
    cardShadow: [
      BoxShadow(
        color: const Color(0xFF9D65C9).withValues(alpha: 0.25),
        blurRadius: 18,
        spreadRadius: 2,
        offset: const Offset(0, 6),
      ),
    ],
    notePaperColors: const [
      Color(0xFFF2EAFE), // Dreamy lavender
      Color(0xFFF8E7F6), // Stardust pink
      Color(0xFFE8F1FD), // Moonlit blue
      Color(0xFFE0EAFC), // Galaxy twilight
      Color(0xFFFDF0E6), // Starlight vanilla
      Color(0xFFEDE4F9), // Deep lilac dream
    ],
    navBarBg: const Color(0x8C2E1B4F),
    navBarBorderColor: const Color(0x66B388FF),
    activeNavBox: const Color(0xFF7B52B3),
    activeNavBorder: const Color(0xFFD8B4F8),
    activeNavIcon: Colors.white,
    inactiveNavIcon: const Color(0xFFBFAAD9),
    fabGradient: const [Color(0xFF8E54E9), Color(0xFFB388FF)],
    fabShadowColor: const Color(0xFF8E54E9),
    fabIconColor: Colors.white,
    headerTitle: 'Kozmik Rüyalar ✨',
    headerSubtitle: 'YILDIZLAR KADAR PARLAK DÜŞLER 🌙',
    headerBadge: 'Ay Işığı 🌙',
  );

  // -------------------------------------------------------------
  // 3. BOTANİK BAHÇE (Botanical Serenity - Image 3)
  // -------------------------------------------------------------
  static final ThemeConfig botanical = ThemeConfig(
    type: AppThemeType.botanical,
    id: 'botanical',
    name: 'Botanik Bahçe',
    emoji: '🌿',
    isDark: false,
    previewColors: const [
      Color(0xFFE8EFE9),
      Color(0xFFD0DDD1),
      Color(0xFF87A987),
      Color(0xFF2D4A3E),
    ],
    scaffoldBg: const Color(0xFFF3F7F4),
    backgroundGradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFAFBF9),
        Color(0xFFF0F5F1),
        Color(0xFFE5EEE7),
        Color(0xFFDDE8DF),
      ],
    ),
    textDark: const Color(0xFF1E352B),
    textMuted: const Color(0xFF5A7569),
    textHint: const Color(0xFF96ACA0),
    primaryColor: const Color(0xFF52796F),
    accentColor: const Color(0xFF2F3E46),
    searchBarBg: Colors.white,
    searchBarBorderColor: const Color(0x3352796F),
    searchBarIconColor: const Color(0xFF52796F),
    searchBarTextColor: const Color(0xFF1E352B),
    searchBarHintColor: const Color(0xFF96ACA0),
    searchBarTrailingIcon: Icons.eco_rounded,
    cardBackground: Colors.white,
    cardBorderColor: const Color(0x4087A987),
    cardShadow: [
      BoxShadow(
        color: const Color(0xFF2D4A3E).withValues(alpha: 0.07),
        blurRadius: 15,
        spreadRadius: 1,
        offset: const Offset(0, 5),
      ),
    ],
    notePaperColors: const [
      Color(0xFFFFFFFF), // Pure linen
      Color(0xFFFFF2EF), // Soft petal
      Color(0xFFEAF4EC), // Fresh sage mint
      Color(0xFFE5F1F4), // Coastal sea foam
      Color(0xFFFFF9ED), // Warm oat cream
      Color(0xFFEEF5EF), // Eucalyptus paper
    ],
    navBarBg: const Color(0xF2FFFFFF),
    navBarBorderColor: const Color(0x4052796F),
    activeNavBox: const Color(0xFFCFDFD2),
    activeNavBorder: const Color(0xFF87A987),
    activeNavIcon: const Color(0xFF1E352B),
    inactiveNavIcon: const Color(0xFF7A9487),
    fabGradient: const [Color(0xFF52796F), Color(0xFF354F52)],
    fabShadowColor: const Color(0xFF52796F),
    fabIconColor: Colors.white,
    headerTitle: 'Notlarınla Daha Fazlası Mümkün',
    headerSubtitle: 'DÜŞÜN • PLANLA • YAŞA',
    headerBadge: 'Daha Güzel Yarınlara 🍃',
  );

  // -------------------------------------------------------------
  // 4. KİRAZ ÇİÇEĞİ (Sakura Blossom - Image 4)
  // -------------------------------------------------------------
  static final ThemeConfig sakura = ThemeConfig(
    type: AppThemeType.sakura,
    id: 'sakura',
    name: 'Kiraz Çiçeği',
    emoji: '🌸',
    isDark: false,
    previewColors: const [
      Color(0xFFFCEBEB),
      Color(0xFFF7D2D6),
      Color(0xFFE57B88),
      Color(0xFF962D3E),
    ],
    scaffoldBg: const Color(0xFFFAF1F1),
    backgroundGradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFFF6F6),
        Color(0xFFFAECEC),
        Color(0xFFF5E0E0),
        Color(0xFFEED4D4),
      ],
    ),
    textDark: const Color(0xFF4A252C),
    textMuted: const Color(0xFF8C5D65),
    textHint: const Color(0xFFBA969C),
    primaryColor: const Color(0xFFD65A6E),
    accentColor: const Color(0xFF9C2A3D),
    searchBarBg: const Color(0xFFFFF8F8),
    searchBarBorderColor: const Color(0x40D65A6E),
    searchBarIconColor: const Color(0xFFD65A6E),
    searchBarTextColor: const Color(0xFF4A252C),
    searchBarHintColor: const Color(0xFFBA969C),
    searchBarTrailingIcon: Icons.filter_vintage_rounded,
    cardBackground: Colors.white,
    cardBorderColor: const Color(0x33D65A6E),
    cardShadow: [
      BoxShadow(
        color: const Color(0xFF9C2A3D).withValues(alpha: 0.08),
        blurRadius: 15,
        spreadRadius: 1,
        offset: const Offset(0, 5),
      ),
    ],
    notePaperColors: const [
      Color(0xFFFFF2F4), // Sakura milk
      Color(0xFFFDE8EC), // Fuji sunrise pink
      Color(0xFFEFF5F0), // Bamboo green
      Color(0xFFE8F1F8), // Japanese sea mist
      Color(0xFFFFF8EC), // Mochi pastry cream
      Color(0xFFFBE4E8), // Hanami blossom
    ],
    navBarBg: const Color(0xF5FFF8F8),
    navBarBorderColor: const Color(0x40D65A6E),
    activeNavBox: const Color(0xFFFFDCE2),
    activeNavBorder: const Color(0xFFF5A3B0),
    activeNavIcon: const Color(0xFF9C2A3D),
    inactiveNavIcon: const Color(0xFF9E727A),
    fabGradient: const [Color(0xFFD65A6E), Color(0xFFA63245)],
    fabShadowColor: const Color(0xFFD65A6E),
    fabIconColor: Colors.white,
    headerTitle: 'やることは、きっとできる',
    headerSubtitle: 'Küçük adımlar, büyük yarınlar...',
    headerBadge: 'Kiraz Mevsimi 🌸',
  );

  // -------------------------------------------------------------
  // 5. GECE PARILTISI (Neon Glassmorphism - Image 5)
  // -------------------------------------------------------------
  static final ThemeConfig neonGlass = ThemeConfig(
    type: AppThemeType.neonGlass,
    id: 'neon_glass',
    name: 'Gece Parıltısı',
    emoji: '✨',
    isDark: true,
    previewColors: const [
      Color(0xFF0F0B18),
      Color(0xFF7C3AED),
      Color(0xFFEC4899),
      Color(0xFF06B6D4),
    ],
    scaffoldBg: const Color(0xFF0B0813),
    backgroundGradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF0D0A17),
        Color(0xFF130E22),
        Color(0xFF18122C),
        Color(0xFF1C1434),
      ],
    ),
    textDark: const Color(0xFF4A282E),
    textMuted: const Color(0xFFA69EB8),
    textHint: const Color(0xFF6B637E),
    primaryColor: const Color(0xFFA855F7),
    accentColor: const Color(0xFFEC4899),
    searchBarBg: const Color(0x601F1836),
    searchBarBorderColor: const Color(0x80A855F7),
    searchBarIconColor: const Color(0xFFC084FC),
    searchBarTextColor: Colors.white,
    searchBarHintColor: const Color(0xFFA69EB8),
    searchBarTrailingIcon: Icons.auto_awesome,
    cardBackground: const Color(0x381F1836),
    cardBorderColor: const Color(0x66A855F7),
    cardShadow: [
      BoxShadow(
        color: const Color(0xFFA855F7).withValues(alpha: 0.28),
        blurRadius: 20,
        spreadRadius: 1,
        offset: const Offset(0, 6),
      ),
    ],
    notePaperColors: const [
      Color(0x553B185F), // Neon purple frosted
      Color(0x555F1840), // Neon magenta frosted
      Color(0x44084C42), // Neon cyan frosted
      Color(0x4414345F), // Neon deep blue frosted
      Color(0x445F4810), // Neon amber frosted
      Color(0x554A185F), // Neon violet frosted
    ],
    navBarBg: const Color(0x99120C22),
    navBarBorderColor: const Color(0x66A855F7),
    activeNavBox: const Color(0xFF6D28D9),
    activeNavBorder: const Color(0xFFC084FC),
    activeNavIcon: Colors.white,
    inactiveNavIcon: const Color(0xFFA69EB8),
    fabGradient: const [Color(0xFFA855F7), Color(0xFFEC4899)],
    fabShadowColor: const Color(0xFFA855F7),
    fabIconColor: Colors.white,
    headerTitle: 'Neon Geceler ✦',
    headerSubtitle: 'KARANLIKTA PARLAYAN FİKİRLER',
    headerBadge: 'Gece Işıltısı 🔮',
  );

  // -------------------------------------------------------------
  // 6. PASTEL RÜYA (Orijinal)
  // -------------------------------------------------------------
  static final ThemeConfig pastelDream = ThemeConfig(
    type: AppThemeType.pastelDream,
    id: 'pastel_dream',
    name: 'Pastel Rüya',
    emoji: '💜',
    isDark: false,
    previewColors: const [
      Color(0xFFC8B6FF),
      Color(0xFFFFD6E0),
      Color(0xFFFFE5D9),
      Color(0xFFD8F3DC),
    ],
    scaffoldBg: const Color(0xFFFBF9F5),
    backgroundGradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFAF7FC),
        Color(0xFFF7F2FA),
        Color(0xFFF4EEF7),
        Color(0xFFF0E8F5),
      ],
    ),
    textDark: const Color(0xFF383042),
    textMuted: const Color(0xFF8C8296),
    textHint: const Color(0xFFB5ADC0),
    primaryColor: const Color(0xFFC8B6FF),
    accentColor: const Color(0xFF8F7193),
    searchBarBg: const Color(0xFFF2ECF9),
    searchBarBorderColor: Colors.transparent,
    searchBarIconColor: const Color(0xFF8F7193),
    searchBarTextColor: const Color(0xFF383042),
    searchBarHintColor: const Color(0xFFB5ADC0),
    searchBarTrailingIcon: Icons.favorite_border_rounded,
    cardBackground: Colors.white,
    cardBorderColor: const Color(0x60FFFFFF),
    cardShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 15,
        spreadRadius: 2,
        offset: const Offset(0, 5),
      ),
    ],
    notePaperColors: const [
      Color(0xFFF5EEFD), // Soft Lilac
      Color(0xFFFFEEF2), // Soft Rose Pink
      Color(0xFFE8F5E9), // Soft Mint
      Color(0xFFE3F2FD), // Soft Baby Blue
      Color(0xFFFFF8E1), // Soft Butter Yellow
      Color(0xFFFFEFE9), // Soft Peach
    ],
    navBarBg: const Color(0xC0FFFFFF),
    navBarBorderColor: Colors.white,
    activeNavBox: const Color(0xFFDDD2F7),
    activeNavBorder: const Color(0xFFC8B6FF),
    activeNavIcon: const Color(0xFF8F7193),
    inactiveNavIcon: const Color(0xFF8C8296),
    fabGradient: const [Color(0xFFC8B6FF), Color(0xFFA78BFA)],
    fabShadowColor: const Color(0xFFC8B6FF),
    fabIconColor: Colors.white,
    headerTitle: 'Bugün harika bir gün ♡',
    headerSubtitle: 'KÜÇÜK NOTLAR, BÜYÜK MUTLULUKLAR',
    headerBadge: 'Tatlı Notlar ✨',
  );

  static final List<ThemeConfig> allThemes = [
    sunsetGlow,
    cosmicDream,
    botanical,
    sakura,
    neonGlass,
    pastelDream,
  ];

  static ThemeConfig fromType(AppThemeType type) {
    switch (type) {
      case AppThemeType.sunsetGlow:
        return sunsetGlow;
      case AppThemeType.cosmicDream:
        return cosmicDream;
      case AppThemeType.botanical:
        return botanical;
      case AppThemeType.sakura:
        return sakura;
      case AppThemeType.neonGlass:
        return neonGlass;
      case AppThemeType.pastelDream:
        return pastelDream;
    }
  }

  static ThemeConfig fromId(String id) {
    return allThemes.firstWhere((t) => t.id == id, orElse: () => sunsetGlow);
  }
}
