import 'package:budgetfrontend/views/budgets/add_budget_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCategoryDashedBox extends StatelessWidget {
  final VoidCallback onTap;

  const AddCategoryDashedBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
    	Get.to(() => AddBudgetView());
  },
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Шинэ төсөв нэмэх',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(width: 8),
              Icon(Icons.add_circle_outline, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(12),
      ));

    drawDashedPath(canvas, path, paint, dashWidth, dashSpace);
  }

  void drawDashedPath(Canvas canvas, Path path, Paint paint, double dashWidth, double dashSpace) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, distance + length),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}