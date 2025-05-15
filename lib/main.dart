import 'dart:convert';

import 'package:budgetfrontend/services/auth_service.dart';
import 'package:budgetfrontend/widgets/common/color_extension.dart';
import 'package:budgetfrontend/views/login/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {   // ← StatelessWidget биш StatefulWidget болгосон!
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initOneSignal();  // ← ЭНД OneSignal эхлүүлж байна
  }

void initOneSignal() async {
  OneSignal.initialize('5654fdcb-6bda-4236-8a37-3bf63f5874ed');

  // 🚨 ЭНД ЗААВАЛ permission асуух ёстой
  await OneSignal.Notifications.requestPermission(true);

  // Player ID өөрчлөгдөхийг сонсоно
  OneSignal.User.pushSubscription.addObserver((state) {
    String? playerId = state.current.id;
    print('🔥 Player ID (observer): $playerId');
  });

  // Шууд Player ID авах
  final pushSubscription = await OneSignal.User.pushSubscription;
  String? playerId = pushSubscription.id;
  print('🔥 Player ID (immediate): $playerId');
}
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
