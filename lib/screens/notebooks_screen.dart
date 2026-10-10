import 'package:flutter/material.dart';
import '../models/notebook_model.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';
import '../widgets/notebook_cover_widget.dart';
import '../widgets/themed_background.dart';
import 'add_notebook_screen.dart';
import 'notebook_viewer_screen.dart';

/// Screen 2: Notebooks (Günlük/Ajanda) matching Sketch 2:
/// - Grid of notebooks with book spines, centered icons, and titles
/// - FAB '+' button opening "Not defteri Ekle" screen
class NotebooksScreen extends StatelessWidget {
  final List<NotebookModel> notebooks;
  final Function(NotebookModel) onAddNotebook;
  final Function(String) onDeleteNotebook;

  const NotebooksScreen({
    super.key,
    required this.notebooks,
    required this.onAddNotebook,
    required this.onDeleteNotebook,
  });

  void _openAddNotebook(BuildContext context) async {
    final result = await Navigator.of(context).push<NotebookModel>(
      MaterialPageRoute(builder: (context) => const AddNotebookScreen()),
    );

    if (result != null) {
      onAddNotebook(result);
    }
  }

  void _showNotebookDetails(BuildContext context, NotebookModel nb) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final sheetConfig = AppTheme.current;
        return Container(
          decoration: BoxDecoration(
            color: sheetConfig.isDark ? const Color(0xFF1E1733) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pill handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),

              // Mini cover preview
              SizedBox(
                width: 100,
                height: 135,
                child: NotebookCoverWidget(notebook: nb, compact: true),
              ),
              const SizedBox(height: 14),

              Text(
                nb.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: sheetConfig.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${nb.pageCount} sayfa yazıldı • ${nb.createdAt.day}.${nb.createdAt.month}.${nb.createdAt.year}',
                style: TextStyle(fontSize: 13, color: sheetConfig.textMuted),
              ),
              const SizedBox(height: 20),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.red.shade200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onDeleteNotebook(nb.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${nb.title} silindi'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Colors.red.shade400,
                      ),
                      label: Text(
                        'Defteri Sil',
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: sheetConfig.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotebookViewerScreen(notebook: nb),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.menu_book_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Sayfaları Oku',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
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
          child: Stack(
            children: [
              SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: config.activeNavBox,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.auto_stories_rounded,
                              color: config.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Günlükler & Ajanda',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: config.headerTextColor,
                                ),
                              ),
                              Text(
                                'Özel kapaklı not defterlerin',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: config.headerMutedColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Notebooks 2-column Grid matching Sketch 2
                    Expanded(
                      child: notebooks.isEmpty
                          ? _buildEmptyState(context)
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                16,
                                20,
                                100,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.72,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 18,
                                  ),
                              itemCount: notebooks.length,
                              itemBuilder: (context, index) {
                                final notebook = notebooks[index];
                                return NotebookCoverWidget(
                                  notebook: notebook,
                                  onTap: () =>
                                      _showNotebookDetails(context, notebook),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),

              // FAB: Soft '+' button to open "Not defteri Ekle"
              Positioned(
                right: 24,
                bottom: 100,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: config.fabGradient,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: config.fabShadowColor.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _openAddNotebook(context),
                      child: Icon(
                        Icons.add_rounded,
                        size: 30,
                        color: config.fabIconColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final config = AppTheme.current;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: config.primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.book_outlined,
              size: 44,
              color: config.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz bir not defteri yok ♡',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: config.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '+ butonuna basarak ilk kapaklı günlüğünü oluştur',
            style: TextStyle(fontSize: 13, color: config.textMuted),
          ),
        ],
      ),
    );
  }
}
