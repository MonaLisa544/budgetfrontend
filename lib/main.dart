import 'package:budgetfrontend/widgets/common/color_extension.dart';
import 'package:budgetfrontend/views/login/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';  // GetX

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  // GetMaterialApp ашиглаж байна
      title: 'Velo – Track your flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Inter",
        colorScheme: ColorScheme.fromSeed(
          seedColor: TColor.primary,
          background: TColor.gray10,
          primary: TColor.primary,
          primaryContainer: TColor.gray60,
          secondary: TColor.white,
        ),
        useMaterial3: false,
      ),
      home: const SignInView(),
    );
  }
}
