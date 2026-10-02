import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../theme/app_theme.dart';

/// Screen 3: Add/Edit Note Screen
/// Features:
/// - Hero transition matching NoteCard
/// - Large bold title input
/// - Expanding multi-line body text field
/// - Color palette picker for note background
/// - Back button with auto-save
class AddEditNoteScreen extends StatefulWidget {
  final NoteModel? note;
  final bool isNew;

  const AddEditNoteScreen({
    super.key,
    this.note,
    this.isNew = false,
  });

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Color _selectedColor;
  late String _noteId;
  late DateTime _noteDate;
  bool _isPinned = false;
  bool _hasSaved = false;

  @override
  void initState() {
    super.initState();
    _noteId = widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _selectedColor = widget.note?.color ?? AppTheme.noteColors[0];
    _noteDate = widget.note?.date ?? DateTime.now();
    _isPinned = widget.note?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Triggers auto-save and pops the screen with the updated note
  void _saveAndPop() {
    if (_hasSaved) return;
    _hasSaved = true;

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // If both empty and isNew, don't create an empty note
    if (title.isEmpty && content.isEmpty && widget.isNew) {
      Navigator.of(context).pop();
      return;
    }

    final updatedNote = NoteModel(
      id: _noteId,
      title: title.isEmpty ? 'Başlıksız Not' : title,
      content: content,
      date: DateTime.now(),
      color: _selectedColor,
      isPinned: _isPinned,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Not kaydedildi ♡',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: AppTheme.deepLavender,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
      ),
    );

    Navigator.of(context).pop(updatedNote);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _saveAndPop();
      },
      child: Hero(
        tag: 'note_hero_$_noteId',
        child: Scaffold(
          backgroundColor: _selectedColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: AppTheme.textDark,
                  onPressed: _saveAndPop,
                ),
              ),
            ),
            actions: [
              // Pin toggle button
              IconButton(
                icon: Icon(
                  _isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                  color: _isPinned ? AppTheme.deepLavender : AppTheme.textMuted,
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _isPinned = !_isPinned;
                  });
                },
              ),
              // Done checkmark button
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check_rounded, color: AppTheme.deepLavender),
                    onPressed: _saveAndPop,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Color palette row
                Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: AppTheme.noteColors.map((color) {
                      final isSelected = _selectedColor == color;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.deepLavender
                                  : Colors.white,
                              width: isSelected ? 2.5 : 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: AppTheme.deepLavender,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Note Content Area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Title Input
                        TextField(
                          controller: _titleController,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Başlık...',
                            hintStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textHint,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Date display
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 13,
                              color: AppTheme.textMuted.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${_noteDate.day}.${_noteDate.month}.${_noteDate.year} ${_noteDate.hour.toString().padLeft(2, '0')}:${_noteDate.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textMuted.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black12,
                          height: 24,
                          thickness: 0.8,
                        ),

                        // Expanding Body Input
                        Expanded(
                          child: TextField(
                            controller: _contentController,
                            maxLines: null,
                            expands: true,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.textDark,
                              height: 1.5,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Düşüncelerini buraya yaz...',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: AppTheme.textHint,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
