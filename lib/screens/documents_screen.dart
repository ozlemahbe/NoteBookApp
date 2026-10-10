import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';
import '../widgets/themed_background.dart';
import '../models/document_model.dart';
import 'drawing_editor_screen.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final List<DocumentModel> _documents = [
    DocumentModel(
      id: 'mock_1',
      title: 'Demo Çizim 1',
      isPdf: false,
      createdAt: DateTime.now(),
    ),
    DocumentModel(
      id: 'mock_2',
      title: 'Toplantı Notları (PDF)',
      isPdf: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<void> _openDrawingEditor(BuildContext context, {bool isPdfMode = false, DocumentModel? existingDoc}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DrawingEditorScreen(
          isPdfMode: isPdfMode,
          initialStrokes: existingDoc?.strokes.cast<Stroke>(),
          initialTextBoxes: existingDoc?.textBoxes?.cast<TextBoxInfo>(),
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final strokes = result['strokes'] as List<Stroke>;
      final textBoxes = result['textBoxes'] as List<TextBoxInfo>;

      setState(() {
        if (existingDoc != null) {
          final index = _documents.indexWhere((d) => d.id == existingDoc.id);
          if (index != -1) {
            _documents[index] = DocumentModel(
              id: existingDoc.id,
              title: existingDoc.title,
              isPdf: existingDoc.isPdf,
              createdAt: existingDoc.createdAt,
              strokes: strokes,
              textBoxes: textBoxes,
            );
          }
        } else {
          _documents.insert(0, DocumentModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: isPdfMode ? 'Yeni PDF Belgesi' : 'Yeni Çizim',
            isPdf: isPdfMode,
            createdAt: DateTime.now(),
            strokes: strokes,
            textBoxes: textBoxes,
          ));
        }
      });
    }
  }

  void _showRenameDialog(BuildContext context, DocumentModel doc) {
    final TextEditingController ctrl = TextEditingController(text: doc.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeniden Adlandır'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Belge adı',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final index = _documents.indexWhere((d) => d.id == doc.id);
                if (index != -1) {
                  _documents[index] = DocumentModel(
                    id: doc.id,
                    title: ctrl.text.trim().isEmpty ? 'İsimsiz' : ctrl.text.trim(),
                    isPdf: doc.isPdf,
                    createdAt: doc.createdAt,
                    strokes: doc.strokes,
                    textBoxes: doc.textBoxes,
                  );
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showImportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final config = AppTheme.current;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: config.isDark ? const Color(0xFF1E1733) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.red),
                ),
                title: Text('PDF İçe Aktar', style: TextStyle(color: config.textDark, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _openDrawingEditor(context, isPdfMode: true);
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image_rounded, color: Colors.blue),
                ),
                title: Text('Görsel İçe Aktar', style: TextStyle(color: config.textDark, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _openDrawingEditor(context, isPdfMode: true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeType>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, themeType, _) {
        final config = ThemeConfig.fromType(themeType);

        return ThemedBackground(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Custom AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: config.activeNavBox,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.folder_rounded, color: config.primaryColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Belgeler ve Çizim',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: config.headerTextColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search_rounded),
                        color: config.headerTextColor,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.attach_file_rounded),
                        color: config.headerTextColor,
                        onPressed: () => _showImportOptions(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_rounded),
                        color: config.primaryColor,
                        onPressed: () => _openDrawingEditor(context, isPdfMode: false),
                      ),
                    ],
                  ),
                ),

                // Content List
                Expanded(
                  child: _documents.isEmpty
                      ? Center(
                          child: Text(
                            'Henüz belge yok.\nKalem veya ataç ikonuna tıklayarak oluşturun.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: config.textMuted),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          itemCount: _documents.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final doc = _documents[index];
                            final isPdf = doc.isPdf;
                            
                            final strokeCount = doc.strokes.length;
                            final textCount = (doc.textBoxes?.length ?? 0);
                            
                            return GestureDetector(
                              onTap: () => _openDrawingEditor(context, isPdfMode: isPdf, existingDoc: doc),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: config.isDark ? const Color(0xFF22193A) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: config.cardShadow,
                                ),
                                child: Row(
                                  children: [
                                    // Thumbnail / Icon
                                    Container(
                                      width: 60,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: isPdf ? Colors.red.withValues(alpha: 0.1) : config.primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          isPdf ? Icons.picture_as_pdf_rounded : Icons.brush_rounded,
                                          size: 32,
                                          color: isPdf ? Colors.red : config.primaryColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    
                                    // Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doc.title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: config.textDark,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time_rounded, size: 12, color: config.textMuted),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Bugün', // In real app: format doc.createdAt
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: config.textMuted,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Icon(Icons.layers_rounded, size: 12, color: config.textMuted),
                                              const SizedBox(width: 4),
                                              Text(
                                                strokeCount > 0 || textCount > 0 
                                                  ? '$strokeCount Çizim, $textCount Metin' 
                                                  : 'Boş',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: config.textMuted,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Action Menu
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.more_vert_rounded, color: config.textMuted),
                                      color: config.isDark ? const Color(0xFF2A2345) : Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      onSelected: (value) {
                                        if (value == 'rename') {
                                          _showRenameDialog(context, doc);
                                        } else if (value == 'delete') {
                                          setState(() {
                                            _documents.removeAt(index);
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Belge silindi')),
                                          );
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'rename',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit_rounded, size: 20, color: config.textDark),
                                              const SizedBox(width: 12),
                                              Text('Yeniden Adlandır', style: TextStyle(color: config.textDark)),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              const Icon(Icons.delete_rounded, size: 20, color: Colors.red),
                                              const SizedBox(width: 12),
                                              const Text('Sil', style: TextStyle(color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
