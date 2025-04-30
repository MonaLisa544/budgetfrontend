import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart'; // нэмэх хэрэгтэй

class BillsCircleCard extends StatelessWidget {
  final double percent;
  final String amount;
  final String label;

  const BillsCircleCard({
    super.key,
    required this.percent,
    required this.amount,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
  radius: 100.0,
  lineWidth: 16.0,
  animation: true,
  percent: percent,
  circularStrokeCap: CircularStrokeCap.round,
  backgroundColor: Colors.grey.withOpacity(0.2),
  progressColor: Colors.lightBlueAccent, // 👈 Ганц өнгө
  center: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        amount,
        style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: TextStyle(fontSize: 14.0, color: Colors.white70),
      ),
    ],
  ),
)
    );
  }
}