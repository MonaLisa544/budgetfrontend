import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  int? touchedIncomeIndex;
  int? touchedExpenseIndex;
  String selectedMonth = "2025-05";

  // Dummy data - Та динамикаар серверээс авч болно
  final List<String> months = ["2025-04", "2025-05", "2025-06"];
  final List<CategoryExpense> incomes = [
    CategoryExpense("Цалин", 2500000, Colors.greenAccent),
    CategoryExpense("Бонус", 500000, Colors.orangeAccent),
    CategoryExpense("Хадгаламж", 200000, Colors.lightBlueAccent),
  ];
  final List<CategoryExpense> expenses = [
    CategoryExpense("Хоол хүнс", 1200000, Colors.orange),
    CategoryExpense("Тээвэр", 350000, Colors.green),
    CategoryExpense("Орон сууц", 800000, Colors.blue),
    CategoryExpense("Эрүүл мэнд", 250000, Colors.redAccent),
    CategoryExpense("Зугаа цэнгэл", 100000, Colors.purple),
  ];

  double get totalIncome => incomes.fold(0, (sum, e) => sum + e.amount);
  double get totalExpense => expenses.fold(0, (sum, e) => sum + e.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackAppBar(title: 'Сарын тайлан'),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background/background14.jpeg', fit: BoxFit.cover),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 50),
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color.fromARGB(255, 57, 187, 196),
                  ],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Сар сонгох --- //
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 24, bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white70, size: 18),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: selectedMonth,
                          underline: const SizedBox(),
                          borderRadius: BorderRadius.circular(12),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          dropdownColor: const Color(0xFF333F4B),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          items: months.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedMonth = value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 20),

                  // --- Орлого --- //
                  Center(
                    child: Column(
                      children: [
                         // TextButton.icon(
                                      //   style: TextButton.styleFrom(
                                      //     padding: EdgeInsets.symmetric(vertical: 6),
                                      //     minimumSize: Size.zero,
                                      //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      //   ),
                                      //   icon: const Icon(
                                      //     Icons.calendar_today,
                                      //     color: Color.fromARGB(255, 255, 255, 255),
                                      //     size: 18,
                                      //   ),
                                      //   label: Text(
                                      //     startDate != null && endDate != null
                                      //         ? "${DateFormat('yyyy-MM-dd').format(startDate!)} → ${DateFormat('yyyy-MM-dd').format(endDate!)}"
                                      //         : "🗓️ Хугацаа сонгох",
                                      //     style: TextStyle(
                                      //       color: Color.fromARGB(255, 255, 255, 255),
                                      //       fontWeight: FontWeight.bold,
                                      //     ),
                                      //   ),
                                      //   onPressed: () async {
                                      //     final picked = await showDialog<List<DateTime>>(
                                      //       context: context,
                                      //       builder: (context) =>
                                      //           TimelineDateRangeDialog(
                                      //             initialStart: startDate,
                                      //             initialEnd: endDate,
                                      //           ),
                                      //     );
                                      //     if (picked != null && picked.length == 2) {
                                      //       setState(() {
                                      //         startDate = picked[0];
                                      //         endDate = picked[1];
                                      //       });
                                      //     }
                                      //   },
                                      // ),
                                      // SizedBox(width: 30),
                                      // IconButton(
                                      //   icon: Icon(
                                      //     Icons.download_rounded,
                                      //     color: Colors.white,
                                      //   ),
                                      //   onPressed: () {
                                      //     // downloadTransaction(txn);
                                      //   },
                                      // ),
                        Text(
                          "Орлого",
                          style: TextStyle(
                            color: Colors.greenAccent[400],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            shadows: [Shadow(blurRadius: 8, color: Colors.black26)],
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 210,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 3,
                              centerSpaceRadius: 55,
                              startDegreeOffset: -90,
                              pieTouchData: PieTouchData(
                                touchCallback: (event, response) {
                                  if (!event.isInterestedForInteractions || response == null || response.touchedSection == null) {
                                    setState(() => touchedIncomeIndex = null);
                                  } else {
                                    setState(() => touchedIncomeIndex = response.touchedSection!.touchedSectionIndex);
                                  }
                                },
                              ),
                              sections: List.generate(incomes.length, (i) {
                                final income = incomes[i];
                                final isSelected = i == touchedIncomeIndex;
                                final value = income.amount;
                                final percent = value / totalIncome * 100;
                                return PieChartSectionData(
                                  color: income.color,
                                  value: value,
                                  title: isSelected
                                      ? "${income.name}\n${percent.toStringAsFixed(1)}%\n₮${value.toInt()}"
                                      : "${percent.toStringAsFixed(1)}%",
                                  radius: isSelected ? 65 : 55,
                                  titleStyle: TextStyle(
                                    fontSize: isSelected ? 16 : 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(blurRadius: 8, color: Colors.black45),
                                      if (isSelected) Shadow(blurRadius: 8, color: Colors.black87)
                                    ],
                                  ),
                                  titlePositionPercentageOffset: 0.82,
                                );
                              }),
                            ),
                            swapAnimationDuration: const Duration(milliseconds: 600),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Нийт орлого: ₮${_format(totalIncome)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            shadows: [Shadow(blurRadius: 8, color: Colors.black38)],
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildLegend("Орлогын категори", incomes),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // --- Зарлага --- //
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Зарлага",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            shadows: [Shadow(blurRadius: 8, color: Colors.black26)],
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 210,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 3,
                              centerSpaceRadius: 55,
                              startDegreeOffset: -90,
                              pieTouchData: PieTouchData(
                                touchCallback: (event, response) {
                                  if (!event.isInterestedForInteractions || response == null || response.touchedSection == null) {
                                    setState(() => touchedExpenseIndex = null);
                                  } else {
                                    setState(() => touchedExpenseIndex = response.touchedSection!.touchedSectionIndex);
                                  }
                                },
                              ),
                              sections: List.generate(expenses.length, (i) {
                                final expense = expenses[i];
                                final isSelected = i == touchedExpenseIndex;
                                final value = expense.amount;
                                final percent = value / totalExpense * 100;
                                return PieChartSectionData(
                                  color: expense.color,
                                  value: value,
                                  title: isSelected
                                      ? "${expense.name}\n${percent.toStringAsFixed(1)}%\n₮${value.toInt()}"
                                      : "${percent.toStringAsFixed(1)}%",
                                  radius: isSelected ? 65 : 55,
                                  titleStyle: TextStyle(
                                    fontSize: isSelected ? 16 : 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(blurRadius: 8, color: Colors.black45),
                                      if (isSelected) Shadow(blurRadius: 8, color: Colors.black87)
                                    ],
                                  ),
                                  titlePositionPercentageOffset: 0.82,
                                );
                              }),
                            ),
                            swapAnimationDuration: const Duration(milliseconds: 600),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Нийт зарлага: ₮${_format(totalExpense)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            shadows: [Shadow(blurRadius: 8, color: Colors.black38)],
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildLegend("Зарлагын категори", expenses),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String title, List<CategoryExpense> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 6),
        ...data.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: e.color,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    e.name,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )),
      ],
    );
  }

  String _format(double value) {
    // Жишээ: ₮1,200,000 гэх мэт форматаар
    return value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}

class CategoryExpense {
  final String name;
  final double amount;
  final Color color;
  CategoryExpense(this.name, this.amount, this.color);
}
