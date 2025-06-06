import 'package:flutter/material.dart';

class MonthYearSelector extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(DateTime newDate) onChanged;

  const MonthYearSelector({
    super.key,
    required this.selectedDate,
    required this.onChanged,
  });

  String get formatted =>
      "  ${_monthName(selectedDate.month)} ${selectedDate.year}";

  @override
  Widget build(BuildContext context) {
    final lastAllowedDate = DateTime(2025, 6); // 6-р сар бол сүүлчийнх

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ⬅️ Өмнөх сар руу шилжих сум (боломжтой үргэлж)
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              DateTime newDate = DateTime(
                selectedDate.month == 1
                    ? selectedDate.year - 1
                    : selectedDate.year,
                selectedDate.month == 1 ? 12 : selectedDate.month - 1,
              );
              onChanged(newDate);
            },
          ),

          // 🗓 Сар, жил харуулах
          Row(
            children: [
              SizedBox(width: 40),
              Icon(Icons.calendar_today, size: 22, color: const Color.fromARGB(255, 255, 255, 255)),
              Text(
                formatted,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
                IconButton(
      icon: Icon(Icons.download_rounded, color: Colors.white),
      onPressed: () {
        // downloadTransaction(txn);
      },
    ),
            ],
          ),

          // ➡️ Дараагийн сар руу шилжих сум (боломжгүй бол null)
          selectedDate.year < lastAllowedDate.year ||
                  (selectedDate.year == lastAllowedDate.year &&
                      selectedDate.month < lastAllowedDate.month)
              ? IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  DateTime newDate = DateTime(
                    selectedDate.month == 12
                        ? selectedDate.year + 1
                        : selectedDate.year,
                    selectedDate.month == 12 ? 1 : selectedDate.month + 1,
                  );
                  onChanged(newDate);
                },
              )
              : const SizedBox(width: 48), // ➡️ сумны оронд хоосон зай үлдээнэ
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }
}