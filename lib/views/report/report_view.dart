import 'package:budgetfrontend/views/main_tab/main_bar_view.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // Import this to use ImageFilter

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: MainBarView(
        title: 'Reports',
        onNotfPressed: () {},
        onProfilePressed: () {},
      ),
      body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/background/background14.jpeg',
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 99, sigmaY: 50),
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color.fromARGB(255, 57, 186, 196),
                ],
                stops: [0.5, 1.0],
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(

          ),
        )
      ],
    ),
    );
  }
}
