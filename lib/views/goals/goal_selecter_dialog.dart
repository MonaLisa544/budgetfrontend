import 'package:flutter/material.dart';
import 'package:budgetfrontend/models/goal_model.dart';
import 'package:budgetfrontend/services/api_service.dart';

String getGoalTypeLabel(String type) {
  final t = type.toLowerCase();
  if (t == 'loan' || t == 'saving') {
    return '${t[0].toUpperCase()}${t.substring(1)}';
  }
  return '';
}

Future<GoalModel?> showGoalSelectorDialogByType({
  required BuildContext context,
  required String type, // 'loan' эсвэл 'saving'
  GoalModel? selectedGoal,
}) async {
  return await showDialog<GoalModel>(
    context: context,
    builder: (context) {
      GoalModel? tempSelected = selectedGoal;
      late Future<List<GoalModel>> futureGoals;

      // Бүх goals-оо татна
      futureGoals = ApiService.fetchGoals();

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getGoalTypeLabel(type).isNotEmpty
                      ? '${getGoalTypeLabel(type)}'
                      : 'Goal',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: FutureBuilder<List<GoalModel>>(
              future: futureGoals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Алдаа гарлаа: ${snapshot.error}');
                }

                final allGoals = snapshot.data ?? [];
                // type-р filter хийж байна!
               final filteredGoals = allGoals.where((goal) {
  final gt = goal.goalType.toLowerCase();
  final tt = type.toLowerCase();
  if (gt == tt) return true;
  if ((gt == "saving" && tt == "хадгаламж") || (gt == "хадгаламж" && tt == "saving")) return true;
  if ((gt == "loan" && tt == "зээл") || (gt == "зээл" && tt == "loan")) return true;
  return false;
}).toList();

                if (filteredGoals.isEmpty) {
                  return const Center(child: Text("No goals"));
                }

                return SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: ListView.builder(
                    itemCount: filteredGoals.length,
                    itemBuilder: (context, index) {
                      final goal = filteredGoals[index];
                      final isSelected = tempSelected?.id == goal.id;
                      return ListTile(
                        leading: Icon(Icons.flag, color: isSelected ? Colors.green : Colors.grey),
                        title: Text(goal.goalName),
                        subtitle: Text('\$${goal.targetAmount} • ${goal.status}'),
                        tileColor: isSelected ? Colors.green.shade100 : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        onTap: () {
                          setState(() {
                            tempSelected = goal;
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, tempSelected),
                child: const Text("OK", style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );
    },
  );
}
