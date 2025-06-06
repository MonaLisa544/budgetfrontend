import 'dart:ui';
import 'package:budgetfrontend/controllers/auth_controller.dart';
import 'package:budgetfrontend/services/auth_service.dart';
import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:budgetfrontend/views/login/sign_in_view.dart';
import 'package:budgetfrontend/views/report/export.dart';
import 'package:budgetfrontend/views/transactions/category_view.dart';
import 'package:budgetfrontend/views/user/edit_profile.dart';
import 'package:budgetfrontend/views/user/family_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 245, 255),
      appBar: BackAppBar(title: 'Хувийн мэдээлэл'),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(height: 20),
          Image.asset('assets/icon/background15.jpg', fit: BoxFit.cover),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 235, 245, 255),
                    Colors.transparent,
                  ],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(() {
  final user = authController.user.value;
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: const Color.fromARGB(255, 113, 145, 192),
        width: 3,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 80, 133, 247).withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: CircleAvatar(
      radius: 45,
      backgroundColor: Colors.white,
      backgroundImage: user?.profilePhotoUrl != null
          ? NetworkImage(user!.profilePhotoUrl!)
          : const AssetImage('assets/img/default_profile.png') as ImageProvider,
    ),
  );
}),
                      // CircleAvatar(
                      //   backgroundColor: Colors.blue,
                      //   radius: 14,
                      //   child: const Icon(
                      //     Icons.edit,
                      //     size: 14,
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    final user = authController.user.value;
                    return Text(
                      user != null ? '${user.firstName} ${user.lastName}' : '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    );
                  }),
                  const SizedBox(height: 4),
                  Obx(() {
                    final user = authController.user.value;
                    return Text(
                      user?.email ?? '',
                      style: const TextStyle(color: Color.fromARGB(255, 66, 66, 66)),
                    );
                  }),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _ProfileTile(
                          icon: Icons.person_outline,
                          text: 'Бүртгэл',
                          onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileView()),
    );
  },
                        ),
                        const Divider(height: 1),
                        _ProfileTile(
                          icon: Icons.folder_copy,
                          text: 'Ангилал',
                           onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryManagePage()),
    );
  },
                        ),
                        const Divider(height: 1),
                        _ProfileTile(
                          icon: Icons.share,
                          text: 'Гэр бүл',
                           onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FamilyScreen()),
    );
  },
                        ),
                        const Divider(height: 1),

                           _ProfileTile(
                          icon: Icons.import_export,
                          text: 'Тайлан хэвлэх',
                           onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExportDataScreen()),
    );
  },
                        ),
                        const Divider(height: 1),
                        
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text(
                            'Гарах',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                         onTap: () async {
  await AuthService.logout();
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => SignInView()), // LoginView-ээ энд оруулна
    (route) => false,
  );
}
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap; // ✅ Нэмнэ!

  const _ProfileTile({Key? key, required this.icon, required this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap, // ✅ Нэмж өгнө
    );
  }
}
