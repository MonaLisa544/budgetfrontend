import 'dart:ui';
import 'package:budgetfrontend/views/goals/goal_info_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:budgetfrontend/controllers/goal_controller.dart';
import 'package:budgetfrontend/views/goals/add_goal_view.dart';
import 'package:budgetfrontend/views/home/main_bar_view.dart';
import 'package:intl/intl.dart';


class GoalView extends StatefulWidget {
  const GoalView({super.key});

  

  @override
  State<GoalView> createState() => _GoalViewState();
}



class _GoalViewState extends State<GoalView> {
  final selectedWallet = 'Saving'.obs;
  final selectedTabIndex = 0.obs;
  final selectedFilter = 'Active'.obs;
 final GoalController goalController = Get.put(GoalController());

 @override
void initState() {
  super.initState();
  goalController.fetchGoals(); // ✅ энд датаг татахыг заавал дуудах ёстой
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MainBarView(
          title: 'Зорилго',
          onProfilePressed: () {},
          onNotfPressed: () {},
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
            SafeArea(
              child: Obx(() => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      onTap: (index) {
                        selectedWallet.value = ['Saving', 'Loan'][index];
                        selectedTabIndex.value = index;
                      },
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (selectedTabIndex.value == 0) Icon(Icons.check, size: 16),
                              if (selectedTabIndex.value == 0) const SizedBox(width: 4),
                              const Text('Хадгаламж'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (selectedTabIndex.value == 1) Icon(Icons.check, size: 16),
                              if (selectedTabIndex.value == 1) const SizedBox(width: 4),
                              const Text('Зээл'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 12),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     filterButton(),
                    //   ],
                    // ),
                    // const SizedBox(height: 10),
                    if (selectedWallet.value == 'Saving') ...[
                      GoalSection(
   title: 'Хувийн хадгаламж',
   goals: goalController.goals.where((g) => g.goalType == 'saving' && g.walletType == 'private').toList(),
 ),
 GoalSection(
   title: 'Гэр бүлийн хадгаламж',
   goals: goalController.goals.where((g) => g.goalType == 'saving' && g.walletType == 'family').toList(),
 ),
                      const SizedBox(height: 16),
                      AddGoalDashedBox(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AddGoalView()));
                      }),
                    ] else ...[
                       GoalSection(
   title: 'Хувийн зээл',
   goals: goalController.goals.where((g) => g.goalType == 'loan' && g.walletType == 'private').toList(),
 ),
 GoalSection(
   title: 'Гэр бүлийн зээл',
   goals: goalController.goals.where((g) => g.goalType == 'loan' && g.walletType == 'family').toList(),
 ),
                      const SizedBox(height: 16),
                      AddGoalDashedBox(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AddGoalView()));
                      }),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterButton() {
    final isActive = selectedFilter.value == 'Active';
    final color = isActive ? Colors.green : Colors.red;

    return GestureDetector(
      onTapDown: (details) {
        _showFilterSelection(details.globalPosition);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedFilter.value,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 6),
            Icon(Icons.keyboard_arrow_down, color: color),
          ],
        ),
      ),
    );
  }

  void _showFilterSelection(Offset position) async {
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx + 5, position.dy + 1),
      items: [
        PopupMenuItem<String>(
          value: 'Active',
          child: Row(
            children: [
              if (selectedFilter.value == 'Active') const Icon(Icons.check, color: Colors.blue, size: 20)
              else const SizedBox(width: 20),
              const SizedBox(width: 8),
              const Text('Active', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Completed',
          child: Row(
            children: [
              if (selectedFilter.value == 'Completed') const Icon(Icons.check, color: Colors.blue, size: 20)
              else const SizedBox(width: 20),
              const SizedBox(width: 8),
              const Text('Completed', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    if (result != null) {
      selectedFilter.value = result;
    }
  }
}




class GoalSection extends StatelessWidget {
  final String title;
  final List goals;

  const GoalSection({super.key, required this.title, required this.goals});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      title: Row(
        children: [
          Icon(title.toLowerCase().contains('private') ? Icons.person_outline : Icons.groups_outlined, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      collapsedBackgroundColor: const Color.fromARGB(255, 148, 156, 176).withOpacity(0.3),
      backgroundColor: const Color.fromARGB(255, 147, 168, 196).withOpacity(0.1),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: goals.map((goal) => GoalRow(title: goal.goalName, totalAmount: goal.targetAmount, savedAmount: goal.savedAmount, goal:goal, statuses: goal.monthlyStatuses.map((e) => e.status).toList().cast<String>(),)).toList(),
    );
  }
}

class LoanSection extends StatelessWidget {
  final String title;
  final List loans;

  const LoanSection({super.key, required this.title, required this.loans});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      title: Row(
        children: [
          Icon(title.toLowerCase().contains('private') ? Icons.person_outline : Icons.groups_outlined, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      collapsedBackgroundColor: const Color.fromARGB(255, 106, 115, 138).withOpacity(0.3),
      backgroundColor: const  Color.fromARGB(255, 147, 168, 196).withOpacity(0.1),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: loans.map((loan) => GoalRow(title: loan.loanName, totalAmount: loan.totalAmountDue, savedAmount: loan.savedAmount,  goal:loan, statuses: loan.monthlyStatuses.map((e) => e.status).toList().cast<String>(),)).toList(),
    );
  }
}


class GoalRow extends StatelessWidget {
  final String title;
  final double totalAmount;
  final double savedAmount;
  final dynamic goal; // 🔥 GoalModel object-оо авч явна!
    final List<String> statuses;
  

  const GoalRow({
    super.key,
    required this.title,
    required this.totalAmount,
    required this.savedAmount,
    required this.goal, // ✅ нэмлээ
    required this.statuses,
  });

  @override
  Widget build(BuildContext context) {
    double progress = totalAmount == 0 ? 0 : (savedAmount / totalAmount).clamp(0.0, 1.0);
    double monthlySaving = (totalAmount - savedAmount) / 7;
    int monthsLeft = ((totalAmount - savedAmount) / (monthlySaving > 0 ? monthlySaving : 1)).ceil();

    return GestureDetector(
      onTap: () {
        showGoalDetailDialog(context, goal); // 🔥 Гол дэлгэрэнгүйг харуулах
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 26, 121, 199).withOpacity(0.2),
                const Color.fromARGB(255, 17, 88, 194).withOpacity(0.7),
              ],
              stops: [0.0, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Зорилго',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                     child: Text(
  formatCurrency(totalAmount),
  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
),

                    ),
                    Text(
                      "March/April '24",
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Сар бүр ',
                        style: TextStyle(color: Colors.white),
                      ),
                     TextSpan(
  text: '${formatCurrency(monthlySaving)} ',
  style: const TextStyle(
    color: Colors.greenAccent,
    fontWeight: FontWeight.bold,
  ),
),
                      const TextSpan(
                        text: 'төлнө ',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: '($monthsLeft сарын турш)',
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // SmoothProgressBar(statuses: statuses),
                SmoothProgressBar(totalSteps: 7, completedSteps: 5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class AddGoalDashedBox extends StatelessWidget {
  final VoidCallback onTap;

  const AddGoalDashedBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10), // 👉 энд padding өгч байна
      child: GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          painter: DashedBorderPainter(),
          child: Container(
            width: double.infinity,
            height: 100,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // 👉 container дотор padding
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, color: Colors.white70, size: 32),
                SizedBox(height: 8),
                Text('Шинэ зорилго нэмэх', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SmoothProgressBar extends StatelessWidget {
  final int totalSteps;
  final int completedSteps;

  const SmoothProgressBar({
    super.key,
    required this.totalSteps,
    required this.completedSteps,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background line
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Completed line
          FractionallySizedBox(
            widthFactor: completedSteps / totalSteps,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.cyanAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Circles
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(totalSteps, (index) {
                bool isCompleted = index < completedSteps;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isCompleted)
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.cyanAccent.withOpacity(0.2),
                        ),
                      ),
                    Container(
                      width: isCompleted ? 12 : 8,
                      height: isCompleted ? 12 : 8,
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.cyanAccent : Colors.blue.shade900,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// class SmoothProgressBar extends StatelessWidget {
//   final List<String> statuses; // ['success', 'pending', 'fail', ...]

//   const SmoothProgressBar({
//     super.key,
//     required this.statuses,
//   });

//   @override
//   Widget build(BuildContext context) {
//     int totalSteps = statuses.length;
//     int completedSteps = statuses
//         .where((status) => status == 'success' || status == 'fail')
//         .length;

//     return SizedBox(
//       height: 40,
//       child: Stack(
//         alignment: Alignment.centerLeft,
//         children: [
//           // Background line (full width, scrollable)
//           ListView.builder(
//             scrollDirection: Axis.horizontal,
//             physics: const BouncingScrollPhysics(),
//             itemCount: 1,
//             itemBuilder: (context, _) {
//               return Container(
//                 width: totalSteps * 30, // багана тутамд 30px
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade900,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               );
//             },
//             shrinkWrap: true,
//           ),
//           // Completed line (success + fail, scrollable)
//           Positioned.fill(
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: FractionallySizedBox(
//                 widthFactor: totalSteps == 0 ? 0 : completedSteps / totalSteps,
//                 child: Container(
//                   height: 4,
//                   width: totalSteps * 30,
//                   decoration: BoxDecoration(
//                     color: Colors.cyanAccent,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // Circles (scrollable)
//           ListView.builder(
//             scrollDirection: Axis.horizontal,
//             physics: const BouncingScrollPhysics(),
//             itemCount: totalSteps,
//             itemBuilder: (context, index) {
//               final status = statuses[index];
//               bool isCompleted = status == 'success' || status == 'fail';
//               return Container(
//                 width: 30,
//                 alignment: Alignment.center,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     if (isCompleted)
//                       Container(
//                         width: 24,
//                         height: 24,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.cyanAccent.withOpacity(0.2),
//                         ),
//                       ),
//                     Container(
//                       width: isCompleted ? 12 : 8,
//                       height: isCompleted ? 12 : 8,
//                       decoration: BoxDecoration(
//                         color: isCompleted
//                             ? (status == 'success'
//                                 ? Colors.greenAccent
//                                 : Colors.redAccent)
//                             : Colors.blue.shade900,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white24, width: 1),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             shrinkWrap: true,
//           ),
//         ],
//       ),
//     );
//   }
// }

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

String formatCurrency(double value, {bool symbolFirst = true}) {
  final formatter = NumberFormat("#,##0", "mn");
  return symbolFirst
      ? "₮ ${formatter.format(value)}"
      : "${formatter.format(value)} ₮";
}