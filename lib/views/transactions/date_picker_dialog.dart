import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerDialog extends StatelessWidget {
  const DatePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Date'),
      content: CalendarDatePicker(
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        onDateChanged: (selectedDate) {
          Navigator.of(context).pop(selectedDate); // Return selected date
        },
      ),
    );
  }
}

