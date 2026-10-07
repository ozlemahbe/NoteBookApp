import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A cute drawing canvas overlay for the note editor.
/// Supports freehand drawing with color and stroke width selection.
class DrawingCanvas extends StatefulWidget {
  final Function(String) onClose;
  final Function(String)? onUpdate;
  final Color noteColor;
  final String? initialData;

  const DrawingCanvas({
    super.key,
    required this.onClose,
    this.onUpdate,
    required this.noteColor,
    this.initialData,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas>
    with SingleTickerProviderStateMixin {
  List<DrawingStroke> _strokes = [];
  final List<DrawingStroke> _undoneStrokes = [];
  List<Offset> _currentPoints = [];
  Color _selectedColor = const Color(0xFFE8607A);
  double _strokeWidth = 3.0;
  bool _isEraser = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const List<Color> _penColors = [
    Color(0xFFE8607A), // Rose
    Color(0xFF9D65C9), // Lavender
    Color(0xFF52796F), // Forest
    Color(0xFF3B82F6), // Blue
    Color(0xFFFF8E72), // Peach
    Color(0xFF383042), // Dark
    Color(0xFFFFB5C5), // Pink
    Color(0xFF10B981), // Mint
  ];

  static const List<double> _strokeWidths = [1.5, 3.0, 5.0, 8.0];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _fadeController.forward();
    
    if (widget.initialData != null && widget.initialData!.isNotEmpty) {
      _strokes = DrawingStroke.deserializeStrokes(widget.initialData!);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _undoStroke() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _undoneStrokes.add(_strokes.removeLast());
      });
      _notifyUpdate();
    }
  }

  void _redoStroke() {
    if (_undoneStrokes.isNotEmpty) {
      setState(() {
        _strokes.add(_undoneStrokes.removeLast());
      });
      _notifyUpdate();
    }
  }

  void _clearAll() {
    setState(() {
      _strokes.clear();
      _undoneStrokes.clear();
    });
    _notifyUpdate();
  }

  void _notifyUpdate() {
    if (widget.onUpdate != null) {
      widget.onUpdate!(DrawingStroke.serializeStrokes(_strokes));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Stack(
        children: [
          // Drawing area
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                _currentPoints = [details.localPosition];
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _currentPoints.add(details.localPosition);
              });
            },
            onPanEnd: (_) {
              setState(() {
                _strokes.add(DrawingStroke(
                  points: List.from(_currentPoints),
                  color: _isEraser ? widget.noteColor : _selectedColor,
                  strokeWidth: _isEraser ? _strokeWidth * 3 : _strokeWidth,
                ));
                _currentPoints = [];
                _undoneStrokes.clear();
              });
              _notifyUpdate();
            },
            child: CustomPaint(
              painter: DrawingPainter(
                strokes: _strokes,
                currentPoints: _currentPoints,
                currentColor: _isEraser ? widget.noteColor : _selectedColor,
                currentStrokeWidth: _isEraser ? _strokeWidth * 3 : _strokeWidth,
              ),
              size: Size.infinite,
            ),
          ),

          // Top control bar
          Positioned(
            top: 8,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.deepLavender.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppTheme.primaryLavender.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  // Close button
                  _buildToolButton(
                    icon: Icons.close_rounded,
                    isActive: false,
                    onTap: () => widget.onClose(DrawingStroke.serializeStrokes(_strokes)),
                    tooltip: 'Kapat',
                  ),
                  const Spacer(),
                  // Eraser toggle
                  _buildToolButton(
                    icon: Icons.auto_fix_high_rounded,
                    isActive: _isEraser,
                    onTap: () => setState(() => _isEraser = !_isEraser),
                    tooltip: 'Silgi',
                  ),
                  const SizedBox(width: 4),
                  // Undo
                  _buildToolButton(
                    icon: Icons.undo_rounded,
                    isActive: false,
                    onTap: _undoStroke,
                    enabled: _strokes.isNotEmpty,
                    tooltip: 'Geri Al',
                  ),
                  const SizedBox(width: 4),
                  // Redo
                  _buildToolButton(
                    icon: Icons.redo_rounded,
                    isActive: false,
                    onTap: _redoStroke,
                    enabled: _undoneStrokes.isNotEmpty,
                    tooltip: 'Yinele',
                  ),
                  const SizedBox(width: 4),
                  // Clear all
                  _buildToolButton(
                    icon: Icons.delete_outline_rounded,
                    isActive: false,
                    onTap: _clearAll,
                    enabled: _strokes.isNotEmpty,
                    tooltip: 'Temizle',
                  ),
                ],
              ),
            ),
          ),

          // Bottom palette bar
          Positioned(
            bottom: 12,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.deepLavender.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
                border: Border.all(
                  color: AppTheme.primaryLavender.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Color row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _penColors.map((color) {
                      final isSelected = _selectedColor == color && !_isEraser;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                            _isEraser = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isSelected ? 30 : 26,
                          height: isSelected ? 30 : 26,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded,
                                  size: 14, color: Colors.white)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  // Stroke width row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _strokeWidths.map((width) {
                      final isSelected = _strokeWidth == width;
                      return GestureDetector(
                        onTap: () => setState(() => _strokeWidth = width),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _selectedColor.withValues(alpha: 0.15)
                                : Colors.grey.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? _selectedColor.withValues(alpha: 0.5)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: width * 2.5,
                              height: width * 2.5,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _selectedColor
                                    : Colors.grey.withValues(alpha: 0.4),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    bool enabled = true,
    String tooltip = '',
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primaryLavender.withValues(alpha: 0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: !enabled
                ? Colors.grey.withValues(alpha: 0.3)
                : isActive
                    ? AppTheme.deepLavender
                    : AppTheme.textMuted,
          ),
        ),
      ),
    );
  }
}

/// Stores a single drawing stroke
class DrawingStroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  const DrawingStroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  Map<String, dynamic> toMap() {
    return {
      'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
      'color': color.toARGB32(),
      'strokeWidth': strokeWidth,
    };
  }

  factory DrawingStroke.fromMap(Map<String, dynamic> map) {
    return DrawingStroke(
      points: (map['points'] as List)
          .map((p) => Offset(p['x'] as double, p['y'] as double))
          .toList(),
      color: Color(map['color'] as int),
      strokeWidth: map['strokeWidth'] as double,
    );
  }

  static String serializeStrokes(List<DrawingStroke> strokes) {
    return jsonEncode(strokes.map((s) => s.toMap()).toList());
  }

  static List<DrawingStroke> deserializeStrokes(String data) {
    try {
      final List decoded = jsonDecode(data);
      return decoded.map((e) => DrawingStroke.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }
}

/// Custom painter for freehand drawing
class DrawingPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double currentStrokeWidth;

  DrawingPainter({
    required this.strokes,
    this.currentPoints = const [],
    this.currentColor = Colors.black,
    this.currentStrokeWidth = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw completed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke.points, stroke.color, stroke.strokeWidth);
    }
    // Draw current stroke being made
    if (currentPoints.isNotEmpty) {
      _drawStroke(canvas, currentPoints, currentColor, currentStrokeWidth);
    }
  }

  void _drawStroke(
      Canvas canvas, List<Offset> points, Color color, double width) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final midPoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(p0.dx, p0.dy, midPoint.dx, midPoint.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) => true;
}
