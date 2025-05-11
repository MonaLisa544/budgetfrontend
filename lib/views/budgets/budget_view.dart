import 'package:budgetfrontend/views/budgets/add_budget_view.dart';
import 'package:budgetfrontend/views/budgets/budget_info_view.dart';
import 'package:budgetfrontend/views/home/main_bar_view.dart';
import 'package:budgetfrontend/widgets/budget_section.dart';
import 'package:budgetfrontend/widgets/budgets_row.dart';
import 'package:budgetfrontend/widgets/common/color_extension.dart';
import 'package:budgetfrontend/widgets/dual_arc_painter.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  DateTime selectedDate = DateTime.now();

  List<Map<String, dynamic>> privateBudgets = [
    {
      "name": "Auto & Transport",
      "icon": "assets/img/auto_&_transport.png",
      "spend_amount": "25.99",
      "total_budget": "400",
      "left_amount": "250.01",
      "color": TColor.secondaryG,
    },
    {
      "name": "Entertainment",
      "icon": "assets/img/entertainment.png",
      "spend_amount": "50.99",
      "total_budget": "600",
      "left_amount": "300.01",
      "color": TColor.secondary50,
    },
  ];

  List<Map<String, dynamic>> familyBudgets = [
    {
      "name": "Security",
      "icon": "assets/img/security.png",
      "spend_amount": "5.99",
      "total_budget": "600",
      "left_amount": "250.01",
      "color": TColor.primary10,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double total = 1000000;
    final double used = 600000;
    final double percentage = total == 0 ? 0 : used / total;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainBarView(
        title: 'Budgets',
        onNotfPressed: () {},
        onProfilePressed: () {},
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background/background14.jpeg', fit: BoxFit.cover),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 99, sigmaY: 50),
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
                    Color.fromARGB(255, 57, 186, 196),
                  ],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
      //               decoration: BoxDecoration(
      //   color: const Color.fromARGB(255, 226, 230, 238).withOpacity(0.2),
      //   borderRadius: BorderRadius.circular(16),
      //   //border: Border.all(color: Colors.white.withOpacity(0.2)),
      // ),
                    child: Column(
                      
                      children: [
                        MonthYearSelector(
                          selectedDate: selectedDate,
                          onChanged: (newDate) {
                            setState(() {
                              selectedDate = newDate;
                              // TODO: Энэ үед тухайн сарын төсвийг backend-ээс дахин ачааллаж болно
                            });
                          },
                        ),
                  //       BudgetSummaryCard(
                  //   familyTotal: 1200000,
                  //   familyUsed: 800000,
                  //   privateTotal: 800000,
                  //   privateUsed: 400000,
                  // ),
                      ],
                    ),
                    
                  ),
                  

                  const SizedBox(height: 12),
                BudgetSection(
  title: '  Private',
  leadingIcon: Icons.person,
  items: privateBudgets,
  itemBuilder: (bObj) => BudgetsRow(
    bObj: bObj,
    onPressed: () {
      final transaction = {
        "date": "2025-05-08",
        "type": "Зарлага",
        "amount": "25000",
        "category_name": "Хоол хүнс",
        "note": "Өдрийн хоол"
      };
      showBudgetInfoDialog(context, transaction);
    },
  ),
),

BudgetSection(
  title: '  Family',
  leadingIcon: Icons.group,
  items: familyBudgets,
  itemBuilder: (bObj) => BudgetsRow(
    bObj: bObj,
    onPressed: () {
      // ...
    },
  ),
),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: AddCategoryDashedBox(
                      onTap: () {
                        // category нэмэх логик эсвэл dialog/modal нээх
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class MonthYearSelector extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(DateTime newDate) onChanged;

  const MonthYearSelector({
    super.key,
    required this.selectedDate,
    required this.onChanged,
  });

  String get formatted =>
      "  ${_monthName(selectedDate.month)} ${selectedDate.year}";

  @override
  Widget build(BuildContext context) {
    final lastAllowedDate = DateTime(2025, 6); // 6-р сар бол сүүлчийнх

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ⬅️ Өмнөх сар руу шилжих сум (боломжтой үргэлж)
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              DateTime newDate = DateTime(
                selectedDate.month == 1
                    ? selectedDate.year - 1
                    : selectedDate.year,
                selectedDate.month == 1 ? 12 : selectedDate.month - 1,
              );
              onChanged(newDate);
            },
          ),

          // 🗓 Сар, жил харуулах
          Row(
            children: [
              Icon(Icons.calendar_month, size: 22, color: const Color.fromARGB(255, 255, 255, 255)),
              Text(
                formatted,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // ➡️ Дараагийн сар руу шилжих сум (боломжгүй бол null)
          selectedDate.year < lastAllowedDate.year ||
                  (selectedDate.year == lastAllowedDate.year &&
                      selectedDate.month < lastAllowedDate.month)
              ? IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  DateTime newDate = DateTime(
                    selectedDate.month == 12
                        ? selectedDate.year + 1
                        : selectedDate.year,
                    selectedDate.month == 12 ? 1 : selectedDate.month + 1,
                  );
                  onChanged(newDate);
                },
              )
              : const SizedBox(width: 48), // ➡️ сумны оронд хоосон зай үлдээнэ
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
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

  @override
  Widget build(BuildContext context) {
    final maxTotal = [
      familyTotal,
      privateTotal,
    ].reduce((a, b) => a > b ? a : b);
    final double familyPercent = maxTotal == 0 ? 0 : familyUsed / maxTotal;
    final double privatePercent = maxTotal == 0 ? 0 : privateUsed / maxTotal;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.only(left: 13),
      // decoration: BoxDecoration(
      //   color: Colors.white.withOpacity(0.1),
      //   borderRadius: BorderRadius.circular(16),
      //   //border: Border.all(color: Colors.white.withOpacity(0.2)),
      // ),
      child: DualBudgetArc(
            familyPercent: familyPercent,
            privatePercent: privatePercent, )
      //     ), Row(
      //   children: [
      //     DualBudgetArc(
      //       familyPercent: familyPercent,
      //       privatePercent: privatePercent,
      //     ),
      //     const SizedBox(width: 16),
      //     // Expanded(
      //     //   child: Column(
      //     //     crossAxisAlignment: CrossAxisAlignment.start,
      //     //     children: [
      //     //       Row(
      //     //         children: [
      //     //           Icon(Icons.bar_chart, color: Colors.white),
      //     //           const Text(
      //     //             " Overview",
      //     //             style: TextStyle(
      //     //               color: Colors.white,
      //     //               fontSize: 16,
      //     //               fontWeight: FontWeight.bold,
      //     //             ),
      //     //           ),
      //     //         ],
      //     //       ),
      //     //       const SizedBox(height: 8),
      //     //       Column(
      //     //         children: [
      //     //           Text(
      //     //             "Family total ",
      //     //             style: const TextStyle(color: Colors.white, fontSize: 12),
      //     //           ),
      //     //           Text(
      //     //              "      ${familyTotal.toStringAsFixed(0)}₮",
      //     //         style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      //     //       ),
      //     //       SizedBox(height: 5),
      //     //       Text(
      //     //         "Private total ",
      //     //         style: const TextStyle(color: Colors.white, fontSize: 12),
      //     //       ),
      //     //       Text(
      //     //         "     ${privateTotal.toStringAsFixed(0)}₮",
      //     //         style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      //     //       ),
      //     //         ],
      //     //       ),
               
                
      //     //     ],
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }
}
class AddCategoryDashedBox extends StatelessWidget {
  final VoidCallback onTap;

  const AddCategoryDashedBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBudgetView()),
    );
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
                'Add new budget',
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
