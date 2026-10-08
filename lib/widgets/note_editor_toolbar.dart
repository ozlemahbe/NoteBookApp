import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Cute bottom toolbar for the note editor.
/// Provides: Drawing, Checklist, Text formatting, Background highlight,
/// Font size, and Undo/Redo actions.
class NoteEditorToolbar extends StatefulWidget {
  final VoidCallback onDrawingTap;
  final VoidCallback onChecklistTap;
  final VoidCallback onBoldTap;
  final VoidCallback onItalicTap;
  final VoidCallback onUnderlineTap;
  final VoidCallback onStrikethroughTap;
  final Function(Color) onHighlightColorSelected;
  final Function(double) onFontSizeSelected;
  final Function(IconData?) onIconSelected;
  final VoidCallback onUndoTap;
  final VoidCallback onRedoTap;
  final VoidCallback? onBulletListTap;
  final VoidCallback? onNumberedListTap;
  final VoidCallback? onAlignLeftTap;
  final VoidCallback? onAlignCenterTap;
  final VoidCallback? onAlignRightTap;
  final VoidCallback? onDecreaseIndentTap;
  final VoidCallback? onIncreaseIndentTap;
  final TextAlign currentTextAlign;
  final bool canUndo;
  final bool canRedo;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final bool isStrikethrough;
  final double currentFontSize;
  final Color? currentHighlightColor;
  final IconData? currentIcon;

  const NoteEditorToolbar({
    super.key,
    required this.onDrawingTap,
    required this.onChecklistTap,
    required this.onBoldTap,
    required this.onItalicTap,
    required this.onUnderlineTap,
    required this.onStrikethroughTap,
    required this.onHighlightColorSelected,
    required this.onFontSizeSelected,
    required this.onIconSelected,
    required this.onUndoTap,
    required this.onRedoTap,
    this.onBulletListTap,
    this.onNumberedListTap,
    this.onAlignLeftTap,
    this.onAlignCenterTap,
    this.onAlignRightTap,
    this.onDecreaseIndentTap,
    this.onIncreaseIndentTap,
    this.currentTextAlign = TextAlign.left,
    this.canUndo = false,
    this.canRedo = false,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.isStrikethrough = false,
    this.currentFontSize = 16,
    this.currentHighlightColor,
    this.currentIcon,
  });

  @override
  State<NoteEditorToolbar> createState() => _NoteEditorToolbarState();
}

class _NoteEditorToolbarState extends State<NoteEditorToolbar>
    with SingleTickerProviderStateMixin {
  bool _showTextOptions = false;
  bool _showHighlightColors = false;
  bool _showFontSizes = false;
  bool _showIconOptions = false;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _toggleTextOptions() {
    setState(() {
      _showTextOptions = !_showTextOptions;
      _showHighlightColors = false;
      _showFontSizes = false;
    });
  }

  void _toggleHighlightColors() {
    setState(() {
      _showHighlightColors = !_showHighlightColors;
      _showTextOptions = false;
      _showFontSizes = false;
    });
  }

  void _toggleFontSizes() {
    setState(() {
      _showFontSizes = !_showFontSizes;
      _showTextOptions = false;
      _showHighlightColors = false;
      _showIconOptions = false;
    });
  }

  void _toggleIconOptions() {
    setState(() {
      _showIconOptions = !_showIconOptions;
      _showTextOptions = false;
      _showHighlightColors = false;
      _showFontSizes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Expandable panels above toolbar
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: _buildExpandedPanel(),
          ),
          // Main toolbar
          _buildMainToolbar(),
        ],
      ),
    );
  }

  Widget _buildExpandedPanel() {
    if (_showTextOptions) return _buildTextOptionsPanel();
    if (_showHighlightColors) return _buildHighlightPanel();
    if (_showFontSizes) return _buildFontSizePanel();
    if (_showIconOptions) return _buildIconOptionsPanel();
    return const SizedBox.shrink();
  }

  /// Text formatting options panel (Bold, Italic, Underline, Strikethrough)
  Widget _buildTextOptionsPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252525), // Dark background matching the photo
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Metin seçenekleri',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: _toggleTextOptions,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Row 1: Lists & Alignment
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildOptionIcon(
                      Icons.format_list_bulleted_rounded,
                      false,
                      onTap: widget.onBulletListTap,
                    ),
                    _buildOptionIcon(
                      Icons.format_list_numbered_rounded,
                      false,
                      onTap: widget.onNumberedListTap,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildOptionIcon(
                        Icons.format_align_left_rounded,
                        widget.currentTextAlign == TextAlign.left,
                        onTap: widget.onAlignLeftTap,
                      ),
                      _buildOptionIcon(
                        Icons.format_align_center_rounded,
                        widget.currentTextAlign == TextAlign.center,
                        onTap: widget.onAlignCenterTap,
                      ),
                      _buildOptionIcon(
                        Icons.format_align_right_rounded,
                        widget.currentTextAlign == TextAlign.right,
                        onTap: widget.onAlignRightTap,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Row 2: Formatting & Indents
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildFormatIconText(
                      'B',
                      widget.isBold,
                      widget.onBoldTap,
                      FontWeight.w900,
                      false,
                      false,
                      false,
                    ),
                    _buildFormatIconText(
                      'I',
                      widget.isItalic,
                      widget.onItalicTap,
                      FontWeight.normal,
                      true,
                      false,
                      false,
                    ),
                    _buildFormatIconText(
                      'U',
                      widget.isUnderline,
                      widget.onUnderlineTap,
                      FontWeight.normal,
                      false,
                      true,
                      false,
                    ),
                    _buildFormatIconText(
                      'A',
                      widget.isStrikethrough,
                      widget.onStrikethroughTap,
                      FontWeight.normal,
                      false,
                      false,
                      true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildOptionIcon(
                        Icons.format_indent_decrease_rounded,
                        false,
                        onTap: widget.onDecreaseIndentTap,
                      ),
                      _buildOptionIcon(
                        Icons.format_indent_increase_rounded,
                        false,
                        onTap: widget.onIncreaseIndentTap,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionIcon(IconData icon, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildFormatIconText(
    String text,
    bool isActive,
    VoidCallback onTap,
    FontWeight weight,
    bool isItalic,
    bool isUnderline,
    bool isStrikethrough,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: weight,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            decoration: isUnderline
                ? TextDecoration.underline
                : isStrikethrough
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            decorationColor: Colors.white,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }

  /// Highlight color picker panel
  Widget _buildHighlightPanel() {
    final highlightColors = [
      null, // No highlight
      const Color(0xFFFFE082), // Yellow
      const Color(0xFFFFCDD2), // Pink
      const Color(0xFFC8E6C9), // Green
      const Color(0xFFBBDEFB), // Blue
      const Color(0xFFE1BEE7), // Purple
      const Color(0xFFFFCCBC), // Orange
      const Color(0xFFB2DFDB), // Teal
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: _panelDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: highlightColors.map((color) {
          final isSelected = widget.currentHighlightColor == color;
          return GestureDetector(
            onTap: () =>
                widget.onHighlightColorSelected(color ?? Colors.transparent),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color ?? Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.deepLavender
                      : color == null
                      ? Colors.grey.withValues(alpha: 0.3)
                      : Colors.white,
                  width: isSelected ? 2.5 : 1.5,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: (color ?? AppTheme.primaryLavender).withValues(
                        alpha: 0.4,
                      ),
                      blurRadius: 6,
                    ),
                ],
              ),
              child: color == null
                  ? Icon(
                      Icons.format_color_reset_rounded,
                      size: 16,
                      color: Colors.grey.withValues(alpha: 0.5),
                    )
                  : isSelected
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
    );
  }

  /// Font size picker panel
  Widget _buildFontSizePanel() {
    final fontSizes = [12.0, 14.0, 16.0, 18.0, 20.0, 24.0, 28.0, 32.0];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: _panelDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: fontSizes.map((size) {
          final isSelected = widget.currentFontSize == size;
          return GestureDetector(
            onTap: () => widget.onFontSizeSelected(size),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryLavender.withValues(alpha: 0.25)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.deepLavender.withValues(alpha: 0.5)
                      : Colors.transparent,
                ),
              ),
              child: Center(
                child: Text(
                  '${size.toInt()}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppTheme.deepLavender
                        : AppTheme.textMuted,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Icon options panel
  Widget _buildIconOptionsPanel() {
    final noteIcons = [
      null,
      Icons.favorite_rounded,
      Icons.star_rounded,
      Icons.auto_awesome,
      Icons.shopping_bag_rounded,
      Icons.restaurant_rounded,
      Icons.local_cafe_rounded,
      Icons.menu_book_rounded,
      Icons.flight_takeoff_rounded,
      Icons.music_note_rounded,
      Icons.pets_rounded,
      Icons.sports_esports_rounded,
      Icons.wb_sunny_rounded,
      Icons.nightlight_round,
      Icons.brush_rounded,
      Icons.work_rounded,
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: _panelDecoration(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: noteIcons.map((icon) {
            final isSelected = widget.currentIcon == icon;
            return GestureDetector(
              onTap: () => widget.onIconSelected(icon),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 38,
                height: 38,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryLavender.withValues(alpha: 0.25)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.deepLavender.withValues(alpha: 0.5)
                        : Colors.transparent,
                  ),
                ),
                child: Center(
                  child: icon == null
                      ? Icon(
                          Icons.block_rounded,
                          size: 18,
                          color: Colors.grey.withValues(alpha: 0.5),
                        )
                      : Icon(
                          icon,
                          size: 20,
                          color: isSelected
                              ? AppTheme.deepLavender
                              : AppTheme.textMuted,
                        ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Main bottom toolbar
  Widget _buildMainToolbar() {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepLavender.withValues(alpha: 0.10),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, -2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.primaryLavender.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Drawing tool
          _buildToolbarItem(
            icon: Icons.draw_rounded,
            isActive: false,
            onTap: widget.onDrawingTap,
            tooltip: 'Çizim',
          ),

          _buildDivider(),

          // Checklist / Task toggle
          _buildToolbarItem(
            icon: Icons.check_box,
            isActive: false,
            onTap: widget.onChecklistTap,
            tooltip: 'Görev Ekle',
          ),

          _buildDivider(),

          // Text formatting
          _buildToolbarItem(
            customChild: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'A',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                    color: _showTextOptions
                        ? AppTheme.deepLavender
                        : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 1),
                Container(
                  width: 12,
                  height: 2.5,
                  decoration: BoxDecoration(
                    color: _showTextOptions
                        ? AppTheme.deepLavender
                        : AppTheme.textMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            isActive: _showTextOptions,
            onTap: _toggleTextOptions,
            tooltip: 'Metin Seçenekleri',
          ),

          _buildDivider(),

          // Text color
          _buildToolbarItem(
            icon: Icons.format_color_text_rounded,
            isActive: _showHighlightColors,
            onTap: _toggleHighlightColors,
            tooltip: 'Yazı Rengi',
            iconColor:
                widget.currentHighlightColor != null &&
                    widget.currentHighlightColor != Colors.transparent
                ? widget.currentHighlightColor
                : null,
          ),

          _buildDivider(),

          // Font size
          _buildToolbarItem(
            customChild: Text(
              '${widget.currentFontSize.toInt()}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _showFontSizes
                    ? AppTheme.deepLavender
                    : AppTheme.textMuted,
              ),
            ),
            isActive: _showFontSizes,
            onTap: _toggleFontSizes,
            tooltip: 'Yazı Boyutu',
          ),

          _buildDivider(),

          // Icon Selector
          _buildToolbarItem(
            icon: widget.currentIcon ?? Icons.emoji_emotions_rounded,
            isActive: _showIconOptions,
            onTap: _toggleIconOptions,
            tooltip: 'Simge Ekle',
            iconColor: widget.currentIcon != null
                ? AppTheme.deepLavender
                : null,
          ),

          _buildDivider(),

          // Undo
          _buildToolbarItem(
            icon: Icons.undo_rounded,
            isActive: false,
            onTap: widget.canUndo ? widget.onUndoTap : null,
            enabled: widget.canUndo,
            tooltip: 'Geri Al',
          ),

          // Redo
          _buildToolbarItem(
            icon: Icons.redo_rounded,
            isActive: false,
            onTap: widget.canRedo ? widget.onRedoTap : null,
            enabled: widget.canRedo,
            tooltip: 'Yinele',
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarItem({
    IconData? icon,
    Widget? customChild,
    required bool isActive,
    VoidCallback? onTap,
    bool enabled = true,
    String tooltip = '',
    Color? iconColor,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.primaryLavender.withValues(alpha: 0.22)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child:
                  customChild ??
                  Icon(
                    icon,
                    size: 21,
                    color: !enabled
                        ? AppTheme.textHint.withValues(alpha: 0.4)
                        : isActive
                        ? AppTheme.deepLavender
                        : iconColor ?? AppTheme.textMuted,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    FontWeight fontWeight = FontWeight.w600,
    bool isItalicStyle = false,
    bool hasUnderline = false,
    bool hasStrikethrough = false,
    String tooltip = '',
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 42,
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.primaryLavender.withValues(alpha: 0.25)
                  : Colors.grey.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? AppTheme.deepLavender.withValues(alpha: 0.4)
                    : Colors.transparent,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: fontWeight,
                  fontStyle: isItalicStyle
                      ? FontStyle.italic
                      : FontStyle.normal,
                  color: isActive ? AppTheme.deepLavender : AppTheme.textMuted,
                  decoration: hasUnderline
                      ? TextDecoration.underline
                      : hasStrikethrough
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: isActive
                      ? AppTheme.deepLavender
                      : AppTheme.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 22,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: AppTheme.primaryLavender.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: AppTheme.deepLavender.withValues(alpha: 0.08),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
      border: Border.all(
        color: AppTheme.primaryLavender.withValues(alpha: 0.2),
      ),
    );
  }
}
