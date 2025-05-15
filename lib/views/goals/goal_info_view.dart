import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budgetfrontend/models/goal_model.dart';
import 'package:budgetfrontend/controllers/goal_controller.dart';
import 'package:get/get.dart';

Future<void> showGoalDetailDialog(BuildContext context, GoalModel goal) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => GoalDetailContent(goal: goal),
  );
}

class GoalDetailContent extends StatelessWidget {
  final GoalModel goal;
  const GoalDetailContent({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final GoalController goalController = Get.find<GoalController>();

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
                      "Зорилтын дэлгэрэнгүй",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  _buildDetailRow("Нэр:", goal.goalName),
                  _buildDetailRow("Төрөл:", goal.goalType.capitalize ?? ''),
                  _buildDetailRow("Статус:", goal.status.capitalize ?? ''),
                  _buildDetailRow("Нийт зорилт:", "${goal.targetAmount.toStringAsFixed(2)}₮"),
                  _buildDetailRow("Биелүүлсэн:", "${goal.paidAmount.toStringAsFixed(2)}₮"),
                  _buildDetailRow("Үлдэгдэл:", "${goal.remainingAmount.toStringAsFixed(2)}₮"),
                  _buildDetailRow("Эхлэх огноо:", DateFormat('yyyy-MM-dd').format(goal.startDate)),
                  _buildDetailRow("Дуусах огноо:", DateFormat('yyyy-MM-dd').format(goal.expectedDate)),
                  _buildDetailRow("Тайлбар:", goal.description.isNotEmpty ? goal.description : "—"),
                  _buildDetailRow("Хэтэвч:", goal.ownerType == 'Family' ? "Family Wallet" : "Private Wallet"),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Баталгаажуулах'),
                                content: const Text('Энэ зорилтыг устгах уу?'),
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
                              // await goalController.deleteGoal(goal.id);
                              Navigator.pop(context);
                              Get.snackbar(
                                "Амжилттай", "Зорилт устгалаа",
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

                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            // ✨ Засах дэлгэц рүү орох бол энд navigation хийх
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

            // 🟢 Дээр нь CATEGORY ICON тавина
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.6),
                            blurRadius: 10,
                            offset: const Offset(0, 2.5),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.9),
                            blurRadius: 10,
                            offset: const Offset(0, -2.5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.flag_rounded, size: 40, color: Colors.white),
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
