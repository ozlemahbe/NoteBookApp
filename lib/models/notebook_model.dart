import 'package:flutter/material.dart';

/// Spine decoration pattern types for notebook covers
enum SpinePattern {
  hearts,      // Small heart shapes (pink)
  lines,       // Horizontal lines (lavender)
  diagonal,    // Diagonal stripes (mint)
  grid,        // Grid/checker (yellow)
  dots,        // Polka dots (peach)
  stars,       // Star shapes (blue)
  waves,       // Wave pattern (coral)
  zigzag,      // Zigzag (teal)
}

/// Cover design preset for custom notebooks/journals
class NotebookCoverDesign {
  final String id;
  final String name;
  final Color coverColor;      // Main cover background
  final Color accentColor;     // Organic blob shapes color
  final Color spineColor;      // Left spine strip color
  final SpinePattern spinePattern;
  final IconData icon;
  final Color iconColor;

  const NotebookCoverDesign({
    required this.id,
    required this.name,
    required this.coverColor,
    required this.accentColor,
    required this.spineColor,
    required this.spinePattern,
    required this.icon,
    required this.iconColor,
  });

  /// Preset design options available when adding a new notebook
  static const List<NotebookCoverDesign> presets = [
    NotebookCoverDesign(
      id: 'pink_heart',
      name: 'Pembe Kalp',
      coverColor: Color(0xFFFFCDD8),
      accentColor: Color(0xFFFFB0C0),
      spineColor: Color(0xFFFF7088),
      spinePattern: SpinePattern.hearts,
      icon: Icons.favorite_rounded,
      iconColor: Color(0xFFE85070),
    ),
    NotebookCoverDesign(
      id: 'lavender_stars',
      name: 'Lavanta Yıldız',
      coverColor: Color(0xFFD8CCF0),
      accentColor: Color(0xFFC4B0E8),
      spineColor: Color(0xFFA088D0),
      spinePattern: SpinePattern.lines,
      icon: Icons.auto_awesome_rounded,
      iconColor: Color(0xFF8060B8),
    ),
    NotebookCoverDesign(
      id: 'mint_flower',
      name: 'Nane Çiçek',
      coverColor: Color(0xFFC8E8D0),
      accentColor: Color(0xFFA0D8B0),
      spineColor: Color(0xFF68B880),
      spinePattern: SpinePattern.diagonal,
      icon: Icons.local_florist_rounded,
      iconColor: Color(0xFF408860),
    ),
    NotebookCoverDesign(
      id: 'sunny_cookie',
      name: 'Güneşli Kurabiye',
      coverColor: Color(0xFFFFE8B8),
      accentColor: Color(0xFFFFD888),
      spineColor: Color(0xFFFFB840),
      spinePattern: SpinePattern.grid,
      icon: Icons.cookie_rounded,
      iconColor: Color(0xFFD08830),
    ),
    NotebookCoverDesign(
      id: 'peach_sparkle',
      name: 'Şeftali Işıltı',
      coverColor: Color(0xFFFFDDD0),
      accentColor: Color(0xFFFFCCB8),
      spineColor: Color(0xFFFF9878),
      spinePattern: SpinePattern.dots,
      icon: Icons.celebration_rounded,
      iconColor: Color(0xFFD87050),
    ),
    NotebookCoverDesign(
      id: 'sky_cloud',
      name: 'Gökyüzü Bulut',
      coverColor: Color(0xFFC8DFFF),
      accentColor: Color(0xFFABCAFF),
      spineColor: Color(0xFF78A8E8),
      spinePattern: SpinePattern.stars,
      icon: Icons.cloud_rounded,
      iconColor: Color(0xFF5080C8),
    ),
    NotebookCoverDesign(
      id: 'coral_dream',
      name: 'Mercan Rüya',
      coverColor: Color(0xFFFFB8B0),
      accentColor: Color(0xFFFF9890),
      spineColor: Color(0xFFE86860),
      spinePattern: SpinePattern.waves,
      icon: Icons.brightness_5_rounded,
      iconColor: Color(0xFFC04848),
    ),
    NotebookCoverDesign(
      id: 'teal_zen',
      name: 'Turkuaz Zen',
      coverColor: Color(0xFFB8E8E0),
      accentColor: Color(0xFF90D8D0),
      spineColor: Color(0xFF50B0A8),
      spinePattern: SpinePattern.zigzag,
      icon: Icons.spa_rounded,
      iconColor: Color(0xFF308880),
    ),
    NotebookCoverDesign(
      id: 'rose_diary',
      name: 'Gül Günlük',
      coverColor: Color(0xFFF0C8D8),
      accentColor: Color(0xFFE8A8C0),
      spineColor: Color(0xFFD080A0),
      spinePattern: SpinePattern.hearts,
      icon: Icons.menu_book_rounded,
      iconColor: Color(0xFFB06080),
    ),
    NotebookCoverDesign(
      id: 'lemon_fresh',
      name: 'Limon Taze',
      coverColor: Color(0xFFE8F0B8),
      accentColor: Color(0xFFD8E898),
      spineColor: Color(0xFFA8C860),
      spinePattern: SpinePattern.diagonal,
      icon: Icons.eco_rounded,
      iconColor: Color(0xFF78A040),
    ),
  ];
}

/// Notebook Model representing a journal / agenda
class NotebookModel {
  final String id;
  final String title;
  final Color coverColor;
  final Color accentColor;
  final Color spineColor;
  final SpinePattern spinePattern;
  final IconData icon;
  final Color iconColor;
  final DateTime createdAt;
  final int pageCount;

  const NotebookModel({
    required this.id,
    required this.title,
    required this.coverColor,
    required this.accentColor,
    required this.spineColor,
    required this.spinePattern,
    required this.icon,
    required this.iconColor,
    required this.createdAt,
    this.pageCount = 0,
  });

  NotebookModel copyWith({
    String? id,
    String? title,
    Color? coverColor,
    Color? accentColor,
    Color? spineColor,
    SpinePattern? spinePattern,
    IconData? icon,
    Color? iconColor,
    DateTime? createdAt,
    int? pageCount,
  }) {
    return NotebookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      coverColor: coverColor ?? this.coverColor,
      accentColor: accentColor ?? this.accentColor,
      spineColor: spineColor ?? this.spineColor,
      spinePattern: spinePattern ?? this.spinePattern,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      createdAt: createdAt ?? this.createdAt,
      pageCount: pageCount ?? this.pageCount,
    );
  }

  /// Initial mock notebooks matching the screenshot illustrations
  static List<NotebookModel> get mockNotebooks => [
    NotebookModel(
      id: 'nb_1',
      title: 'Happy Notes ♡',
      coverColor: const Color(0xFFFFCDD8),
      accentColor: const Color(0xFFFFB0C0),
      spineColor: const Color(0xFFFF7088),
      spinePattern: SpinePattern.hearts,
      icon: Icons.favorite_rounded,
      iconColor: const Color(0xFFE85070),
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      pageCount: 14,
    ),
    NotebookModel(
      id: 'nb_2',
      title: 'Gizli Günlüğüm',
      coverColor: const Color(0xFFD8CCF0),
      accentColor: const Color(0xFFC4B0E8),
      spineColor: const Color(0xFFA088D0),
      spinePattern: SpinePattern.lines,
      icon: Icons.auto_awesome_rounded,
      iconColor: const Color(0xFF8060B8),
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      pageCount: 28,
    ),
    NotebookModel(
      id: 'nb_3',
      title: 'Ajandam',
      coverColor: const Color(0xFFC8E8D0),
      accentColor: const Color(0xFFA0D8B0),
      spineColor: const Color(0xFF68B880),
      spinePattern: SpinePattern.diagonal,
      icon: Icons.local_florist_rounded,
      iconColor: const Color(0xFF408860),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      pageCount: 42,
    ),
    NotebookModel(
      id: 'nb_4',
      title: 'Tatlı Tarifler',
      coverColor: const Color(0xFFFFE8B8),
      accentColor: const Color(0xFFFFD888),
      spineColor: const Color(0xFFFFB840),
      spinePattern: SpinePattern.grid,
      icon: Icons.cookie_rounded,
      iconColor: const Color(0xFFD08830),
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      pageCount: 9,
    ),
  ];
}
