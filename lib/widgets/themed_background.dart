import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_config.dart';

/// Full-screen ambient atmospheric background tailored to each theme
/// matching the user's 5 reference designs with high visual fidelity.
class ThemedBackground extends StatelessWidget {
  final Widget child;

  const ThemedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeType>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, themeType, _) {
        final config = ThemeConfig.fromType(themeType);

        return Stack(
          children: [
            // Layer 1: Atmospheric gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: config.backgroundGradient,
                ),
              ),
            ),

            // Layer 2: Custom illustration / decorative elements per theme
            Positioned.fill(
              child: CustomPaint(
                painter: _AtmosphericPainter(type: themeType),
              ),
            ),

            // Layer 3: Main Screen Content
            Positioned.fill(child: child),
          ],
        );
      },
    );
  }
}

class _AtmosphericPainter extends CustomPainter {
  final AppThemeType type;

  _AtmosphericPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case AppThemeType.sunsetGlow:
        _drawSunsetAtmosphere(canvas, size);
        break;
      case AppThemeType.cosmicDream:
        _drawCosmicAtmosphere(canvas, size);
        break;
      case AppThemeType.botanical:
        _drawBotanicalAtmosphere(canvas, size);
        break;
      case AppThemeType.sakura:
        _drawSakuraAtmosphere(canvas, size);
        break;
      case AppThemeType.neonGlass:
        _drawNeonAtmosphere(canvas, size);
        break;
      case AppThemeType.pastelDream:
        _drawPastelAtmosphere(canvas, size);
        break;
    }
  }

  // --- 1. Sunset Atmosphere (Image 1) ---
  void _drawSunsetAtmosphere(Canvas canvas, Size size) {
    // 1. Soft glowing sun in top-center
    final sunCenter = Offset(size.width * 0.52, size.height * 0.17);
    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF1C5).withValues(alpha: 0.95),
          const Color(0xFFFFD59E).withValues(alpha: 0.6),
          const Color(0xFFFFB088).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: 85));
    canvas.drawCircle(sunCenter, 85, sunPaint);

    // 2. Rolling hills at bottom
    final hillPaint1 = Paint()
      ..color = const Color(0xFFC95B72).withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;
    final path1 = Path();
    path1.moveTo(0, size.height * 0.88);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.84,
      size.width * 0.55,
      size.height * 0.87,
    );
    path1.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.89,
      size.width,
      size.height * 0.85,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, hillPaint1);

    final hillPaint2 = Paint()
      ..color = const Color(0xFF883850).withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;
    final path2 = Path();
    path2.moveTo(0, size.height * 0.92);
    path2.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.94,
      size.width * 0.7,
      size.height * 0.91,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.89,
      size.width,
      size.height * 0.93,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, hillPaint2);

    // 3. Tiny cute flying birds
    _drawBird(canvas, Offset(size.width * 0.65, size.height * 0.14), 10);
    _drawBird(canvas, Offset(size.width * 0.68, size.height * 0.16), 7);
  }

  void _drawBird(Canvas canvas, Offset pos, double s) {
    final birdPaint = Paint()
      ..color = const Color(0xFF883850).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final p = Path();
    p.moveTo(pos.dx - s, pos.dy + s * 0.3);
    p.quadraticBezierTo(pos.dx - s * 0.5, pos.dy - s * 0.3, pos.dx, pos.dy);
    p.quadraticBezierTo(
      pos.dx + s * 0.5,
      pos.dy - s * 0.3,
      pos.dx + s,
      pos.dy + s * 0.3,
    );
    canvas.drawPath(p, birdPaint);
  }

  // --- 2. Cosmic Atmosphere (Image 2) ---
  void _drawCosmicAtmosphere(Canvas canvas, Size size) {
    // Glowing moon in top right / left
    final moonCenter = Offset(size.width * 0.88, size.height * 0.12);
    final moonHalo = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFDE8BB).withValues(alpha: 0.4),
          const Color(0xFFD8B4F8).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: moonCenter, radius: 45));
    canvas.drawCircle(moonCenter, 45, moonHalo);

    // Crescent moon
    final moonPaint = Paint()..color = const Color(0xFFFFF2D6);
    final moonPath = Path();
    moonPath.addArc(
      Rect.fromCircle(center: moonCenter, radius: 22),
      -math.pi / 2,
      math.pi,
    );
    moonPath.arcTo(
      Rect.fromCircle(center: moonCenter.translate(9, -2), radius: 20),
      math.pi / 2,
      -math.pi,
      false,
    );
    moonPath.close();
    canvas.drawPath(moonPath, moonPaint);

    // Glowing stardust sparkles
    _drawSparkle(canvas, Offset(size.width * 0.15, size.height * 0.18), 7, const Color(0xFFFFF2D6));
    _drawSparkle(canvas, Offset(size.width * 0.82, size.height * 0.22), 6, const Color(0xFFD8B4F8));
    _drawSparkle(canvas, Offset(size.width * 0.08, size.height * 0.45), 5, const Color(0xFFFFF2D6));
    _drawSparkle(canvas, Offset(size.width * 0.92, size.height * 0.65), 8, const Color(0xFFFDE8BB));
    _drawSparkle(canvas, Offset(size.width * 0.12, size.height * 0.85), 6, const Color(0xFFD8B4F8));

    // Stardust dots
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.65);
    final randomStars = [
      Offset(size.width * 0.3, size.height * 0.08),
      Offset(size.width * 0.7, size.height * 0.10),
      Offset(size.width * 0.45, size.height * 0.15),
      Offset(size.width * 0.25, size.height * 0.35),
      Offset(size.width * 0.88, size.height * 0.40),
      Offset(size.width * 0.78, size.height * 0.82),
      Offset(size.width * 0.35, size.height * 0.90),
    ];
    for (final star in randomStars) {
      canvas.drawCircle(star, 1.8, starPaint);
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, double size, Color color) {
    final p = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.quadraticBezierTo(center.dx, center.dy, center.dx + size, center.dy);
    path.quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + size);
    path.quadraticBezierTo(center.dx, center.dy, center.dx - size, center.dy);
    path.quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - size);
    canvas.drawPath(path, p);
  }

  // --- 3. Botanical Atmosphere (Image 3) ---
  void _drawBotanicalAtmosphere(Canvas canvas, Size size) {
    // Eucalyptus branch at top right
    final leafPaint = Paint()
      ..color = const Color(0xFF52796F).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    final stemPaint = Paint()
      ..color = const Color(0xFF354F52).withValues(alpha: 0.4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final start = Offset(size.width * 1.05, size.height * 0.05);
    final end = Offset(size.width * 0.78, size.height * 0.16);

    final stem = Path();
    stem.moveTo(start.dx, start.dy);
    stem.quadraticBezierTo(
      size.width * 0.92,
      size.height * 0.10,
      end.dx,
      end.dy,
    );
    canvas.drawPath(stem, stemPaint);

    // Leaves along the stem
    _drawLeaf(canvas, Offset(size.width * 0.82, size.height * 0.14), -0.6, leafPaint);
    _drawLeaf(canvas, Offset(size.width * 0.86, size.height * 0.11), 0.5, leafPaint);
    _drawLeaf(canvas, Offset(size.width * 0.92, size.height * 0.08), -0.5, leafPaint);
    _drawLeaf(canvas, Offset(size.width * 0.96, size.height * 0.06), 0.4, leafPaint);

    // Soft organic wave at bottom left
    final wavePaint = Paint()
      ..color = const Color(0xFF87A987).withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    final wave = Path();
    wave.moveTo(0, size.height * 0.85);
    wave.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.82,
      size.width * 0.5,
      size.height,
    );
    wave.lineTo(0, size.height);
    wave.close();
    canvas.drawPath(wave, wavePaint);
  }

  void _drawLeaf(Canvas canvas, Offset center, double angle, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final leaf = Path();
    leaf.moveTo(0, -18);
    leaf.quadraticBezierTo(10, 0, 0, 18);
    leaf.quadraticBezierTo(-10, 0, 0, -18);
    canvas.drawPath(leaf, paint);
    canvas.restore();
  }

  // --- 4. Sakura Blossom Atmosphere (Image 4) ---
  void _drawSakuraAtmosphere(Canvas canvas, Size size) {
    // 1. Mount Fuji silhouette at top center
    final fujiPaint = Paint()
      ..color = const Color(0xFFC78F9A).withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;

    final fujiPath = Path();
    fujiPath.moveTo(size.width * 0.35, size.height * 0.22);
    fujiPath.lineTo(size.width * 0.65, size.height * 0.15); // Peak
    fujiPath.lineTo(size.width * 0.75, size.height * 0.15);
    fujiPath.lineTo(size.width * 0.95, size.height * 0.22);
    fujiPath.lineTo(size.width * 0.95, size.height * 0.26);
    fujiPath.lineTo(size.width * 0.35, size.height * 0.26);
    fujiPath.close();
    canvas.drawPath(fujiPath, fujiPaint);

    // Rising Red Sun behind Fuji
    final sunCenter = Offset(size.width * 0.70, size.height * 0.16);
    final sunPaint = Paint()
      ..color = const Color(0xFFE5697A).withValues(alpha: 0.45);
    canvas.drawCircle(sunCenter, 32, sunPaint);

    // 2. Sakura branch top right
    final branchPaint = Paint()
      ..color = const Color(0xFF7A454D).withValues(alpha: 0.45)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;
    final bPath = Path();
    bPath.moveTo(size.width * 1.05, size.height * 0.11);
    bPath.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.13,
      size.width * 0.8,
      size.height * 0.17,
    );
    canvas.drawPath(bPath, branchPaint);

    // Sakura blossoms
    _drawSakuraFlower(canvas, Offset(size.width * 0.82, size.height * 0.16), 9);
    _drawSakuraFlower(canvas, Offset(size.width * 0.88, size.height * 0.13), 8);
    _drawSakuraFlower(canvas, Offset(size.width * 0.95, size.height * 0.10), 10);

    // Floating petals in wind
    _drawPetal(canvas, Offset(size.width * 0.74, size.height * 0.20), 0.4);
    _drawPetal(canvas, Offset(size.width * 0.45, size.height * 0.18), -0.3);
    _drawPetal(canvas, Offset(size.width * 0.18, size.height * 0.35), 0.6);
  }

  void _drawSakuraFlower(Canvas canvas, Offset center, double radius) {
    final petalPaint = Paint()..color = const Color(0xFFFFB6C1).withValues(alpha: 0.85);
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi) / 5;
      final petalCenter = Offset(
        center.dx + math.cos(angle) * (radius * 0.7),
        center.dy + math.sin(angle) * (radius * 0.7),
      );
      canvas.drawCircle(petalCenter, radius * 0.55, petalPaint);
    }
    final centerPaint = Paint()..color = const Color(0xFFE25569);
    canvas.drawCircle(center, radius * 0.3, centerPaint);
  }

  void _drawPetal(Canvas canvas, Offset center, double angle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final pPaint = Paint()..color = const Color(0xFFFFB6C1).withValues(alpha: 0.65);
    final path = Path();
    path.moveTo(0, -6);
    path.quadraticBezierTo(4, 0, 0, 6);
    path.quadraticBezierTo(-4, 0, 0, -6);
    canvas.drawPath(path, pPaint);
    canvas.restore();
  }

  // --- 5. Neon Atmosphere (Image 5) ---
  void _drawNeonAtmosphere(Canvas canvas, Size size) {
    // Glowing ambient neon orbs
    _drawNeonOrb(canvas, Offset(size.width * 0.85, size.height * 0.15), 110, const Color(0xFF7C3AED));
    _drawNeonOrb(canvas, Offset(size.width * 0.12, size.height * 0.45), 130, const Color(0xFF06B6D4));
    _drawNeonOrb(canvas, Offset(size.width * 0.75, size.height * 0.85), 140, const Color(0xFFEC4899));
  }

  void _drawNeonOrb(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.28),
          color.withValues(alpha: 0.10),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  // --- 6. Pastel Atmosphere (Original) ---
  void _drawPastelAtmosphere(Canvas canvas, Size size) {
    // Gentle floating pastel orbs
    final p1 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFC8B6FF).withValues(alpha: 0.18),
          const Color(0xFFC8B6FF).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.8, size.height * 0.2), radius: 100));
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 100, p1);

    final p2 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFD6E0).withValues(alpha: 0.18),
          const Color(0xFFFFD6E0).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.2, size.height * 0.7), radius: 120));
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.7), 120, p2);
  }

  @override
  bool shouldRepaint(covariant _AtmosphericPainter oldDelegate) {
    return oldDelegate.type != type;
  }
}
