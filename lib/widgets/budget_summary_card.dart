import 'package:budgetfrontend/widgets/dual_arc_painter.dart';
import 'package:flutter/material.dart';

class BudgetSummaryCard extends StatelessWidget {
  final double familyTotal;
  final double familyUsed;
  final double privateTotal;
  final double privateUsed;

  const BudgetSummaryCard({
    super.key,
    required this.familyTotal,
    required this.familyUsed,
    required this.privateTotal,
    required this.privateUsed,
  });
  
  get children => null;

  @override
  Widget build(BuildContext context) {
    final maxTotal = [
      familyTotal,
      privateTotal,
    ].reduce((a, b) => a > b ? a : b);
    final double familyPercent = maxTotal == 0 ? 0 : familyUsed / maxTotal;
    final double privatePercent = maxTotal == 0 ? 0 : privateUsed / maxTotal;

    return DualBudgetArc(
              familyPercent: familyPercent,
              privatePercent: privatePercent, );
  }
   Widget _buildStatusRow(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color.withOpacity(0.7)),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class DualBudgetArc extends StatelessWidget {
  final double familyPercent;
  final double privatePercent;

  const DualBudgetArc({
    super.key,
    required this.familyPercent,
    required this.privatePercent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: CustomPaint(
        painter: DualArcPainter(
          outerPercentage: familyPercent,
          innerPercentage: privatePercent,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Icon(Icons.group, color: Colors.white, size: 20),
    const SizedBox(width: 6),
    Text(
      "${(familyPercent * 100).toStringAsFixed(0)}%",
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),
Row(
   mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Icon(Icons.person, color: Colors.white, size: 20),
    const SizedBox(width: 6),
    Text(
      "${(privatePercent * 100).toStringAsFixed(0)}%",
      style: const TextStyle(color: Colors.white),
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
