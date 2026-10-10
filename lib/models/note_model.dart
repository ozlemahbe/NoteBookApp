import 'package:flutter/material.dart';

/// Note Model representing a classic sticky/paper note.
class NoteModel {
  final String id;
  final String title;
  final String content;
  final String? drawingData;
  final IconData? customIcon;
  final DateTime date;
  final int colorIndex;
  final bool isPinned;

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.drawingData,
    this.customIcon,
    required this.date,
    this.colorIndex = 0,
    this.isPinned = false,
  });

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    String? drawingData,
    IconData? customIcon,
    DateTime? date,
    int? colorIndex,
    bool? isPinned,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      drawingData: drawingData ?? this.drawingData,
      customIcon: customIcon ?? this.customIcon,
      date: date ?? this.date,
      colorIndex: colorIndex ?? this.colorIndex,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  /// Initial mock notes for demonstration matching the user's wireframes
  static List<NoteModel> get mockNotes => [
    NoteModel(
      id: '1',
      title: 'Alışveriş Listesi 🛒',
      content:
          '• Badem sütü\n• Çilek ve muz\n• Lavanta kokulu mum\n• Pembe defter kalemi',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      colorIndex: 0,
      isPinned: true,
    ),
    NoteModel(
      id: '2',
      title: 'Tatlı Günlük Hedefler ✨',
      content:
          '1. Sabah 20 dakika yoga\n2. Yeşil çay içmeyi unutma\n3. Kitap oku (en az 25 sayfa)',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      colorIndex: 1,
    ),
    NoteModel(
      id: '3',
      title: 'Okunacak Kitaplar 📚',
      content:
          'Küçük Prens\nKürk Mantolu Madonna\nBilinmeyen Bir Kadının Mektubu',
      date: DateTime.now().subtract(const Duration(days: 1)),
      colorIndex: 2,
    ),
    NoteModel(
      id: '4',
      title: 'Yaz Tatili Planı 🌊',
      content:
          'Kaş veya Datça sahillerinde sakin ve huzurlu bir hafta sonu kampı...',
      date: DateTime.now().subtract(const Duration(days: 2)),
      colorIndex: 3,
    ),
    NoteModel(
      id: '5',
      title: 'Yeni Tarif Denemesi 🍰',
      content:
          'Böğürtlenli ve vanilyalı panna cotta tarifi. Kremayı kısık ateşte kaynatıp jelatinle karıştır.',
      date: DateTime.now().subtract(const Duration(days: 3)),
      colorIndex: 4,
    ),
    NoteModel(
      id: '6',
      title: 'Haftalık İlham Sözü 🌸',
      content: 'Küçük adımlar, büyük ve güzel başlangıçların ilk melodisidir.',
      date: DateTime.now().subtract(const Duration(days: 4)),
      colorIndex: 5,
    ),
  ];
}
