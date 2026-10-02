import 'package:flutter/material.dart';

/// Cover design preset for custom notebooks/journals
class NotebookCoverDesign {
  final String id;
  final String name;
  final Color coverColor;
  final Color spineColor;
  final IconData icon;

  const NotebookCoverDesign({
    required this.id,
    required this.name,
    required this.coverColor,
    required this.spineColor,
    required this.icon,
  });

  /// Preset design options available when adding a new notebook
  static const List<NotebookCoverDesign> presets = [
    NotebookCoverDesign(
      id: 'pink_heart',
      name: 'Pembe Kalp',
      coverColor: Color(0xFFFFD6E0),
      spineColor: Color(0xFFFF9AA2),
      icon: Icons.favorite_rounded,
    ),
    NotebookCoverDesign(
      id: 'lavender_stars',
      name: 'Lavanta Yıldız',
      coverColor: Color(0xFFE2D4F0),
      spineColor: Color(0xFFC8B6FF),
      icon: Icons.auto_awesome_rounded,
    ),
    NotebookCoverDesign(
      id: 'mint_flower',
      name: 'Nane Çiçek',
      coverColor: Color(0xFFD8F3DC),
      spineColor: Color(0xFF95D5B2),
      icon: Icons.filter_vintage_rounded,
    ),
    NotebookCoverDesign(
      id: 'sky_cloud',
      name: 'Gökyüzü Bulut',
      coverColor: Color(0xFFD0E8FF),
      spineColor: Color(0xFFA0C4FF),
      icon: Icons.wb_twilight_rounded,
    ),
    NotebookCoverDesign(
      id: 'peach_sparkle',
      name: 'Şeftali Işıltı',
      coverColor: Color(0xFFFFE5D9),
      spineColor: Color(0xFFFFCAD4),
      icon: Icons.celebration_rounded,
    ),
    NotebookCoverDesign(
      id: 'butter_paw',
      name: 'Krem Pati',
      coverColor: Color(0xFFFFF1C5),
      spineColor: Color(0xFFFFD166),
      icon: Icons.pets_rounded,
    ),
  ];
}

/// Notebook Model representing a journal / agenda
class NotebookModel {
  final String id;
  final String title;
  final Color coverColor;
  final Color spineColor;
  final IconData icon;
  final DateTime createdAt;
  final int pageCount;

  const NotebookModel({
    required this.id,
    required this.title,
    required this.coverColor,
    required this.spineColor,
    required this.icon,
    required this.createdAt,
    this.pageCount = 0,
  });

  NotebookModel copyWith({
    String? id,
    String? title,
    Color? coverColor,
    Color? spineColor,
    IconData? icon,
    DateTime? createdAt,
    int? pageCount,
  }) {
    return NotebookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      coverColor: coverColor ?? this.coverColor,
      spineColor: spineColor ?? this.spineColor,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      pageCount: pageCount ?? this.pageCount,
    );
  }

  /// Initial mock notebooks matching the sketch illustrations
  static List<NotebookModel> get mockNotebooks => [
    NotebookModel(
      id: 'nb_1',
      title: 'Happy Notes ♡',
      coverColor: const Color(0xFFFFD6E0),
      spineColor: const Color(0xFFFF9AA2),
      icon: Icons.favorite_rounded,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      pageCount: 14,
    ),
    NotebookModel(
      id: 'nb_2',
      title: 'Gizli Günlüğüm',
      coverColor: const Color(0xFFE2D4F0),
      spineColor: const Color(0xFFC8B6FF),
      icon: Icons.auto_awesome_rounded,
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      pageCount: 28,
    ),
    NotebookModel(
      id: 'nb_3',
      title: ' Ajandam',
      coverColor: const Color(0xFFD8F3DC),
      spineColor: const Color(0xFF95D5B2),
      icon: Icons.filter_vintage_rounded,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      pageCount: 42,
    ),
    NotebookModel(
      id: 'nb_4',
      title: 'Tatlı Tarifler',
      coverColor: const Color(0xFFFFF1C5),
      spineColor: const Color(0xFFFFD166),
      icon: Icons.cookie_rounded,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      pageCount: 9,
    ),
  ];
}
