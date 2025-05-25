import 'package:flutter/material.dart';

class FancyBubbleChart extends StatelessWidget {
  final List<BubbleData> data;
  const FancyBubbleChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240, // өндөр хүссэнээрээ тохируулна
      width: double.infinity,
      child: CustomPaint(
        painter: _FancyBubblePainter(data),
      ),
    );
  }
}

class BubbleData {
  final String label;
  final double percent;
  final Color color;
  BubbleData(this.label, this.percent, this.color);
}

class _FancyBubblePainter extends CustomPainter {
  final List<BubbleData> data;
  _FancyBubblePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    // Байршлыг зураг шиг зурах
    final List<Offset> centers = [
      Offset(size.width * 0.38, size.height * 0.53),
      Offset(size.width * 0.59, size.height * 0.44),
      Offset(size.width * 0.51, size.height * 0.72),
    ];

    final List<double> radii = [70, 48, 35]; // Харьцуулж тохируулна

    // Glow болон overlap effect
    for (int i = 0; i < data.length; i++) {
      var shadowPaint = Paint()
        ..color = data[i].color.withOpacity(0.32)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 18);
      canvas.drawCircle(centers[i], radii[i] + 8, shadowPaint);
    }

    // Bubble-үүдээ зурна
    for (int i = 0; i < data.length; i++) {
      var paint = Paint()
        ..shader = RadialGradient(
          colors: [
            data[i].color.withOpacity(0.85),
            data[i].color.withOpacity(0.38)
          ],
          center: Alignment.center,
          radius: 0.95,
        ).createShader(Rect.fromCircle(center: centers[i], radius: radii[i]));
      canvas.drawCircle(centers[i], radii[i], paint);
    }

    // Контур, intersect circles, шугам зурна
    final linePaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    // Бүх bubble-д хүрээ болон cross-circles (жижиг хүрээ) зурна
    for (int i = 0; i < centers.length; i++) {
      canvas.drawCircle(centers[i], radii[i], linePaint);
      canvas.drawCircle(centers[i], radii[i] + 18, linePaint..color = Colors.white10);
    }

    // Текстүүд
    final labels = [
      Offset(size.width * 0.13, size.height * 0.43),
      Offset(size.width * 0.78, size.height * 0.23),
      Offset(size.width * 0.68, size.height * 0.75),
    ];
    final percents = [45, 30, 25];

    for (int i = 0; i < data.length; i++) {
      final textSpan = TextSpan(
        text: "${data[i].label}\n${percents[i]}%",
        style: TextStyle(
          color: Colors.white.withOpacity(i == 0 ? 0.95 : 0.88),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      final tp = TextPainter(
        text: textSpan,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, labels[i]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
