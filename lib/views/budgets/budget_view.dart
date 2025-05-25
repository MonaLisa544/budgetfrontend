import 'package:budgetfrontend/models/budget_model.dart';
import 'package:budgetfrontend/views/budgets/budget_info_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:budgetfrontend/controllers/budget_controller.dart';
import 'package:budgetfrontend/views/home/main_bar_view.dart';
import 'package:budgetfrontend/widgets/common/color_extension.dart';
import 'package:budgetfrontend/widgets/dual_arc_painter.dart';
import 'package:budgetfrontend/views/budgets/add_budget_view.dart';
import 'dart:ui';

import 'package:intl/intl.dart';


class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  final BudgetController budgetController = Get.put(BudgetController());
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainBarView(
        title: 'Төсөв ',
        onNotfPressed: () {},
        onProfilePressed: () {},
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background/background77.jpeg', fit: BoxFit.cover),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 70, sigmaY: 20),
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
          Obx(() {
            if (budgetController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final privateBudgets = budgetController.budgets
                .where((b) => b.walletType == "private")
                .toList();
            final familyBudgets = budgetController.budgets
                .where((b) => b.walletType == "family")
                .toList();

            final familyTotal = familyBudgets.fold<double>(0, (sum, b) => sum + b.amount);
            final familyUsed = familyBudgets.fold<double>(0, (sum, b) => sum + b.currentMonthBudget!.usedAmount);
            final privateTotal = privateBudgets.fold<double>(0, (sum, b) => sum + b.amount);
            final privateUsed = privateBudgets.fold<double>(0, (sum, b) => sum + b.currentMonthBudget!.usedAmount);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 MonthYearSelector(
  selectedDate: selectedDate,
  onChanged: (newDate) {
    setState(() {
      selectedDate = newDate;
    });
    final yearMonth = "${newDate.year.toString().padLeft(4, '0')}-${newDate.month.toString().padLeft(2, '0')}";
    budgetController.fetchBudgets(yearMonth: yearMonth);
  },
),
                   Padding(
                    padding: const EdgeInsets.all(16),
                    child: BudgetSummaryCard(
                      familyTotal: familyTotal,
                      familyUsed: familyUsed,
                      privateTotal: privateTotal,
                      privateUsed: privateUsed,
                    ),
                  ),
                  const SizedBox(height: 12),
                  BudgetSection(
                    title: 'Хувийн төсөв',
                    leadingIcon: Icons.person,
                    items: privateBudgets,
                    itemBuilder: (budget) => BudgetsRow(
                      budget: budget,
                      onPressed: () {
  showBudgetDetailDialog(context, budget);
},
                    ),
                  ),
                  BudgetSection(
                    title: 'Гэр бүлийн төсөв',
                    leadingIcon: Icons.group,
                    items: familyBudgets,
                    itemBuilder: (budget) => BudgetsRow(
                      budget: budget,
                      onPressed: () {
  showBudgetDetailDialog(context, budget);
},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 70),
                    child: AddCategoryDashedBox(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddBudgetView()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
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
              SizedBox(width: 40),
              Icon(Icons.calendar_today, size: 22, color: const Color.fromARGB(255, 255, 255, 255)),
              Text(
                formatted,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
                IconButton(
      icon: Icon(Icons.download_rounded, color: Colors.white),
      onPressed: () {
        // downloadTransaction(txn);
      },
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
  
  get children => null;

  @override
  Widget build(BuildContext context) {
    final maxTotal = [
      familyTotal,
      privateTotal,
    ].reduce((a, b) => a > b ? a : b);
    final double familyPercent = maxTotal == 0 ? 0 : familyUsed / maxTotal;
    final double privatePercent = maxTotal == 0 ? 0 : privateUsed / maxTotal;

    return Row(
      children: [
        Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: const EdgeInsets.only(left: 0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 66, 84, 128).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          //border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: DualBudgetArc(
              familyPercent: familyPercent,
              privatePercent: privatePercent, )
         
      ),
      SizedBox(width: 30),
      Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusRow(Icons.check_circle_outline, "Active", Colors.greenAccent),
                const SizedBox(height: 8),
                _buildStatusRow(Icons.warning_amber_rounded, "Exceeded", Colors.redAccent),
              ],
            ),
          ),

      ] 
    );
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

class BudgetsRow extends StatelessWidget {
  final BudgetModel budget;
  final VoidCallback onPressed;

  const BudgetsRow({super.key, required this.budget, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double leftAmount = budget.amount - budget.currentMonthBudget!.usedAmount;
    double proVal = budget.amount == 0 ? 0 : leftAmount / budget.amount;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
            color: const Color.fromARGB(255, 30, 46, 70).withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      budget.category?.iconData ?? Icons.category, // 🔥
                      size: 30,
                      color: budget.category?.safeColor ?? TColor.gray10, // 🔥
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.budgetName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
  formatCurrency(leftAmount), // <<<<<<<<<<<<<<<<<<
  style: TextStyle(
      color: TColor.gray10,
      fontSize: 12,
      fontWeight: FontWeight.w500),
),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                     Text(
  formatCurrency(budget.amount), // <<<<<<<<<<<<<<<<<<
  style: TextStyle(
      color: TColor.gray10,
      fontSize: 14,
      fontWeight: FontWeight.w600),
),

                     Text(
  "of ${formatCurrency(budget.currentMonthBudget!.usedAmount)}", // <<<<<<<<<<<<<<<<<<
  style: const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w500),
),
                     
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
             LinearProgressIndicator(
  backgroundColor: TColor.gray60,
  valueColor: AlwaysStoppedAnimation<Color>(
    budget.category?.safeColor ?? Colors.blueAccent,
  ),
  minHeight: 3,
  value: (1.0 - proVal).clamp(0.0, 1.0),
)
            ],
          ),
        ),
      ),
    );
  }
}

class BudgetSection extends StatelessWidget {
  final String title;
  final IconData? leadingIcon;
  final List<BudgetModel> items;
  final Widget Function(BudgetModel) itemBuilder; // ✅ Энд зөв BudgetModel

  const BudgetSection({
    super.key,
    required this.title,
    this.leadingIcon,
    required this.items,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Row(
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 18, color: Colors.white),
            const SizedBox(width: 6),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      collapsedBackgroundColor: const Color.fromARGB(255, 66, 84, 128).withOpacity(0.3),
      backgroundColor: const Color.fromARGB(255, 66, 84, 128).withOpacity(0.3),
      children: items.map(itemBuilder).toList(),
    );
  }



}

String formatCurrency(double value, {bool symbolFirst = true}) {
  final formatter = NumberFormat("#,##0", "mn");
  return symbolFirst
      ? "₮ ${formatter.format(value)}"
      : "${formatter.format(value)} ₮";
}

