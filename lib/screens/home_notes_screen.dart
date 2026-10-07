import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';
import '../widgets/note_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/themed_background.dart';
import 'add_edit_note_screen.dart';

/// Screen 1: Home (Classic Notes) with rich atmospheric theme support:
/// - Atmospheric ambient background (ThemedBackground)
/// - Themed typography & inspirational headers matching the 5 mockups
/// - 2-column note cards grid with theme-specific styling
/// - Themed Floating Action Button (FAB)
class HomeNotesScreen extends StatefulWidget {
  final List<NoteModel> notes;
  final Function(NoteModel) onAddNote;
  final Function(NoteModel) onUpdateNote;
  final Function(String) onDeleteNote;
  final Function(NoteModel) onCopyNote;
  final VoidCallback? onOpenDrawer;
  final VoidCallback? onOpenSettings;

  const HomeNotesScreen({
    super.key,
    required this.notes,
    required this.onAddNote,
    required this.onUpdateNote,
    required this.onDeleteNote,
    required this.onCopyNote,
    this.onOpenDrawer,
    this.onOpenSettings,
  });

  @override
  State<HomeNotesScreen> createState() => _HomeNotesScreenState();
}

class _HomeNotesScreenState extends State<HomeNotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<NoteModel> get _filteredNotes {
    if (_searchQuery.isEmpty) return widget.notes;
    final query = _searchQuery.toLowerCase();
    return widget.notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();
  }

  void _openNoteEditor({NoteModel? note, bool isNew = false}) async {
    final result = await Navigator.of(context).push<NoteModel>(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddEditNoteScreen(note: note, isNew: isNew),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    if (result != null) {
      if (isNew) {
        widget.onAddNote(result);
      } else {
        widget.onUpdateNote(result);
      }
    }
  }

  Widget _buildThemedHeader(ThemeConfig config) {
    if (config.headerTitle == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.headerTitle!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: config.textDark,
                    letterSpacing: -0.2,
                  ),
                ),
                if (config.headerSubtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    config.headerSubtitle!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: config.textMuted,
                      letterSpacing: 1.1,
                      height: 1.25,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (config.headerBadge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: config.isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: config.cardBorderColor.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                config.headerBadge!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: config.textMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThemedFab(ThemeConfig config) {
    return Positioned(
      right: 22,
      bottom: 96,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Botanical "Yeni Not ↗" hand-drawn cue
          if (config.type == AppThemeType.botanical)
            Positioned(
              left: -74,
              top: -6,
              child: Row(
                children: [
                  Text(
                    'Yeni\nNot',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: config.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_outward_rounded,
                    size: 16,
                    color: config.primaryColor,
                  ),
                ],
              ),
            ),

          // Cosmic Saturn ring
          if (config.type == AppThemeType.cosmicDream)
            Container(
              width: 72,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFFD8B4F8).withValues(alpha: 0.7),
                  width: 1.8,
                ),
              ),
            ),

          // Main FAB Button
          Container(
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
                  color: config.fabShadowColor.withValues(
                    alpha: config.isDark ? 0.6 : 0.4,
                  ),
                  blurRadius: 18,
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
                onTap: () => _openNoteEditor(isNew: true),
                child: Icon(
                  Icons.add_rounded,
                  size: 32,
                  color: config.fabIconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredNotes;

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
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                      child: SearchBarWidget(
                        controller: _searchController,
                        onMenuTap: widget.onOpenDrawer,
                        onSettingsTap: widget.onOpenSettings,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                      ),
                    ),

                    // Atmospheric Themed Header Quote
                    _buildThemedHeader(config),

                    // Note Grid (2 columns)
                    Expanded(
                      child: filtered.isEmpty
                          ? _buildEmptyState(config)
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.96,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final note = filtered[index];
                                return NoteCard(
                                  note: note,
                                  index: index,
                                  onTap: () => _openNoteEditor(note: note),
                                  onDelete: () => widget.onDeleteNote(note.id),
                                  onCopy: () => widget.onCopyNote(note),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),

              // Themed Floating Action Button
              _buildThemedFab(config),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeConfig config) {
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
              Icons.draw_rounded,
              size: 44,
              color: config.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'Aramaya uygun not bulunamadı'
                : 'Henüz bir notun yok ♡',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: config.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _searchQuery.isNotEmpty
                ? 'Farklı bir kelime deneyebilirsin'
                : 'Aşağıdaki + butonuna basarak yeni bir not oluşturabilirsin',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: config.textMuted),
          ),
        ],
      ),
    );
  }
}
