import 'dart:ui';
import 'package:budgetfrontend/widgets/budgets_row.dart';
import 'package:budgetfrontend/widgets/option_btn.dart';
import 'package:flutter/material.dart';
import 'package:budgetfrontend/views/home/main_bar_view.dart';
import 'package:budgetfrontend/widgets/common/color_extension.dart';

class Report_View extends StatefulWidget {
  const Report_View({super.key});

  @override
  State<Report_View> createState() => _Report_ViewState();
}

class _Report_ViewState extends State<Report_View> {

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainBarView(
        title: 'Report',
        onNotfPressed: () {},
        onProfilePressed: () {},
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background/background14.jpeg', fit: BoxFit.cover),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 50),
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
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                
                  children: [
                    // ✅ Top Card
                   
                  
                    const SizedBox(height: 5),
                    // ✅ Family Members Horizontal Scroll
                   
                 
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}