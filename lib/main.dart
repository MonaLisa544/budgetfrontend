import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart'; // ← энэ шаардлагатай!
import 'package:budgetfrontend/controllers/transaction_controller.dart';
import 'package:budgetfrontend/widgets/common/color_extension.dart';
import 'package:budgetfrontend/views/login/sign_in_view.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('mn', null); // ← Монгол локаль тохируулах
  Get.put(TransactionController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initOneSignal();
  }

  void initOneSignal() async {
    OneSignal.initialize('5654fdcb-6bda-4236-8a37-3bf63f5874ed');
    await OneSignal.Notifications.requestPermission(true);

    OneSignal.User.pushSubscription.addObserver((state) {
      String? playerId = state.current.id;
      print('🔥 Player ID (observer): $playerId');
    });

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
