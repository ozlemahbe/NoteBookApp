import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';
import '../widgets/drawing_canvas.dart';

/// Floating note card with theme-specific aesthetics:
/// - Antigravity soft box shadow or neon glow
/// - Theme-tailored pastel or frosted background colors
/// - Cute corner illustrations matching the 5 theme mockups
/// - Hero transition to Add/Edit Note screen
/// - Long press menu with "Sil" (Delete) and "Kopyala" (Copy) options
class NoteCard extends StatelessWidget {
  final NoteModel note;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onCopy;

  const NoteCard({
    super.key,
    required this.note,
    this.index = 0,
    required this.onTap,
    required this.onDelete,
    required this.onCopy,
  });

  void _showContextMenu(BuildContext context, TapDownDetails details) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromLTWH(details.globalPosition.dx, details.globalPosition.dy, 0, 0),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppTheme.current.isDark ? const Color(0xFF22173B) : Colors.white,
      items: [
        PopupMenuItem<String>(
          value: 'copy',
          height: 44,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.current.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: AppTheme.current.primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Kopyala',
                style: TextStyle(
                  color: AppTheme.current.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'delete',
          height: 44,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  size: 16,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Sil',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((selected) {
      if (selected == 'delete') {
        onDelete();
      } else if (selected == 'copy') {
        onCopy();
      }
    });
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}';
  }

  Color _resolveCardColor(ThemeConfig config) {
    if (config.notePaperColors.isEmpty) return note.color;
    final colorIndex = index % config.notePaperColors.length;
    return config.notePaperColors[colorIndex];
  }

  Widget _buildThemeCornerIcon(ThemeConfig config) {
    // Return themed corner illustration matching the mockups
    final cardSlot = index % 6;

    switch (config.type) {
      case AppThemeType.sunsetGlow:
        final icons = [
          Icons.favorite_rounded, // Lilac card purple heart
          Icons.wb_sunny_rounded, // Sun
          Icons.eco_rounded, // Sprout
          Icons.beach_access_rounded, // Beach
          Icons.restaurant_menu_rounded, // Cooking
          Icons.favorite_border_rounded, // Heart
        ];
        final colors = [
          const Color(0xFFC084FC),
          const Color(0xFFFB923C),
          const Color(0xFF4ADE80),
          const Color(0xFF38BDF8),
          const Color(0xFFFBBF24),
          const Color(0xFFF43F5E),
        ];
        return Icon(
          icons[cardSlot],
          size: 20,
          color: colors[cardSlot].withValues(alpha: 0.85),
        );

      case AppThemeType.cosmicDream:
        final icons = [
          Icons.nightlight_round,
          Icons.auto_awesome,
          Icons.menu_book_rounded,
          Icons.waves_rounded,
          Icons.cake_rounded,
          Icons.public_rounded,
        ];
        return Icon(
          icons[cardSlot],
          size: 20,
          color: const Color(0xFFD8B4F8).withValues(alpha: 0.85),
        );

      case AppThemeType.botanical:
        final icons = [
          Icons.spa_rounded,
          Icons.wb_sunny_outlined,
          Icons.bookmark_outline_rounded,
          Icons.water_rounded,
          Icons.cookie_outlined,
          Icons.eco_outlined,
        ];
        return Icon(
          icons[cardSlot],
          size: 19,
          color: const Color(0xFF52796F).withValues(alpha: 0.7),
        );

      case AppThemeType.sakura:
        final icons = [
          Icons.filter_vintage_rounded,
          Icons.temple_buddhist_rounded,
          Icons.park_rounded,
          Icons.landscape_rounded,
          Icons.bakery_dining_rounded,
          Icons.favorite_outline_rounded,
        ];
        return Icon(
          icons[cardSlot],
          size: 19,
          color: const Color(0xFFD65A6E).withValues(alpha: 0.75),
        );

      case AppThemeType.neonGlass:
        final icons = [
          Icons.shopping_bag_outlined,
          Icons.wb_sunny_rounded,
          Icons.menu_book_rounded,
          Icons.waves_rounded,
          Icons.restaurant_rounded,
          Icons.favorite_rounded,
        ];
        final colors = [
          const Color(0xFFC084FC),
          const Color(0xFFF472B6),
          const Color(0xFF34D399),
          const Color(0xFF38BDF8),
          const Color(0xFFFBBF24),
          const Color(0xFFA855F7),
        ];
        return Icon(icons[cardSlot], size: 19, color: colors[cardSlot]);

      case AppThemeType.pastelDream:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeType>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, themeType, _) {
        final config = ThemeConfig.fromType(themeType);
        final cardColor = _resolveCardColor(config);
        Offset? tapPosition;

        return GestureDetector(
          onTapDown: (details) {
            tapPosition = details.globalPosition;
          },
          onTap: onTap,
          onLongPress: () {
            if (tapPosition != null) {
              _showContextMenu(
                context,
                TapDownDetails(globalPosition: tapPosition!),
              );
            }
          },
          child: Hero(
            tag: 'note_hero_${note.id}',
            child: Material(
              type: MaterialType.transparency,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  boxShadow: config.cardShadow,
                  border: Border.all(color: config.cardBorderColor, width: 1.2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  child: Stack(
                    children: [
                      // Subtle shine decoration at top right corner
                      Positioned(
                        top: -15,
                        right: -15,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(
                              alpha: config.isDark ? 0.08 : 0.4,
                            ),
                          ),
                        ),
                      ),

                      // Drawing preview overlay
                      if (note.drawingData != null &&
                          note.drawingData!.isNotEmpty)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Opacity(
                              opacity: 0.5,
                              child: CustomPaint(
                                painter: DrawingPainter(
                                  strokes: DrawingStroke.deserializeStrokes(
                                    note.drawingData!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Main Note Content
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title row (with optional pin and 3-dots)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (note.customIcon != null)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6, top: 1),
                                    child: Icon(
                                      note.customIcon,
                                      size: 16,
                                      color: config.textDark.withValues(alpha: 0.85),
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    note.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: config.textDark,
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                                if (note.drawingData != null &&
                                    note.drawingData!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: Icon(
                                      Icons.draw_rounded,
                                      size: 13,
                                      color: config.primaryColor.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                if (note.isPinned)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.push_pin_rounded,
                                      size: 14,
                                      color: config.primaryColor,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Body preview (max 3 lines)
                            Expanded(
                              child: Text(
                                note.content.isEmpty
                                    ? 'Boş not...'
                                    : note.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: config.textDark.withValues(alpha: 0.8),
                                  height: 1.35,
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Bottom row: Themed Corner Icon & Date badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildThemeCornerIcon(config),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 2.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: config.isDark
                                        ? Colors.black.withValues(alpha: 0.3)
                                        : Colors.white.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: config.cardBorderColor.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    _formatDate(note.date),
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: config.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
