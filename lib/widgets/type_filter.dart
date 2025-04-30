import 'package:flutter/material.dart';

class TypeFilter extends StatelessWidget {
  final String selectedType;
  final Function(String) onSelected;

  const TypeFilter({super.key, required this.selectedType, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['All', 'Income', 'Expense'].map((type) {
        return ChoiceChip(
          label: Text(type),
          selected: selectedType == type,
          onSelected: (_) => onSelected(type),
          selectedColor: Colors.blueAccent,
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: Colors.white24,
        );
      }).toList(),
    );
  }
}
