import 'package:flutter/material.dart';

class BudgetSection extends StatelessWidget {
  final String title;
  final IconData? leadingIcon; // 🆕 нэмэлт icon
  final List<Map<String, dynamic>> items;
  final Widget Function(Map<String, dynamic>) itemBuilder;

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
      collapsedBackgroundColor: Color.fromARGB(255, 66, 84, 128).withOpacity(0.3),
      backgroundColor: const Color.fromARGB(255, 66, 84, 128).withOpacity(0.3),
      children: items.map(itemBuilder).toList(),
    );
  }
}
