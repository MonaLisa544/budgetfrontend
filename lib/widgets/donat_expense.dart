import 'package:flutter/material.dart';
import 'dart:math';

class InteractiveGlossyDonutChart extends StatefulWidget {
  const InteractiveGlossyDonutChart({Key? key}) : super(key: key);

  @override
  State<InteractiveGlossyDonutChart> createState() => _InteractiveGlossyDonutChartState();
}

class _InteractiveGlossyDonutChartState extends State<InteractiveGlossyDonutChart> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset local = renderBox.globalToLocal(details.globalPosition);
        final result = GlossyDonutPainter.hitTestSlice(local, renderBox.size);
        setState(() {
          selectedIndex = (result == selectedIndex) ? null : result;
        });
      },
      child: Center(
        child: SizedBox(
          width: 300,
          height: 150,
          child: CustomPaint(
            painter: GlossyDonutPainter(selectedIndex: selectedIndex),
          ),
        ),
      ),
    );
  }
}

class GlossyDonutPainter extends CustomPainter {
  final int? selectedIndex;

  GlossyDonutPainter({this.selectedIndex});

  // Data
  final List<double> values = [50, 22, 4, 10, 9, 5];
  final List<Color> colors = [
    Color(0xFF1DAEFF),
    Color(0xFF7B55FD),
    Color(0xFF72FAFE),
    Color(0xFFEB4E9E),
    Color(0xFFD249D2),
    Color(0xFF65F7A4),
  ];
  final List<String> labels = [
    'Market\n50%',
    'Rewards Pool\n22%',
    'Advisors\n4%',
    'Founders\n10%',
    'Partners\n9%',
    'Bounties\n5%',
  ];
  final List<Color> labelColors = [
    Color(0xFF3DC0FF),
    Color(0xFF8660FE),
    Color(0xFF57E9FF),
    Color(0xFFF760B1),
    Color(0xFFD36CD7),
    Color(0xFF7BFEC1),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    double total = values.reduce((a, b) => a + b);
    final center = Offset(size.width / 2, size.height / 2 + 8);
    final outerRx = size.width / 2 - 10;
    final outerRy = size.height / 2 - 12;
    final innerRx = outerRx * 0.62;
    final innerRy = outerRy * 0.62;
    const extrudeDepth = 14.0;

    double startAngle = -pi / 2;

    // 3D shadow effect (доошоо)
    for (int j = 0; j < extrudeDepth; j++) {
      double shadowAlpha = 0.13 + (0.14 * (1 - j / extrudeDepth));
      double yOffset = j.toDouble();
      double start = startAngle;
      for (int i = 0; i < values.length; i++) {
        final sweep = (values[i] / total) * 2 * pi;
        final paintShadow = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = outerRy - innerRy
          ..color = colors[i].withOpacity(shadowAlpha);
        canvas.save();
        canvas.translate(center.dx, center.dy + yOffset);
        canvas.drawArc(
          Rect.fromCenter(center: Offset(0, 0), width: outerRx * 2, height: outerRy * 2),
          start,
          sweep,
          false,
          paintShadow,
        );
        canvas.restore();
        start += sweep;
      }
    }

    // Тухайн slice-ийн заагийг илүү тод харуулах (border)
    startAngle = -pi / 2;
    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * pi;

      // Томруулах эффект (hover/tap)
      double scale = (selectedIndex == i) ? 1.12 : 1.0;
      double hoverOuterRx = outerRx * scale;
      double hoverOuterRy = outerRy * scale;
      double hoverInnerRx = innerRx * scale;
      double hoverInnerRy = innerRy * scale;

      // **Glossy градиент**
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt
        ..strokeWidth = hoverOuterRy - hoverInnerRy
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.33),
            colors[i].withOpacity(1),
            colors[i].withOpacity(0.64),
          ],
          stops: [0.01, 0.5, 1],
        ).createShader(Rect.fromCenter(center: center, width: size.width, height: size.height));

      // Main slice
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.drawArc(
        Rect.fromCenter(center: Offset(0, 0), width: hoverOuterRx * 2, height: hoverOuterRy * 2),
        startAngle,
        sweep,
        false,
        paint,
      );
      canvas.restore();

      // Slice border - white thin line
      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.14)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke;
      final borderRect = Rect.fromCenter(center: center, width: hoverOuterRx * 2, height: hoverOuterRy * 2);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.drawArc(borderRect, startAngle, sweep, false, borderPaint);
      canvas.restore();

      // Annotation болон Label-ууд
      final angle = startAngle + sweep / 2;
      final labelRadius = hoverOuterRx + 22;
      final labelX = center.dx + labelRadius * cos(angle);
      final labelY = center.dy + labelRadius * sin(angle) * 0.79;
      final anchorX = center.dx + hoverOuterRx * cos(angle);
      final anchorY = center.dy + hoverOuterRy * sin(angle);

      final annotationPaint = Paint()
        ..color = labelColors[i].withOpacity(0.79)
        ..strokeWidth = 1.3;
      canvas.drawLine(
        Offset(anchorX, anchorY),
        Offset(labelX, labelY),
        annotationPaint,
      );
      canvas.drawCircle(Offset(labelX, labelY), 2.6, annotationPaint);

      final textSpan = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: labelColors[i],
          fontSize: 12,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.28),
              offset: Offset(0.7, 1.2),
              blurRadius: 3.5,
            )
          ],
        ),
      );
      final tp = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout(maxWidth: 65);

      tp.paint(
        canvas,
        Offset(labelX - tp.width / 2, labelY - tp.height - 2),
      );

      startAngle += sweep;
    }

    // **Highlight top (shine) effect**
    final shinePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.16),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCenter(center: center, width: size.width, height: size.height / 2));
    canvas.drawArc(
      Rect.fromCenter(center: center, width: outerRx * 2, height: outerRy * 2),
      -pi / 1.4,
      pi / 1.7,
      false,
      shinePaint..strokeWidth = (outerRy - innerRy) * 1.12..style = PaintingStyle.stroke,
    );

    // Inner Hole
    final holePaint = Paint()
      ..color = Colors.black.withOpacity(0.76)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: center, width: innerRx * 2, height: innerRy * 2),
      holePaint,
    );

    // Center text
    TextSpan span = const TextSpan(
        style: TextStyle(
            color: Colors.white70,
            fontSize: 27,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 4,
                offset: Offset(0, 1.2),
              ),
            ]),
        text: '\$183.6K');
    TextPainter tp = TextPainter(
        text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant GlossyDonutPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;

  // === Hit test ===
  static int? hitTestSlice(Offset position, Size size) {
    final values = [50, 22, 4, 10, 9, 5];
    final total = values.reduce((a, b) => a + b);

    final center = Offset(size.width / 2, size.height / 2 + 8);
    final outerRx = size.width / 2 - 10;
    final outerRy = size.height / 2 - 12;
    final innerRx = outerRx * 0.62;
    final innerRy = outerRy * 0.62;

    final dx = (position.dx - center.dx);
    final dy = (position.dy - center.dy);

    final inOuter = ((dx * dx) / (outerRx * outerRx)) + ((dy * dy) / (outerRy * outerRy)) <= 1;
    final inInner = ((dx * dx) / (innerRx * innerRx)) + ((dy * dy) / (innerRy * innerRy)) <= 1;
    if (!inOuter || inInner) return null;

    double theta = atan2(dy, dx);
    if (theta < -pi / 2) theta += 2 * pi;
    theta += pi / 2;

    double startAngle = 0.0;
    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * pi;
      if (theta >= startAngle && theta < startAngle + sweep) {
        return i;
      }
      startAngle += sweep;
    }
    return null;
  }
}
