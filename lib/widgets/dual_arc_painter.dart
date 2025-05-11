import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'common/color_extension.dart'; // TColor.*** ашиглаж байвал

class DualArcPainter extends CustomPainter {
  final double outerPercentage; // Family
  final double innerPercentage; // Private
  final double width;

  DualArcPainter({
    required this.outerPercentage,
    required this.innerPercentage,
    this.width = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2.5;
    final innerRadius = outerRadius - width - 8;

    // === OUTER ARC ===
    final outerRect = Rect.fromCircle(center: center, radius: outerRadius);
    final outerStart = vmath.radians(135);
    final outerSweep = vmath.radians(270 * outerPercentage.clamp(0.0, 1.0));

    // BACKGROUND (outer)
    canvas.drawArc(
      outerRect,
      outerStart,
      vmath.radians(270),
      false,
      Paint()
        ..color = TColor.gray60.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width,
    );

    // SHADOW GLOW (outer)
    final outerPath = Path()..addArc(outerRect, outerStart, outerSweep);
    canvas.drawPath(
      outerPath,
      Paint()
        ..color = TColor.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width + 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // ACTIVE ARC (outer)
    final outerPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color.fromARGB(255, 110, 188, 236), TColor.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(outerRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(outerRect, outerStart, outerSweep, false, outerPaint);

    // === INNER ARC ===
    final innerRect = Rect.fromCircle(center: center, radius: innerRadius);
    final innerStart = vmath.radians(135);
    final innerSweep = vmath.radians(270 * innerPercentage.clamp(0.0, 1.0));

    // BACKGROUND (inner)
    canvas.drawArc(
      innerRect,
      innerStart,
      vmath.radians(270),
      false,
      Paint()
        ..color = TColor.gray60.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width,
    );

    // SHADOW GLOW (inner)
    final innerPath = Path()..addArc(innerRect, innerStart, innerSweep);
    canvas.drawPath(
      innerPath,
      Paint()
        ..color = TColor.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width + 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // ACTIVE ARC (inner)
    final innerPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color.fromARGB(255, 110, 188, 236), TColor.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(innerRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(innerRect, innerStart, innerSweep, false, innerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
