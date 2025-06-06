// import 'package:flutter/material.dart';

// class GoalSection extends StatelessWidget {
//   final String title;
//   final List goals;

//   const GoalSection({super.key, required this.title, required this.goals});

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       initiallyExpanded: true,
//       iconColor: Colors.white,
//       collapsedIconColor: Colors.white,
//       title: Row(
//         children: [
//           // Icon(title.toLowerCase().contains('private') ? Icons.person_outline : Icons.groups_outlined, size: 20, color: Colors.white),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//       collapsedBackgroundColor: const Color.fromARGB(255, 148, 156, 176).withOpacity(0.3),
//       backgroundColor: const Color.fromARGB(255, 147, 168, 196).withOpacity(0.1),
//       childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       children: goals.map((goal) => GoalRow(title: goal.goalName, totalAmount: goal.targetAmount, savedAmount: goal.savedAmount, goal:goal, statuses: goal.monthlyStatuses.map((e) => e.status).toList().cast<String>(),)).toList(),
//     );
//   }
// }