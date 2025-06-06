import 'package:budgetfrontend/models/budget_model.dart';
import 'package:flutter/material.dart';

class BudgetSection extends StatefulWidget {
  final String title;
  final IconData? leadingIcon;
  final List<BudgetModel> items;
  final Widget Function(BudgetModel) itemBuilder;

  const BudgetSection({
    super.key,
    required this.title,
    this.leadingIcon,
    required this.items,
    required this.itemBuilder,
  });

  @override
  State<BudgetSection> createState() => _BudgetSectionState();
}

class _BudgetSectionState extends State<BudgetSection> {
  bool _expanded = true;

  @override
Widget build(BuildContext context) {
  final Color titleColor = _expanded ? const Color.fromARGB(255, 116, 116, 116)! : Colors.white;

  return ExpansionTile(
    initiallyExpanded: true,
    onExpansionChanged: (expanded) {
      setState(() {
        _expanded = expanded;
      });
    },
    title: Row(
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: titleColor,
          ),
        ),
      ],
    ),
    iconColor: titleColor,
    collapsedIconColor: Colors.white,
    childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
    collapsedBackgroundColor: const Color.fromARGB(255, 177, 177, 177).withOpacity(0.3),
    backgroundColor: const Color.fromARGB(255, 240, 245, 255).withOpacity(0.8),
    children: [
      if (widget.items.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Төсөв байхгүй',
            style: TextStyle(color: const Color.fromARGB(179, 0, 0, 0), fontSize: 15),
          ),
        )
      else
        Container(
          margin: const EdgeInsets.only(top: 0, bottom: 20),
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: List.generate(widget.items.length * 2 - 1, (i) {
              if (i.isEven) {
                final idx = i ~/ 2;
                return widget.itemBuilder(widget.items[idx]);
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(
                    color: const Color.fromARGB(255, 83, 83, 83).withOpacity(0.18),
                    thickness: 1.5,
                    height: 6,
                  ),
                );
              }
            }),
          ),
        ),
    ],
  );
}

  }
