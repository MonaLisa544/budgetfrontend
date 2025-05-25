import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budgetfrontend/models/budget_model.dart';
import 'package:budgetfrontend/views/budgets/add_budget_view.dart';
import 'package:get/get.dart';
import 'package:budgetfrontend/controllers/budget_controller.dart';

Future<void> showBudgetDetailDialog(BuildContext context, BudgetModel budget) {
  print('💬 showBudgetDetailDialog called: ${budget.budgetName}');
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BudgetDetailContent(budget: budget),
  );
}

class BudgetDetailContent extends StatelessWidget {
  final BudgetModel budget;
  const BudgetDetailContent({super.key, required this.budget});

  // Month -> Start date: YYYY-MM-01
  String getStartDateFromMonth(String? month) {
    if (month == null || month.length != 7) return "-";
    return "$month-01";
  }

  // Month -> End date: last day of month
  String getEndDateFromMonth(String? month) {
    if (month == null || month.length != 7) return "-";
    final date = DateTime.parse("$month-01");
    final lastDay = DateTime(date.year, date.month + 1, 0).day;
    return "$month-${lastDay.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final BudgetController budgetController = Get.find<BudgetController>();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.85,
      minChildSize: 0.4,
      builder: (_, controller) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Text(
                      "Төсвийн дэлгэрэнгүй",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildDetailRow("Нэр:", budget.budgetName),
                  _buildDetailRow("Нийт төсөв:", "${budget.amount.toStringAsFixed(2)}₮"),
                  _buildDetailRow("Ашигласан:", "${budget.currentMonthBudget?.usedAmount.toStringAsFixed(2) ?? '-'}₮"),
                  _buildDetailRow(
                    "Эхлэх огноо:",
                    getStartDateFromMonth(budget.currentMonthBudget?.month),
                  ),
                  _buildDetailRow(
                    "Дуусах огноо:",
                    getEndDateFromMonth(budget.currentMonthBudget?.month),
                  ),
                  _buildDetailRow("Төлбөрийн огноо:", budget.payDueDate.toString()),
                  _buildDetailRow("Тайлбар:", budget.description.isNotEmpty ? budget.description : "—"),
                  _buildDetailRow("Хэтэвч:", budget.walletType == 'family' ? "Family Wallet" : "Private Wallet"),
                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Устгах товч
                        TextButton.icon(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Баталгаажуулах'),
                                content: const Text('Энэ төсвийг устгах уу?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Үгүй'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Тийм'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              await budgetController.deleteBudget(budget.id);
                              Navigator.pop(context);
                              Get.snackbar(
                                "Амжилттай", "Төсөв устгалаа",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.greenAccent,
                              );
                            }
                          },
                          icon: const Icon(Icons.delete_sharp, color: Colors.red),
                          label: const Text(
                            "Устгах",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Засах товч
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddBudgetView(editBudget: budget),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          label: const Text(
                            "Засах",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // Дээр category icon
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Доод давхарга өнгөт сүүдэртэй
                    Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        color: budget.category?.safeColor ?? Colors.grey,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (budget.category?.safeColor ?? Colors.grey).withOpacity(0.6),
                            blurRadius: 10,
                            offset: const Offset(0, 2.5),
                          ),
                        ],
                      ),
                    ),
                    // Дээд давхарга цагаан сүүдэртэй
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: budget.category?.safeColor ?? Colors.grey.shade300,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.9),
                            blurRadius: 10,
                            offset: const Offset(0, -2.5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          budget.category?.iconData ?? Icons.category,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
