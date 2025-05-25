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
    final Color blue = Colors.blue[700]!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      titlePadding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 0),
      contentPadding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 24),
      title: Center(
        child: Text(
          " Хугацаа сонгох",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: blue,
            fontSize: 20,
            letterSpacing: 0.2,
          ),
        ),
      ),
      content: SizedBox(
        width: 320,
        height: 410,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.04),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: dp.RangePicker(
                selectedPeriod: _selectedPeriod,
                onChanged: (dp.DatePeriod newPeriod) {
                  setState(() => _selectedPeriod = newPeriod);
                },
                firstDate: _firstDate,
                lastDate: _lastDate,
                datePickerStyles: dp.DatePickerRangeStyles(
                  selectedPeriodLastDecoration: BoxDecoration(
                    color: blue,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  selectedPeriodStartDecoration: BoxDecoration(
                    color: blue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  selectedPeriodMiddleDecoration: BoxDecoration(
                    color: blue.withOpacity(0.3),
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: blue, // ТОВЧНЫ ӨНГӨ!
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                icon: const Icon(Icons.check, size: 22),
                label: const Text("Тохируулах"),
                onPressed: () {
                  Navigator.of(context).pop([
                    _selectedPeriod.start,
                    _selectedPeriod.end,
                  ]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
