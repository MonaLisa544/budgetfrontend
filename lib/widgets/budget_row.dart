import 'package:budgetfrontend/models/budget_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetsRow extends StatelessWidget {
  final BudgetModel budget;
  final VoidCallback onPressed;

  const BudgetsRow({
    super.key,
    required this.budget,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double used = budget.currentMonthBudget?.usedAmount ?? 0;
    double total = budget.amount;
    double progress = total == 0 ? 0 : used / total;
    bool exceeded = used > total;
    final Color mainColor = budget.category?.safeColor ?? Colors.blueAccent;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      padding: const EdgeInsets.only(top: 5, bottom: 2, right: 5, left: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        // gradient, boxShadow-г хүсвэл нээгээрэй
      ),
      child: Row(
        children: [
          // ICON
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  mainColor.withOpacity(0.5),
                  mainColor.withOpacity(0.9),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  offset: Offset(-3, -3),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  offset: Offset(3, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                budget.category?.iconData ?? Icons.category,
                color: Colors.white,
                size: 26,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 18),
          // TEXT & BAR
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Текст болон дүн
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category нэр
                    Flexible(
                      child: Text(
                        budget.budgetName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    Text(
                      formatCurrency(total),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.68),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // PROGRESS BAR (layoutBuilder ашиглаж responsive болгоно)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final barWidth = constraints.maxWidth;
                    return Stack(
                      children: [
                        Container(
                          height: 9,
                          width: barWidth,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 68, 68, 68).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // Main progress
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          height: 9,
                          width: (progress.clamp(0.0, 1.0)) * barWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                mainColor.withOpacity(0.94),
                                mainColor.withOpacity(0.65),
                                mainColor.withOpacity(0.46)
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(66, 138, 138, 138),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Text(
                  "Ашигласан: ${formatCurrency(used)}",
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Илүү icon товч
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded,
                color: Color.fromARGB(255, 0, 0, 0), size: 28),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

// Форматтай мөнгө харуулах функц
String formatCurrency(double value, {bool symbolFirst = true}) {
  final formatter = NumberFormat("#,##0", "mn");
  return symbolFirst
      ? "₮ ${formatter.format(value)}"
      : "${formatter.format(value)} ₮";
}
