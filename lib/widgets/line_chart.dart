import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TransactionLineChart extends StatelessWidget {
  const TransactionLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
                if (value.toInt() < months.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      months[value.toInt()],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              getTitlesWidget: (value, _) => Text('\$${value.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 10)),
              reservedSize: 40,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 200),
              FlSpot(1, 450),
              FlSpot(2, 600),
              FlSpot(3, 300),
              FlSpot(4, 500),
              FlSpot(5, 800),
            ],
            isCurved: true,
            color: Colors.greenAccent,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
          LineChartBarData(
            spots: [
              FlSpot(0, 150),
              FlSpot(1, 300),
              FlSpot(2, 400),
              FlSpot(3, 250),
              FlSpot(4, 350),
              FlSpot(5, 500),
            ],
            isCurved: true,
            color: Colors.redAccent,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
