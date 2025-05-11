import 'dart:io';
import 'dart:ui';
import 'package:budgetfrontend/views/budgets/budget_view.dart';
import 'package:budgetfrontend/views/goals/add_loan_view.dart';
import 'package:budgetfrontend/views/goals/add_saving_view.dart';
import 'package:budgetfrontend/views/home/main_bar_view.dart';
import 'package:flutter/material.dart';

class GoalView extends StatefulWidget {
  const GoalView({super.key});

  @override
  State<GoalView> createState() => _GoalViewState();
}

class _GoalViewState extends State<GoalView> {
  String selectedWallet = 'Saving';

  final List<Map<String, dynamic>> savingPrivateGoals = [
    {"name": "Аялал", "amount": "500,000", "progress": 0.4, "imageUrl": null},
    {"name": "Аялал", "amount": "500,000", "progress": 0.4, "imageUrl": null},
    {"name": "Аялал", "amount": "500,000", "progress": 0.4, "imageUrl": null},
  ];

  final List<Map<String, dynamic>> savingFamilyGoals = [
    {"name": "Гэр бүлээр амралт", "amount": "1,500,000", "progress": 0.7, "imageUrl": null},
  ];

  final List<Map<String, dynamic>> loanPrivateGoals = [
    {"name": "Гар утасны зээл", "amount": "400,000", "progress": 0.6, "total_budget": "1000000"},
  ];

  final List<Map<String, dynamic>> loanFamilyGoals = [
    {"name": "Орон сууц", "amount": "20,000,000", "progress": 0.3, "total_budget": "30000000"},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: MainBarView(
          title: 'Goals',
          onProfilePressed: () {},
          onNotfPressed: () {},
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
                    colors: [Colors.transparent, Color.fromARGB(255, 57, 186, 196)],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      onTap: (index) {
                        setState(() {
                          selectedWallet = ['Saving', 'Loan'][index];
                        });
                      },
                      tabs: const [
                        Tab(text: "Saving"),
                        Tab(text: "Loan"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          BudgetSection(
                            title: ' Private',
                            items: selectedWallet == 'Saving' ? savingPrivateGoals : loanPrivateGoals,
                            itemBuilder: (goal) => selectedWallet == 'Saving'
                                ? GoalListItem(goal: goal, isSaving: true)
                                : LoanBudgetRow(goal: goal),
                            isGrid: selectedWallet == 'Saving',
                          ),
                          BudgetSection(
                            title: ' Family',
                            items: selectedWallet == 'Saving' ? savingFamilyGoals : loanFamilyGoals,
                            itemBuilder: (goal) => selectedWallet == 'Saving'
                                ? GoalListItem(goal: goal, isSaving: true)
                                : LoanBudgetRow(goal: goal),
                            isGrid: selectedWallet == 'Saving',
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: AddGoalDashedBox(
                              onTap: () {
                                if (selectedWallet == 'Saving') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const AddSavingView()),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const AddLoanView()),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class LoanBudgetRow extends StatelessWidget {
  final Map<String, dynamic> goal;

  const LoanBudgetRow({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    var leftAmount = double.tryParse(goal["amount"].toString()) ?? 0;
    var totalBudget = double.tryParse(goal["total_budget"].toString()) ?? 1;
    var spendAmount = totalBudget - leftAmount;
    var progress = leftAmount / totalBudget;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Loan дээр дарахад хийх event (одоо хоосон)
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
            color: Colors.grey.shade200.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, size: 30, color: Colors.blueAccent), // 🧩 Flutter icon ашиглав
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal["name"],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "\$${leftAmount.toStringAsFixed(0)} left to spend",
                          style: TextStyle(
                              color: Colors.grey.shade700,
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
                        "\$${spendAmount.toStringAsFixed(0)}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "of \$${totalBudget.toStringAsFixed(0)}",
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                minHeight: 4,
                value: progress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalListItem extends StatelessWidget {
  final Map<String, dynamic> goal;
  final bool isSaving;

  const GoalListItem({super.key, required this.goal, required this.isSaving});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 249, 254),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 99, 99, 99).withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 110,
              child: isSaving
                  ? (goal['imageUrl'] != null
                      ? Image.file(
                          File(goal['imageUrl']),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/icon/flower8.jpg',
                          fit: BoxFit.cover,
                        ))
                  : Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.account_balance, size: 40, color: Colors.grey),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  goal['name'],
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  goal['amount'],
                  style: const TextStyle(
                    color: Color.fromARGB(179, 29, 28, 28),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: goal['progress'],
                  color: const Color.fromARGB(255, 255, 89, 197),
                  backgroundColor: const Color.fromARGB(60, 36, 35, 35),
                  minHeight: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetSection extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Widget Function(Map<String, dynamic>) itemBuilder;
  final bool isGrid;

  const BudgetSection({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.isGrid = false,
  });

  @override
  State<BudgetSection> createState() => _BudgetSectionState();
}

class _BudgetSectionState extends State<BudgetSection> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      onExpansionChanged: (expanded) {
        setState(() {
          isExpanded = expanded;
        });
      },
      title: Row(
        children: [
          Icon(
            widget.title.trim().toLowerCase().contains('private')
                ? Icons.person_outline
                : Icons.groups_outlined,
            color: isExpanded ? Colors.black : Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isExpanded ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
      iconColor: isExpanded ? Colors.black : Colors.white,
      collapsedIconColor: Colors.white,
      collapsedBackgroundColor: Colors.white.withOpacity(0.1),
      backgroundColor: const Color.fromARGB(255, 244, 247, 252).withOpacity(0.9),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      children: [
        widget.isGrid
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GridView.builder(
                  itemCount: widget.items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (_, index) => widget.itemBuilder(widget.items[index]),
                ),
              )
            : Column(
                children: widget.items.map(widget.itemBuilder).toList(),
              ),
      ],
    );
  }
}

class AddGoalDashedBox extends StatelessWidget {
  final VoidCallback onTap;

  const AddGoalDashedBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Container(
          width: 160,
          height: 80,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, color: Colors.white70, size: 32),
                SizedBox(height: 8),
                Text(
                  'Add new goal',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
