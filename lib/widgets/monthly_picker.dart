import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthYearPickerButton extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onChanged;

  const MonthYearPickerButton({
    Key? key,
    required this.initialDate,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<MonthYearPickerButton> createState() => _MonthYearPickerButtonState();
}

class _MonthYearPickerButtonState extends State<MonthYearPickerButton> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  void pickExpectedDate(BuildContext context) {
    DateTime tempPickedDate = selectedDate;
    showCupertinoModalPopup(
      context: context,
      useRootNavigator: true,
      builder: (popupContext) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.monthYear,
                initialDateTime: selectedDate,
                minimumDate: DateTime(2020, 1, 1),
                maximumDate: DateTime(2035, 12, 31),
                onDateTimeChanged: (DateTime newDate) {
                  tempPickedDate = newDate;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  child: const Text('OK', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    setState(() {
                      selectedDate = tempPickedDate;
                    });
                    widget.onChanged(selectedDate);
                    Navigator.of(popupContext).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  final formattedMonthYear = "${selectedDate.month}-р сар ${selectedDate.year}";
  return Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(22),
    child: InkWell(
      onTap: () => pickExpectedDate(context),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formattedMonthYear,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 7),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    ),
  );
}
}
