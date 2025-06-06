import 'package:budgetfrontend/widgets/budget_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class MonthlySummary extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;
  final double familyUsed;
  final double familyTotal;
  final double privateUsed;
  final double privateTotal;

  const MonthlySummary({
    super.key,
    required this.selectedDate,
    required this.onChanged,
    required this.familyUsed,
    required this.familyTotal,
    required this.privateUsed,
    required this.privateTotal,
  });

  @override
  State<MonthlySummary> createState() => _MonthlySummaryState();
}

class _MonthlySummaryState extends State<MonthlySummary> {
  late List<DateTime> months;
  late int selectedIndex;
  late int currentMonthIndex;
  late PageController _pageController;
  double wavePhase = 0.0;

  @override
  void initState() {
    super.initState();
    _generateMonths();
    currentMonthIndex = months.indexWhere((d) =>
        d.year == DateTime.now().year && d.month == DateTime.now().month);
    if (currentMonthIndex == -1) currentMonthIndex = months.length - 2;
    selectedIndex = months.indexWhere((d) =>
        d.year == widget.selectedDate.year && d.month == widget.selectedDate.month);
    if (selectedIndex == -1) selectedIndex = currentMonthIndex;
    _pageController = PageController(
      viewportFraction: 0.55,
      initialPage: selectedIndex,
    );
    _pageController.addListener(_onPageChanged);
  }

  @override
  void didUpdateWidget(covariant MonthlySummary oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newIndex = months.indexWhere((d) =>
        d.year == widget.selectedDate.year && d.month == widget.selectedDate.month);
    if (newIndex != -1 && newIndex != selectedIndex) {
      selectedIndex = newIndex;
      _pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final pos = _pageController.page ?? selectedIndex.toDouble();
    setState(() {
      wavePhase = (pos - currentMonthIndex) * pi / 3;
    });
  }

  void _generateMonths() {
    final now = DateTime.now();
    final monthsList = <DateTime>[];
    for (int i = 6; i >= 1; i--) {
      int y = now.year;
      int m = now.month - i;
      while (m <= 0) {
        m += 12;
        y -= 1;
      }
      monthsList.add(DateTime(y, m));
    }
    monthsList.add(DateTime(now.year, now.month));
    int y = now.year;
    int m = now.month + 1;
    if (m > 12) {
      m = 1;
      y += 1;
    }
    monthsList.add(DateTime(y, m));
    months = monthsList;
  }

  double waveY(double x, double width) {
    return 30 + sin((x / width * 2 * pi) + wavePhase) * 6;
  }

  String formatCurrency(double value) {
    final formatter = NumberFormat("#,##0", "mn");
    return "₮${formatter.format(value)}";
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = months[selectedIndex];

    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 70,
          child: PageView.builder(
            controller: _pageController,
            itemCount: months.length,
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
              widget.onChanged(months[index]);
            },
            itemBuilder: (context, index) {
              final date = months[index];
              final isSelected = index == selectedIndex;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  // color: isSelected ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.06),
                  // border: isSelected ? Border.all(color: Colors.white.withOpacity(0.48), width: 1.2) : null,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.07),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${date.month}-р сар ${date.year}',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.65),
                        fontSize: isSelected ? 18 : 15,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        letterSpacing: 0.14,
                      ),
                    ),
                    
                    // BudgetSummaryCard(
                    //   familyTotal: widget.familyTotal,
                    //   familyUsed: widget.familyUsed,
                    //   privateTotal: widget.privateTotal,
                    //   privateUsed: widget.privateUsed,
                    // ),
                   
                  ],
                ),
              );
            },
          ),
        ),
        // const SizedBox(height: 10),
       
        SizedBox(
          height: 60,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final step = constraints.maxWidth / months.length;
              double dotX;
              if (selectedIndex == currentMonthIndex) {
                dotX = constraints.maxWidth / 2;
              } else {
                final delta = selectedIndex - currentMonthIndex;
                dotX = constraints.maxWidth / 2 + step * delta;
              }
              final dotY = waveY(dotX, constraints.maxWidth);
              return Stack(
                children: [
                  CustomPaint(
                    size: Size(constraints.maxWidth, 60),
                    painter: WaveLinePainter(wavePhase: wavePhase),
                  ),
                  Positioned(
                    left: dotX - 9,
                    top: dotY - 9,
                    child: GlowDot(),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class WaveLinePainter extends CustomPainter {
  final double wavePhase;
  WaveLinePainter({required this.wavePhase});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (double x = 0; x <= size.width; x++) {
      double y = size.height / 2 + sin((x / size.width * 2 * pi) + wavePhase) * 6;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaveLinePainter oldDelegate) => oldDelegate.wavePhase != wavePhase;
}

class GlowDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
