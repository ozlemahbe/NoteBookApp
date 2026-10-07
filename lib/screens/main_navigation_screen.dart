import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../models/notebook_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';
import '../widgets/floating_bottom_bar.dart';
import '../widgets/side_drawer_widget.dart';
import 'auth_screen.dart';
import 'home_notes_screen.dart';
import 'notebooks_screen.dart';
import 'settings_screen.dart';
import 'trash_screen.dart';

/// Main navigation container managing active tabs and core mock state
/// using standard StatefulWidget (no external state management as requested)
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentTabIndex = 0;

  // Authenticated user state
  UserModel? _currentUser;

  // In-memory mock state for classic notes
  late List<NoteModel> _notes;

  // In-memory trash bin for deleted notes
  final List<NoteModel> _deletedNotes = [];

  // In-memory mock state for custom cover notebooks
  late List<NotebookModel> _notebooks;

  @override
  void initState() {
    super.initState();
    _notes = List.from(NoteModel.mockNotes);
    _notebooks = List.from(NotebookModel.mockNotebooks);
    try {
      _currentUser = AuthService().currentUser;
    } catch (_) {}
  }

  // --- Note Operations ---
  void _addNote(NoteModel note) {
    setState(() {
      _notes.insert(0, note);
    });
  }

  void _updateNote(NoteModel updatedNote) {
    setState(() {
      final index = _notes.indexWhere((n) => n.id == updatedNote.id);
      if (index != -1) {
        _notes[index] = updatedNote;
      }
    });
  }

  void _deleteNote(String id) {
    final noteToDelete = _notes.firstWhere((n) => n.id == id);
    setState(() {
      _notes.removeWhere((n) => n.id == id);
      _deletedNotes.insert(0, noteToDelete);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${noteToDelete.title}" çöp kutusuna taşındı'),
        action: SnackBarAction(
          label: 'Geri Al',
          textColor: AppTheme.pastelPink,
          onPressed: () {
            setState(() {
              _deletedNotes.removeWhere((n) => n.id == noteToDelete.id);
              _notes.insert(0, noteToDelete);
            });
          },
        ),
        backgroundColor: AppTheme.textDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 90, left: 24, right: 24),
      ),
    );
  }

  void _restoreNote(NoteModel note) {
    setState(() {
      _deletedNotes.removeWhere((n) => n.id == note.id);
      _notes.insert(0, note);
    });
  }

  void _permanentDeleteNote(String id) {
    setState(() {
      _deletedNotes.removeWhere((n) => n.id == id);
    });
  }

  void _clearTrash() {
    setState(() {
      _deletedNotes.clear();
    });
  }

  void _openTrashScreen() {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrashScreen(
          deletedNotes: _deletedNotes,
          onRestoreNote: _restoreNote,
          onPermanentDelete: _permanentDeleteNote,
          onClearAll: _clearTrash,
        ),
      ),
    );
  }

  void _openSettingsScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _copyNote(NoteModel note) {
    final copiedNote = note.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${note.title} (Kopya)',
      date: DateTime.now(),
    );

    setState(() {
      _notes.insert(0, copiedNote);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.copy_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text('"${note.title}" kopyalandı ♡'),
          ],
        ),
        backgroundColor: AppTheme.deepLavender,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 90, left: 24, right: 24),
      ),
    );
  }

  // --- Notebook Operations ---
  void _addNotebook(NotebookModel notebook) {
    setState(() {
      _notebooks.insert(0, notebook);
    });
  }

  void _deleteNotebook(String id) {
    setState(() {
      _notebooks.removeWhere((nb) => nb.id == id);
    });
  }

  void _openAuthScreen() async {
    // If drawer is open, close it first
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AuthScreen(
          currentUser: _currentUser,
          onLoginSuccess: (user) {
            setState(() {
              _currentUser = user;
            });
          },
          onLogout: () {
            setState(() {
              _currentUser = null;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeType>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, currentTheme, _) {
        final config = ThemeConfig.fromType(currentTheme);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: config.scaffoldBg,
          drawer: SideDrawerWidget(
            currentUser: _currentUser,
            noteCount: _notes.length,
            notebookCount: _notebooks.length,
            deletedNotesCount: _deletedNotes.length,
            onOpenAccount: _openAuthScreen,
            onOpenTrash: _openTrashScreen,
            onLogout: () async {
              await AuthService().signOut();
              setState(() {
                _currentUser = null;
              });
              if (!context.mounted) return;
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Hesaptan çıkış yapıldı'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
          body: Stack(
            children: [
              // Screens IndexedStack
              IndexedStack(
                index: _currentTabIndex,
                children: [
                  // Tab 0: Home (Classic Notes)
                  HomeNotesScreen(
                    notes: _notes,
                    onAddNote: _addNote,
                    onUpdateNote: _updateNote,
                    onDeleteNote: _deleteNote,
                    onCopyNote: _copyNote,
                    onOpenDrawer: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    onOpenSettings: _openSettingsScreen,
                  ),

                  // Tab 1: Notebooks (Günlük/Ajanda)
                  NotebooksScreen(
                    notebooks: _notebooks,
                    onAddNotebook: _addNotebook,
                    onDeleteNotebook: _deleteNotebook,
                  ),

                  // Tab 2: Settings (Ayarlar)
                  const SettingsScreen(),
                ],
              ),

              // Custom Floating Bottom Navigation Bar (Glassmorphic + active rounded box)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FloatingBottomBar(
                  currentIndex: _currentTabIndex,
                  onTabSelected: (index) {
                    setState(() {
                      _currentTabIndex = index;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
