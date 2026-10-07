import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/notebook_model.dart';
import '../theme/app_theme.dart';

/// Rich notebook cover widget matching the screenshot design:
/// - Organic blob/wave decorations on the cover
/// - Decorative spine patterns (hearts, lines, diagonal, grid, dots, stars, waves, zigzag)
/// - White circular badge in center with icon
/// - Title displayed at bottom
/// - Floating shadow effect
class NotebookCoverWidget extends StatelessWidget {
  final NotebookModel notebook;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool compact;

  const NotebookCoverWidget({
    super.key,
    required this.notebook,
    this.onTap,
    this.isSelected = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = AppTheme.current;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? AppTheme.lavenderGlowShadow
              : config.cardShadow,
          border: isSelected
              ? Border.all(color: config.primaryColor, width: 2.5)
              : Border.all(color: config.cardBorderColor, width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Layer 1: Base cover color
              Positioned.fill(
                child: Container(color: notebook.coverColor),
              ),

              // Layer 2: Organic blob decorations painted on the cover
              Positioned.fill(
                child: CustomPaint(
                  painter: _CoverBlobPainter(
                    accentColor: notebook.accentColor,
                    spineColor: notebook.spineColor,
                  ),
                ),
              ),

              // Layer 3: Main content (spine + icon + title)
              Row(
                children: [
                  // Book Spine with decorative pattern
                  Container(
                    width: compact ? 16 : 22,
                    decoration: BoxDecoration(
                      color: notebook.spineColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 4,
                          offset: const Offset(2, 0),
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      painter: _SpinePatternPainter(
                        pattern: notebook.spinePattern,
                        color: Colors.white.withValues(alpha: 0.5),
                        compact: compact,
                      ),
                    ),
                  ),

                  // Cover Center Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: compact ? 6 : 10,
                        vertical: compact ? 6 : 12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(flex: 2),

                          // Center Cute Icon with white circular badge
                          Container(
                            padding: EdgeInsets.all(compact ? 10 : 16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.92),
                              boxShadow: [
                                BoxShadow(
                                  color: notebook.spineColor.withValues(alpha: 0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              notebook.icon,
                              size: compact ? 22 : 36,
                              color: notebook.iconColor,
                            ),
                          ),

                          SizedBox(height: compact ? 6 : 10),

                          // Notebook Title
                          Text(
                            notebook.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: compact ? 11 : 14.5,
                              fontWeight: FontWeight.w700,
                              color: config.textDark,
                              height: 1.2,
                            ),
                          ),

                          const Spacer(flex: 3),

                          // Page count at bottom
                          if (!compact)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.auto_stories_outlined,
                                  size: 12,
                                  color: config.textMuted.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${notebook.pageCount} sayfa',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: config.textMuted.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Page edge layer on right
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F6EE),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 2,
                          offset: const Offset(-1, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Paints organic blob/wave shapes on the notebook cover
class _CoverBlobPainter extends CustomPainter {
  final Color accentColor;
  final Color spineColor;

  _CoverBlobPainter({required this.accentColor, required this.spineColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Blob 1: Large organic shape at top-right
    final blob1Paint = Paint()
      ..color = accentColor.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;
    final blob1 = Path();
    blob1.moveTo(size.width * 0.55, 0);
    blob1.cubicTo(
      size.width * 0.65, size.height * 0.15,
      size.width * 1.1, size.height * 0.10,
      size.width, size.height * 0.30,
    );
    blob1.lineTo(size.width, 0);
    blob1.close();
    canvas.drawPath(blob1, blob1Paint);

    // Blob 2: Bottom-left organic wave
    final blob2Paint = Paint()
      ..color = accentColor.withValues(alpha: 0.40)
      ..style = PaintingStyle.fill;
    final blob2 = Path();
    blob2.moveTo(0, size.height * 0.60);
    blob2.cubicTo(
      size.width * 0.20, size.height * 0.55,
      size.width * 0.35, size.height * 0.75,
      size.width * 0.55, size.height * 0.65,
    );
    blob2.cubicTo(
      size.width * 0.70, size.height * 0.58,
      size.width * 0.85, size.height * 0.70,
      size.width, size.height * 0.65,
    );
    blob2.lineTo(size.width, size.height);
    blob2.lineTo(0, size.height);
    blob2.close();
    canvas.drawPath(blob2, blob2Paint);

    // Blob 3: Small decorative circle top-left area
    final blob3Paint = Paint()
      ..color = spineColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.30, size.height * 0.20),
      size.width * 0.12,
      blob3Paint,
    );

    // Blob 4: Medium accent shape at mid-right
    final blob4Paint = Paint()
      ..color = accentColor.withValues(alpha: 0.30)
      ..style = PaintingStyle.fill;
    final blob4 = Path();
    blob4.moveTo(size.width * 0.75, size.height * 0.35);
    blob4.cubicTo(
      size.width * 0.90, size.height * 0.30,
      size.width * 1.05, size.height * 0.45,
      size.width * 0.85, size.height * 0.55,
    );
    blob4.cubicTo(
      size.width * 0.70, size.height * 0.60,
      size.width * 0.65, size.height * 0.40,
      size.width * 0.75, size.height * 0.35,
    );
    blob4.close();
    canvas.drawPath(blob4, blob4Paint);
  }

  @override
  bool shouldRepaint(covariant _CoverBlobPainter oldDelegate) {
    return oldDelegate.accentColor != accentColor || oldDelegate.spineColor != spineColor;
  }
}

/// Paints the decorative pattern on the notebook spine
class _SpinePatternPainter extends CustomPainter {
  final SpinePattern pattern;
  final Color color;
  final bool compact;

  _SpinePatternPainter({
    required this.pattern,
    required this.color,
    this.compact = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    switch (pattern) {
      case SpinePattern.hearts:
        _drawHearts(canvas, size, paint);
        break;
      case SpinePattern.lines:
        _drawLines(canvas, size, strokePaint);
        break;
      case SpinePattern.diagonal:
        _drawDiagonal(canvas, size, strokePaint);
        break;
      case SpinePattern.grid:
        _drawGrid(canvas, size, strokePaint);
        break;
      case SpinePattern.dots:
        _drawDots(canvas, size, paint);
        break;
      case SpinePattern.stars:
        _drawStars(canvas, size, paint);
        break;
      case SpinePattern.waves:
        _drawWaves(canvas, size, strokePaint);
        break;
      case SpinePattern.zigzag:
        _drawZigzag(canvas, size, strokePaint);
        break;
    }
  }

  void _drawHearts(Canvas canvas, Size size, Paint paint) {
    final count = compact ? 5 : 8;
    final spacing = size.height / (count + 1);
    for (int i = 1; i <= count; i++) {
      final y = i * spacing;
      final heartSize = compact ? 3.0 : 4.0;
      _drawHeart(canvas, Offset(size.width / 2, y), heartSize, paint);
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double s, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy + s * 0.5);
    path.cubicTo(
      center.dx - s, center.dy - s * 0.2,
      center.dx - s * 0.5, center.dy - s,
      center.dx, center.dy - s * 0.3,
    );
    path.cubicTo(
      center.dx + s * 0.5, center.dy - s,
      center.dx + s, center.dy - s * 0.2,
      center.dx, center.dy + s * 0.5,
    );
    canvas.drawPath(path, paint);
  }

  void _drawLines(Canvas canvas, Size size, Paint paint) {
    final count = compact ? 8 : 12;
    final spacing = size.height / (count + 1);
    for (int i = 1; i <= count; i++) {
      final y = i * spacing;
      canvas.drawLine(
        Offset(size.width * 0.2, y),
        Offset(size.width * 0.8, y),
        paint,
      );
    }
  }

  void _drawDiagonal(Canvas canvas, Size size, Paint paint) {
    final count = compact ? 10 : 16;
    final gap = size.height / count;
    for (int i = -2; i < count + 2; i++) {
      canvas.drawLine(
        Offset(0, i * gap),
        Offset(size.width, i * gap - size.width),
        paint,
      );
    }
  }

  void _drawGrid(Canvas canvas, Size size, Paint paint) {
    final cellSize = compact ? 5.0 : 7.0;
    final cols = (size.width / cellSize).ceil();
    final rows = (size.height / cellSize).ceil();
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if ((r + c) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize),
            Paint()..color = color.withValues(alpha: 0.35),
          );
        }
      }
    }
  }

  void _drawDots(Canvas canvas, Size size, Paint paint) {
    final count = compact ? 6 : 10;
    final spacing = size.height / (count + 1);
    for (int i = 1; i <= count; i++) {
      final y = i * spacing;
      canvas.drawCircle(Offset(size.width / 2, y), compact ? 2.0 : 2.5, paint);
    }
  }

  void _drawStars(Canvas canvas, Size size, Paint paint) {
    final count = compact ? 5 : 8;
    final spacing = size.height / (count + 1);
    for (int i = 1; i <= count; i++) {
      final y = i * spacing;
      _drawStar(canvas, Offset(size.width / 2, y), compact ? 3.0 : 4.0, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      final midAngle = angle + math.pi / 4;
      final mx = center.dx + math.cos(midAngle) * (radius * 0.4);
      final my = center.dy + math.sin(midAngle) * (radius * 0.4);
      path.lineTo(mx, my);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawWaves(Canvas canvas, Size size, Paint paint) {
    final count = compact ? 6 : 10;
    final spacing = size.height / (count + 1);
    for (int i = 1; i <= count; i++) {
      final y = i * spacing;
      final path = Path();
      path.moveTo(0, y);
      path.quadraticBezierTo(
        size.width * 0.3, y - 3,
        size.width * 0.5, y,
      );
      path.quadraticBezierTo(
        size.width * 0.7, y + 3,
        size.width, y,
      );
      canvas.drawPath(path, paint);
    }
  }

  void _drawZigzag(Canvas canvas, Size size, Paint paint) {
    final count = compact ? 8 : 14;
    final spacing = size.height / (count + 1);
    final path = Path();
    path.moveTo(size.width * 0.2, spacing);
    for (int i = 1; i <= count; i++) {
      final y = i * spacing;
      if (i % 2 == 0) {
        path.lineTo(size.width * 0.2, y);
      } else {
        path.lineTo(size.width * 0.8, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SpinePatternPainter oldDelegate) {
    return oldDelegate.pattern != pattern || oldDelegate.color != color;
  }
}
