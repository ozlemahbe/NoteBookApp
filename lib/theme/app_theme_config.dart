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

  /// The primary header and title text color for outside cards
  Color get headerTextColor => isDark ? const Color(0xFFF8F4FF) : textDark;

  /// The secondary text color for outside cards
  Color get headerMutedColor => isDark ? const Color(0xFFC7B8E0) : textMuted;

  /// Background color for settings cards and info panels
  Color get settingsCardBg => isDark ? const Color(0x351F1836) : Colors.white.withValues(alpha: 0.88);

  /// Border color for settings cards and info panels
  Color get settingsCardBorder => isDark ? cardBorderColor : cardBorderColor.withValues(alpha: 0.5);

  /// Friendly theme subtitle for theme picker
  String get subtitle => headerBadge ?? headerSubtitle ?? name;

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
        Color(0xFFFFB5C5), // Warm pink top
        Color(0xFFFFC4A8), // Peach coral
        Color(0xFFFFD4A8), // Soft apricot
        Color(0xFFFFE0C0), // Warm vanilla peach
        Color(0xFFFFEDD8), // Soft cream bottom
      ],
      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
    ),
    textDark: const Color(0xFF4A282E),
    textMuted: const Color(0xFF8E6168),
    textHint: const Color(0xFFBFA0A5),
    primaryColor: const Color(0xFFE8607A),
    accentColor: const Color(0xFFD44D68),
    searchBarBg: const Color(0xFFFFF7F2),
    searchBarBorderColor: Colors.white,
    searchBarIconColor: const Color(0xFFD06878),
    searchBarTextColor: const Color(0xFF4A282E),
    searchBarHintColor: const Color(0xFFBFA0A5),
    searchBarTrailingIcon: Icons.wb_sunny_outlined,
    cardBackground: Colors.white,
    cardBorderColor: const Color(0x60FFFFFF),
    cardShadow: [
      BoxShadow(
        color: const Color(0xFFD66D57).withValues(alpha: 0.10),
        blurRadius: 14,
        spreadRadius: 1,
        offset: const Offset(0, 5),
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
    fabGradient: const [Color(0xFFE8607A), Color(0xFFFF8E72)],
    fabShadowColor: const Color(0xFFE8607A),
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
      Color(0xFF22113B),
      Color(0xFF4C278C),
      Color(0xFF9E5EFF),
      Color(0xFFE2C4FF),
    ],
    scaffoldBg: const Color(0xFF22113B),
    backgroundGradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF22113B),
        Color(0xFF2C1552),
        Color(0xFF3B1E6D),
        Color(0xFF4C278C),
        Color(0xFF6337AB),
      ],
    ),
    textDark: const Color(0xFFFFFFFF), // Text should be light in dark mode!
    textMuted: const Color(0xFFD3C2F0),
    textHint: const Color(0xFF9981C5),
    primaryColor: const Color(0xFFC79AFF), // brighter primary for visibility
    accentColor: const Color(0xFFE2C4FF),
    searchBarBg: const Color(0x663B1E6D),
    searchBarBorderColor: const Color(0x809E5EFF),
    searchBarIconColor: const Color(0xFFE2C4FF),
    searchBarTextColor: Colors.white,
    searchBarHintColor: const Color(0xFFD3C2F0),
    searchBarTrailingIcon: Icons.auto_awesome,
    cardBackground: const Color(0xFF3A2168), // Lighter dark cards
    cardBorderColor: const Color(0x669E5EFF),
    cardShadow: [
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: 0.3),
        blurRadius: 18,
        spreadRadius: 2,
        offset: const Offset(0, 8),
      ),
    ],
    notePaperColors: const [
      Color(0xFF3E266A), // Deep Nebula
      Color(0xFF4C2B7A), // Galaxy Violet
      Color(0xFF331E5B), // Void Indigo
      Color(0xFF5A378D), // Stardust Purple
      Color(0xFF2D1B4D), // Night Sky
      Color(0xFF512B85), // Dark Orchid
    ],
    navBarBg: const Color(0xEE2C1552),
    navBarBorderColor: const Color(0x669E5EFF),
    activeNavBox: const Color(0xFF6337AB),
    activeNavBorder: const Color(0xFFC79AFF),
    activeNavIcon: Colors.white,
    inactiveNavIcon: const Color(0xFF8F76B0),
    fabGradient: const [Color(0xFF8B47E6), Color(0xFFC493FF)],
    fabShadowColor: const Color(0xFF8B47E6),
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
    scaffoldBg: const Color(0xFF130C21),
    backgroundGradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF130C21),
        Color(0xFF1A112C),
        Color(0xFF211538),
        Color(0xFF281944),
      ],
    ),
    textDark: const Color(0xFFFFFFFF), // Fixed text color!
    textMuted: const Color(0xFFC084FC),
    textHint: const Color(0xFFA69EB8),
    primaryColor: const Color(0xFFA855F7),
    accentColor: const Color(0xFFEC4899),
    searchBarBg: const Color(0x60281944),
    searchBarBorderColor: const Color(0x80A855F7),
    searchBarIconColor: const Color(0xFFC084FC),
    searchBarTextColor: Colors.white,
    searchBarHintColor: const Color(0xFFA69EB8),
    searchBarTrailingIcon: Icons.auto_awesome,
    cardBackground: const Color(0xFF2C1C4A), // Solid dark neon card
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
      Color(0xFF45226D), // Neon purple
      Color(0xFF6B1B48), // Neon magenta
      Color(0xFF0F5A4F), // Neon cyan
      Color(0xFF1B4072), // Neon deep blue
      Color(0xFF6B5216), // Neon amber
      Color(0xFF1A1A24), // Dark grey
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
    scaffoldBg: const Color(0xFFFCFAFC),
    backgroundGradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFDFBFE),
        Color(0xFFFAF7FC),
        Color(0xFFF6F3F9),
        Color(0xFFF2EDF6),
      ],
    ),
    textDark: const Color(0xFF2D2438), // Deeper for better contrast
    textMuted: const Color(0xFF8F849E),
    textHint: const Color(0xFFB8AECC),
    primaryColor: const Color(0xFFB185F6), // More vibrant pastel purple
    accentColor: const Color(0xFFFFAFCC), // Soft warm pink accent
    searchBarBg: const Color(0xFFF0E6FA),
    searchBarBorderColor: const Color(0x33B185F6),
    searchBarIconColor: const Color(0xFFB185F6),
    searchBarTextColor: const Color(0xFF2D2438),
    searchBarHintColor: const Color(0xFFB8AECC),
    searchBarTrailingIcon: Icons.favorite_border_rounded,
    cardBackground: Colors.white,
    cardBorderColor: const Color(0x60FFFFFF),
    cardShadow: [
      BoxShadow(
        color: const Color(0xFFB185F6).withValues(alpha: 0.12),
        blurRadius: 18,
        spreadRadius: 2,
        offset: const Offset(0, 6),
      ),
    ],
    notePaperColors: const [
      Color(0xFFF2E6FF), // Soft Lilac
      Color(0xFFFFE6EB), // Soft Rose Pink
      Color(0xFFE2F4E6), // Soft Mint
      Color(0xFFDDF0FF), // Soft Baby Blue
      Color(0xFFFFF4D4), // Soft Butter Yellow
      Color(0xFFFFE5DB), // Soft Peach
    ],
    navBarBg: const Color(0xEEFFFFFF), // More solid for better blur
    navBarBorderColor: const Color(0x40B185F6),
    activeNavBox: const Color(0xFFF0E6FA),
    activeNavBorder: const Color(0xFFB185F6),
    activeNavIcon: const Color(0xFFB185F6),
    inactiveNavIcon: const Color(0xFFB8AECC),
    fabGradient: const [Color(0xFFB185F6), Color(0xFFFFAFCC)],
    fabShadowColor: const Color(0xFFB185F6).withValues(alpha: 0.4),
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
