import 'package:budgetfrontend/views/budgets/budget_info_view.dart';
import 'package:budgetfrontend/widgets/add_category_dashed_box.dart';
import 'package:budgetfrontend/widgets/budget_section.dart';
import 'package:budgetfrontend/widgets/budget_row.dart';
import 'package:budgetfrontend/widgets/budget_summary_card.dart';
import 'package:budgetfrontend/widgets/month_year_selector.dart';
import 'package:budgetfrontend/widgets/monthly_summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:budgetfrontend/controllers/budget_controller.dart';
import 'package:budgetfrontend/views/home/main_bar_view.dart';
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
  void initState() {
    super.initState();
    _fetchBudgetsForSelectedDate();
  }

  void _fetchBudgetsForSelectedDate() {
    final yearMonth = "${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}";
    budgetController.fetchBudgets(yearMonth: yearMonth);
  }

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

            final privateBudgets =
                budgetController.budgets
                    .where((b) => b.walletType == "private")
                    .toList();
            final familyBudgets =
                budgetController.budgets
                    .where((b) => b.walletType == "family")
                    .toList();

            final familyTotal = familyBudgets.fold<double>(
              0,
              (sum, b) => sum + b.amount,
            );
            final familyUsed = familyBudgets.fold<double>(
              0,
              (sum, b) => sum + (b.currentMonthBudget?.usedAmount ?? 0),
            );
            final privateTotal = privateBudgets.fold<double>(
              0,
              (sum, b) => sum + b.amount,
            );
            final privateUsed = privateBudgets.fold<double>(
              0,
              (sum, b) => sum + (b.currentMonthBudget?.usedAmount ?? 0),
            );

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                MonthlySummary(
  selectedDate: selectedDate,
  onChanged: (newDate) {
    if (selectedDate == newDate) return;
    setState(() { selectedDate = newDate; });
    _fetchBudgetsForSelectedDate();
  },
  familyTotal: familyTotal,
  familyUsed: familyUsed,
  privateTotal: privateTotal,
  privateUsed: privateUsed,
),

                  const SizedBox(height: 12),
                  BudgetSection(
                    title: 'Хувийн төсөв',
                    leadingIcon: Icons.person,
                    items: privateBudgets,
                    itemBuilder:
                        (budget) => BudgetsRow(
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
                    itemBuilder:
                        (budget) => BudgetsRow(
                          budget: budget,
                          onPressed: () {
                            showBudgetDetailDialog(context, budget);
                          },
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                      top: 25,
                      bottom: 70,
                    ),
                    child: AddCategoryDashedBox(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddBudgetView(),
                          ),
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

String formatCurrency(double value, {bool symbolFirst = true}) {
  final formatter = NumberFormat("#,##0", "mn");
  return symbolFirst
      ? "₮ ${formatter.format(value)}"
      : "${formatter.format(value)} ₮";
}
