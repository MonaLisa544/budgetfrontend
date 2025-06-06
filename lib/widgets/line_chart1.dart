// // lib/widgets/line_chart.dart

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class TransactionLineChart extends StatelessWidget {
//   final List<double> incomes;
//   final List<double> expenses;
//   final List<String> labels;

//   const TransactionLineChart({
//     super.key,
//     required this.incomes,
//     required this.expenses,
//     required this.labels,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(top: 4),
//       elevation: 1.5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: LineChart(
//           LineChartData(
//             gridData: FlGridData(show: true, horizontalInterval: 1),
//             titlesData: FlTitlesData(
//               leftTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: (v, meta) => Text('${v.toInt()}₮', style: TextStyle(fontSize: 12)),
//                   reservedSize: 40,
//                   interval: ([
//                     ...incomes,
//                     ...expenses,
//                   ].fold<double>(0, (max, v) => v > max ? v : max) / 5).ceilToDouble().clamp(1, double.infinity),
//                 ),
//               ),
//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: (v, meta) {
//                     int i = v.toInt();
//                     return i >= 0 && i < labels.length
//                         ? Text(labels[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
//                         : SizedBox.shrink();
//                   },
//                   interval: 1,
//                 ),
//               ),
//               topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//               rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             ),
//             minX: 0,
//             maxX: (labels.length - 1).toDouble(),
//             minY: 0,
//             lineBarsData: [
//               // Орлого (ногоон)
//               LineChartBarData(
//                 spots: List.generate(incomes.length, (i) => FlSpot(i.toDouble(), incomes[i])),
//                 isCurved: true,
//                 color: Colors.green,
//                 barWidth: 3,
//                 belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.07)),
//                 dotData: FlDotData(show: false),
//                 gradient: const LinearGradient(colors: [Colors.green, Colors.lightGreen]),
//               ),
//               // Зарлага (улаан)
//               LineChartBarData(
//                 spots: List.generate(expenses.length, (i) => FlSpot(i.toDouble(), expenses[i])),
//                 isCurved: true,
//                 color: Colors.red,
//                 barWidth: 3,
//                 belowBarData: BarAreaData(show: true, color: Colors.redAccent.withOpacity(0.07)),
//                 dotData: FlDotData(show: false),
//                 gradient: const LinearGradient(colors: [Colors.red, Colors.orangeAccent]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
