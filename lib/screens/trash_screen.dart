import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';
import '../widgets/themed_background.dart';

/// Screen for displaying deleted notes in the Trash Bin (Çöp Kutusu)
/// Allows restoring notes back to the main list or permanently deleting them.
class TrashScreen extends StatefulWidget {
  final List<NoteModel> deletedNotes;
  final Function(NoteModel) onRestoreNote;
  final Function(String) onPermanentDelete;
  final VoidCallback onClearAll;

  const TrashScreen({
    super.key,
    required this.deletedNotes,
    required this.onRestoreNote,
    required this.onPermanentDelete,
    required this.onClearAll,
  });

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  void _confirmClearAll(BuildContext context, ThemeConfig config) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: config.isDark ? const Color(0xFF1E1733) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.delete_sweep_rounded, color: Color(0xFFE55375), size: 24),
            const SizedBox(width: 8),
            Text(
              'Çöpü Boşalt?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: config.textDark,
              ),
            ),
          ],
        ),
        content: Text(
          'Çöp kutusundaki tüm notlar kalıcı olarak silinecek. Bu işlem geri alınamaz.',
          style: TextStyle(
            color: config.textMuted,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Vazgeç',
              style: TextStyle(color: config.textMuted, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE55375),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onClearAll();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Çöp kutusu tamamen boşaltıldı'),
                  backgroundColor: AppTheme.textDark,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
                ),
              );
            },
            child: const Text(
              'Hepsini Sil',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSingle(BuildContext context, NoteModel note, ThemeConfig config) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: config.isDark ? const Color(0xFF1E1733) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.delete_forever_rounded, color: Color(0xFFE55375), size: 24),
            const SizedBox(width: 8),
            Text(
              'Kalıcı Olarak Sil?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: config.textDark,
              ),
            ),
          ],
        ),
        content: Text(
          '"${note.title}" notu kalıcı olarak silinecektir.',
          style: TextStyle(
            color: config.textMuted,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Vazgeç',
              style: TextStyle(color: config.textMuted, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE55375),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onPermanentDelete(note.id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${note.title}" kalıcı olarak silindi'),
                  backgroundColor: AppTheme.textDark,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
                ),
              );
            },
            child: const Text(
              'Kalıcı Sil',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeType>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, themeType, _) {
        final config = ThemeConfig.fromType(themeType);
        final notes = widget.deletedNotes;

        return Scaffold(
          backgroundColor: config.scaffoldBg,
          body: ThemedBackground(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // App Bar / Top Navigation
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    child: Row(
                      children: [
                        // Back Button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: config.isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.white.withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: config.cardBorderColor.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18,
                                color: config.headerTextColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Title with cute icon badge
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDECEF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.auto_delete_outlined,
                            size: 20,
                            color: Color(0xFFC04B67),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Çöp Kutusu',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: config.headerTextColor,
                                ),
                              ),
                              Text(
                                notes.isEmpty
                                    ? 'Silinen not yok'
                                    : '${notes.length} silinen not',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: config.headerMutedColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Empty Trash Button
                        if (notes.isNotEmpty)
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFC04B67),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              backgroundColor: const Color(0xFFFDECEF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () => _confirmClearAll(context, config),
                            icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                            label: const Text(
                              'Boşalt',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Divider
                  Divider(
                    color: config.cardBorderColor.withValues(alpha: 0.3),
                    height: 1,
                  ),

                  // List of Deleted Notes or Empty State
                  Expanded(
                    child: notes.isEmpty
                        ? _buildEmptyState(config)
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(18, 16, 18, 40),
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];
                              return _buildDeletedNoteCard(note, config);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeConfig config) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFFDECEF),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC04B67).withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 44,
                  color: Color(0xFFC04B67),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Çöp kutusu boş ♡',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: config.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sildiğin notlar burada güvenle saklanır. İstediğin zaman tek dokunuşla geri yükleyebilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: config.textMuted,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeletedNoteCard(NoteModel note, ThemeConfig config) {
    final noteBg = config.isDark ? const Color(0xFF1E1733) : note.color;
    final formattedDate =
        '${note.date.day.toString().padLeft(2, '0')}.${note.date.month.toString().padLeft(2, '0')}.${note.date.year} ${note.date.hour.toString().padLeft(2, '0')}:${note.date.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: noteBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: config.cardBorderColor.withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Title & Date
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title.isEmpty ? 'Başlıksız Not' : note.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: config.textDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: config.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Content preview
            if (note.content.isNotEmpty)
              Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: config.textDark.withValues(alpha: 0.8),
                  height: 1.35,
                ),
              ),

            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Action Buttons: Geri Yükle & Kalıcı Sil
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Kalıcı Sil Button
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFC04B67),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                  onPressed: () => _confirmDeleteSingle(context, note, config),
                  icon: const Icon(Icons.delete_forever_rounded, size: 17),
                  label: const Text(
                    'Kalıcı Sil',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),

                // Geri Yükle Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: config.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    widget.onRestoreNote(note);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text('"${note.title}" geri yüklendi ♡'),
                          ],
                        ),
                        backgroundColor: config.primaryColor,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
                      ),
                    );
                  },
                  icon: const Icon(Icons.restore_from_trash_rounded, size: 16),
                  label: const Text(
                    'Geri Yükle',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
