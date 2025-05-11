import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

class TimelineDateRangeDialog extends StatefulWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;

  const TimelineDateRangeDialog({
    super.key,
    this.initialStart,
    this.initialEnd,
  });

  @override
  State<TimelineDateRangeDialog> createState() => _TimelineDateRangeDialogState();
}

class _TimelineDateRangeDialogState extends State<TimelineDateRangeDialog> {
  late DateTime _firstDate;
  late DateTime _lastDate;
  late dp.DatePeriod _selectedPeriod;

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime(2020);
    _lastDate = DateTime(2030);

    final start = widget.initialStart ?? DateTime.now().subtract(const Duration(days: 7));
    final end = widget.initialEnd ?? DateTime.now();
    _selectedPeriod = dp.DatePeriod(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("🗓 Хугацаа сонгох"),
      content: SizedBox(
        width: 320,
        height: 400,
        child: Column(
          children: [
            dp.RangePicker(
              selectedPeriod: _selectedPeriod,
              onChanged: (dp.DatePeriod newPeriod) {
                setState(() => _selectedPeriod = newPeriod);
              },
              firstDate: _firstDate,
              lastDate: _lastDate,
              datePickerStyles: dp.DatePickerRangeStyles(
                selectedPeriodLastDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                selectedPeriodStartDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                selectedPeriodMiddleDecoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.5),
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Тохируулах"),
              onPressed: () {
                Navigator.of(context).pop([
                  _selectedPeriod.start,
                  _selectedPeriod.end,
                ]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
