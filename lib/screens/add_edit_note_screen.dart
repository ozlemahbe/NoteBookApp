import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../theme/app_theme.dart';
import '../widgets/note_editor_toolbar.dart';
import '../widgets/drawing_canvas.dart';

/// Screen 3: Add/Edit Note Screen
/// Features:
/// - Hero transition matching NoteCard
/// - Large bold title input
/// - Expanding multi-line body text field
/// - Color palette picker for note background
/// - Cute bottom toolbar with: Drawing, Checklist, Text formatting,
///   Highlight colors, Font size, Undo/Redo
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

  // Toolbar state
  bool _showDrawingCanvas = false;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isStrikethrough = false;
  TextAlign _currentTextAlign = TextAlign.left;
  double _currentFontSize = 16;
  Color? _currentHighlightColor;
  String? _drawingData;
  IconData? _selectedIcon;

  // Undo/Redo stacks for content
  final List<_TextSnapshot> _undoStack = [];
  final List<_TextSnapshot> _redoStack = [];
  String _lastSavedText = '';
  bool _isUndoRedoAction = false;

  // Checklist tracking
  final List<ChecklistItem> _checklistItems = [];
  final FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _noteId =
        widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
    _selectedColor = widget.note?.color ?? AppTheme.noteColors[0];
    _noteDate = widget.note?.date ?? DateTime.now();
    _isPinned = widget.note?.isPinned ?? false;
    _drawingData = widget.note?.drawingData;
    _selectedIcon = widget.note?.customIcon;
    _lastSavedText = _contentController.text;

    // Parse existing checklist items from content
    _parseChecklistFromContent();

    // Listen for changes to create undo snapshots
    _contentController.addListener(_onContentChanged);
  }

  void _parseChecklistFromContent() {
    final content = _contentController.text;
    final lines = content.split('\n');
    for (final line in lines) {
      if (line.startsWith('☑ ') || line.startsWith('☐ ')) {
        _checklistItems.add(ChecklistItem(
          text: line.substring(2),
          isCompleted: line.startsWith('☑ '),
        ));
      }
    }
  }

  void _onContentChanged() {
    if (_isUndoRedoAction) return;
    final currentText = _contentController.text;
    if (currentText != _lastSavedText) {
      _undoStack.add(_TextSnapshot(
        text: _lastSavedText,
        cursorPosition: _contentController.selection.baseOffset,
      ));
      _redoStack.clear();
      _lastSavedText = currentText;
      // Keep stack manageable
      if (_undoStack.length > 50) _undoStack.removeAt(0);
      setState(() {});
    }
  }

  void _undo() {
    if (_undoStack.isEmpty) return;
    _isUndoRedoAction = true;
    final snapshot = _undoStack.removeLast();
    _redoStack.add(_TextSnapshot(
      text: _contentController.text,
      cursorPosition: _contentController.selection.baseOffset,
    ));
    _contentController.text = snapshot.text;
    _lastSavedText = snapshot.text;
    // Restore cursor
    final pos = snapshot.cursorPosition.clamp(0, snapshot.text.length);
    _contentController.selection = TextSelection.collapsed(offset: pos);
    _isUndoRedoAction = false;
    setState(() {});
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    _isUndoRedoAction = true;
    final snapshot = _redoStack.removeLast();
    _undoStack.add(_TextSnapshot(
      text: _contentController.text,
      cursorPosition: _contentController.selection.baseOffset,
    ));
    _contentController.text = snapshot.text;
    _lastSavedText = snapshot.text;
    final pos = snapshot.cursorPosition.clamp(0, snapshot.text.length);
    _contentController.selection = TextSelection.collapsed(offset: pos);
    _isUndoRedoAction = false;
    setState(() {});
  }

  void _insertChecklist() {
    final text = _contentController.text;
    final selection = _contentController.selection;
    if (selection.baseOffset < 0) return; // No selection

    final cursorPos = selection.baseOffset;
    
    // Find the start and end of the current line
    int lineStart = text.lastIndexOf('\n', cursorPos - 1);
    lineStart = lineStart == -1 ? 0 : lineStart + 1;
    
    int lineEnd = text.indexOf('\n', cursorPos);
    lineEnd = lineEnd == -1 ? text.length : lineEnd;
    
    final currentLine = text.substring(lineStart, lineEnd);
    
    if (currentLine.startsWith('☐ ') || currentLine.startsWith('☑ ')) {
      // Remove it if it already has one
      final newLine = currentLine.substring(2);
      _contentController.text = text.substring(0, lineStart) + newLine + text.substring(lineEnd);
      _contentController.selection = TextSelection.collapsed(offset: (cursorPos - 2).clamp(0, _contentController.text.length));
    } else {
      // Insert new
      String prefix = '';
      if (cursorPos > 0 && text.isNotEmpty && text[cursorPos - 1] != '\n') {
        prefix = '\n';
      }
      final checkItem = '$prefix☐ ';
      _contentController.text = text.substring(0, cursorPos) +
          checkItem +
          text.substring(cursorPos);
      _contentController.selection = TextSelection.collapsed(
        offset: cursorPos + checkItem.length,
      );
    }

    _contentFocusNode.requestFocus();
  }

  void _setAlignment(TextAlign align) {
    setState(() => _currentTextAlign = align);
  }

  void _insertTextAtCursor(String textToInsert) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    if (selection.baseOffset < 0) return;

    final cursorPos = selection.baseOffset;
    
    // Find the start of the current line
    int lineStart = text.lastIndexOf('\n', cursorPos - 1);
    lineStart = lineStart == -1 ? 0 : lineStart + 1;
    
    _contentController.text = text.substring(0, lineStart) + textToInsert + text.substring(lineStart);
    _contentController.selection = TextSelection.collapsed(offset: cursorPos + textToInsert.length);
    _contentFocusNode.requestFocus();
  }

  void _insertBulletList() => _insertTextAtCursor('• ');

  void _insertNumberedList() => _insertTextAtCursor('1. ');

  void _decreaseIndent() {
    final text = _contentController.text;
    final selection = _contentController.selection;
    if (selection.baseOffset < 0) return;

    final cursorPos = selection.baseOffset;
    int lineStart = text.lastIndexOf('\n', cursorPos - 1);
    lineStart = lineStart == -1 ? 0 : lineStart + 1;
    
    int lineEnd = text.indexOf('\n', lineStart);
    if (lineEnd == -1) lineEnd = text.length;

    final currentLine = text.substring(lineStart, lineEnd);
    
    if (currentLine.startsWith('    ')) {
      _contentController.text = text.substring(0, lineStart) + currentLine.substring(4) + text.substring(lineEnd);
      _contentController.selection = TextSelection.collapsed(offset: (cursorPos - 4).clamp(0, text.length));
    } else if (currentLine.startsWith('\t')) {
      _contentController.text = text.substring(0, lineStart) + currentLine.substring(1) + text.substring(lineEnd);
      _contentController.selection = TextSelection.collapsed(offset: (cursorPos - 1).clamp(0, text.length));
    }
  }

  void _increaseIndent() => _insertTextAtCursor('    ');

  void _toggleTextFormat(String type) {
    switch (type) {
      case 'bold':
        setState(() => _isBold = !_isBold);
        break;
      case 'italic':
        setState(() => _isItalic = !_isItalic);
        break;
      case 'underline':
        setState(() => _isUnderline = !_isUnderline);
        break;
      case 'strikethrough':
        setState(() => _isStrikethrough = !_isStrikethrough);
        break;
    }
  }

  void _setHighlightColor(Color color) {
    setState(() {
      _currentHighlightColor =
          color == Colors.transparent ? null : color;
    });
  }

  void _setFontSize(double size) {
    setState(() {
      _currentFontSize = size;
    });
  }

  void _handleTextTap() {
    final selection = _contentController.selection;
    if (!selection.isValid || !selection.isCollapsed) return;

    final cursorPos = selection.baseOffset;
    final text = _contentController.text;
    
    if (cursorPos < 0 || text.isEmpty) return;

    const emptyBox = '☐';
    const checkedBox = '☑';

    int? boxIndexToToggle;

    if (cursorPos < text.length && (text[cursorPos] == emptyBox || text[cursorPos] == checkedBox)) {
      boxIndexToToggle = cursorPos;
    } else if (cursorPos > 0 && (text[cursorPos - 1] == emptyBox || text[cursorPos - 1] == checkedBox)) {
      boxIndexToToggle = cursorPos - 1;
    }

    if (boxIndexToToggle != null) {
      final isCurrentlyEmpty = text[boxIndexToToggle] == emptyBox;
      final newChar = isCurrentlyEmpty ? checkedBox : emptyBox;
      
      final newText = text.substring(0, boxIndexToToggle) + newChar + text.substring(boxIndexToToggle + 1);
      
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: cursorPos),
      );
    }
  }

  @override
  void dispose() {
    _contentController.removeListener(_onContentChanged);
    _titleController.dispose();
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  /// Triggers auto-save and pops the screen with the updated note
  void _saveAndPop() {
    if (_hasSaved) return;
    _hasSaved = true;

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // If all empty and isNew, don't create an empty note
    final hasDrawing = _drawingData != null && _drawingData!.isNotEmpty && _drawingData != '[]';
    if (title.isEmpty && content.isEmpty && !hasDrawing && widget.isNew) {
      Navigator.of(context).pop();
      return;
    }

    final updatedNote = NoteModel(
      id: _noteId,
      title: title.isEmpty ? 'Başlıksız Not' : title,
      content: content,
      drawingData: _drawingData,
      customIcon: _selectedIcon,
      date: DateTime.now(),
      color: _selectedColor,
      isPinned: _isPinned,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline_rounded,
                color: Colors.white, size: 18),
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

  TextStyle _buildContentTextStyle() {
    return TextStyle(
      fontSize: _currentFontSize,
      color: _currentHighlightColor ?? AppTheme.textDark,
      height: 1.5,
      fontWeight: _isBold ? FontWeight.w700 : FontWeight.normal,
      fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: _isUnderline
          ? TextDecoration.underline
          : _isStrikethrough
              ? TextDecoration.lineThrough
              : TextDecoration.none,
      decorationColor: _currentHighlightColor ?? AppTheme.textDark.withValues(alpha: 0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_showDrawingCanvas) {
          setState(() => _showDrawingCanvas = false);
          return;
        }
        _saveAndPop();
      },
      child: Hero(
        tag: 'note_hero_$_noteId',
        child: Scaffold(
          backgroundColor: _selectedColor,
          resizeToAvoidBottomInset: true,
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
                  onPressed: () {
                    if (_showDrawingCanvas) {
                      setState(() => _showDrawingCanvas = false);
                    } else {
                      _saveAndPop();
                    }
                  },
                ),
              ),
            ),
            actions: [
              // Pin toggle button
              IconButton(
                icon: Icon(
                  _isPinned
                      ? Icons.push_pin_rounded
                      : Icons.push_pin_outlined,
                  color: _isPinned
                      ? AppTheme.deepLavender
                      : AppTheme.textMuted,
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
                    icon: const Icon(Icons.check_rounded,
                        color: AppTheme.deepLavender),
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                                color:
                                    Colors.black.withValues(alpha: 0.06),
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
                  child: Stack(
                    children: [
                      // Main text editing area
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            // Title Input
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (_selectedIcon != null)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0, top: 2.0),
                                    child: Icon(
                                      _selectedIcon,
                                      size: 26,
                                      color: AppTheme.textDark.withValues(alpha: 0.8),
                                    ),
                                  ),
                                Expanded(
                                  child: TextField(
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
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Date display
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 13,
                                  color: AppTheme.textMuted
                                      .withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${_noteDate.day}.${_noteDate.month}.${_noteDate.year} ${_noteDate.hour.toString().padLeft(2, '0')}:${_noteDate.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textMuted
                                        .withValues(alpha: 0.8),
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
                                focusNode: _contentFocusNode,
                                maxLines: null,
                                expands: true,
                                textAlign: _currentTextAlign,
                                style: _buildContentTextStyle(),
                                onTap: _handleTextTap,
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

                      // Display saved drawing when not actively drawing
                      if (_drawingData != null && _drawingData!.isNotEmpty && !_showDrawingCanvas)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: DrawingPainter(
                                strokes: DrawingStroke.deserializeStrokes(_drawingData!),
                              ),
                              size: Size.infinite,
                            ),
                          ),
                        ),

                      // Drawing canvas overlay
                      if (_showDrawingCanvas)
                        Positioned.fill(
                          child: DrawingCanvas(
                            initialData: _drawingData,
                            onUpdate: (data) {
                              _drawingData = data;
                            },
                            onClose: (data) => setState(() {
                              _drawingData = data;
                              _showDrawingCanvas = false;
                            }),
                            noteColor: _selectedColor,
                          ),
                        ),
                    ],
                  ),
                ),

                // Bottom Editor Toolbar
                if (!_showDrawingCanvas)
                  NoteEditorToolbar(
                    onDrawingTap: () =>
                        setState(() => _showDrawingCanvas = true),
                    onChecklistTap: _insertChecklist,
                    onBoldTap: () => _toggleTextFormat('bold'),
                    onItalicTap: () => _toggleTextFormat('italic'),
                    onUnderlineTap: () => _toggleTextFormat('underline'),
                    onStrikethroughTap: () =>
                        _toggleTextFormat('strikethrough'),
                    onHighlightColorSelected: _setHighlightColor,
                    onFontSizeSelected: _setFontSize,
                    onIconSelected: (icon) => setState(() => _selectedIcon = icon),
                    onBulletListTap: _insertBulletList,
                    onNumberedListTap: _insertNumberedList,
                    onAlignLeftTap: () => _setAlignment(TextAlign.left),
                    onAlignCenterTap: () => _setAlignment(TextAlign.center),
                    onAlignRightTap: () => _setAlignment(TextAlign.right),
                    onDecreaseIndentTap: _decreaseIndent,
                    onIncreaseIndentTap: _increaseIndent,
                    currentTextAlign: _currentTextAlign,
                    onUndoTap: _undo,
                    onRedoTap: _redo,
                    canUndo: _undoStack.isNotEmpty,
                    canRedo: _redoStack.isNotEmpty,
                    isBold: _isBold,
                    isItalic: _isItalic,
                    isUnderline: _isUnderline,
                    isStrikethrough: _isStrikethrough,
                    currentFontSize: _currentFontSize,
                    currentHighlightColor: _currentHighlightColor,
                    currentIcon: _selectedIcon,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple text snapshot for undo/redo
class _TextSnapshot {
  final String text;
  final int cursorPosition;

  const _TextSnapshot({
    required this.text,
    required this.cursorPosition,
  });
}

/// Checklist item model used within the note editor
class ChecklistItem {
  String text;
  bool isCompleted;

  ChecklistItem({
    required this.text,
    this.isCompleted = false,
  });
}
