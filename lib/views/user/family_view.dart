import 'dart:ui';
import 'package:budgetfrontend/controllers/family_controller.dart';
import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FamilyController familyController = Get.find<FamilyController>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 245, 255),
      appBar: BackAppBar(title: 'Family'),
      body: Stack(
        fit: StackFit.expand,
        children: [
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // 🏠 Family нэр (динамик Obx)
                  Obx(() {
                    final familyName = familyController.family.value?.familyName ?? 'Family';
                    return Text(
                      familyName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    );
                  }),
                  const SizedBox(height: 15),
                  // 👨‍👩‍👧‍👦 Гишүүд жагсаалт (динамик Obx)
                  SizedBox(
                    height: 110,
                    child: Obx(() {
                      if (familyController.isLoadingMembers.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final members = familyController.familyMembers;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: members.length + 1, // Нэмэх товч + гишүүд
                        itemBuilder: (context, index) {
                          if (index == members.length) {
                            return _buildAddMemberButton();
                          }
                          final member = members[index];
                          return _buildFamilyMember(member.firstName, member.profilePhotoUrl ?? '');
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Text("Manage family", style: TextStyle(fontSize: 16),),
                   const SizedBox(height: 10),
                  // 📦 Цагаан box Manage Family хэсэг
                  Container(
                    width: double.infinity,
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
                        _FamilyTile(
                          icon: Icons.edit,
                          text: 'Edit Family Name',
                          onTap: () {
                            print('Edit Family Name');
                          },
                        ),
                        const Divider(height: 1),
                        _FamilyTile(
                          icon: Icons.lock_outline,
                          text: 'Change Password',
                          onTap: () {
                            print('Change Password');
                          },
                        ),
                        const Divider(height: 1),
                        _FamilyTile(
  icon: Icons.exit_to_app,
  text: 'Leave Family',
  color: Colors.red, // ✅ Ингэж улаан болгоно
  onTap: () {
    print('Leave Family');
  },
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

 Widget _buildFamilyMember(String name, String avatarUrl, {String role = 'Member', String email = ''}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: GestureDetector(
      onTap: () {
        _showMemberDetailSheet(name, email, role);
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 68, 127, 255).withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              backgroundImage: avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : const AssetImage('assets/img/default_user_profile.png') as ImageProvider,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 70,
            child: Column(
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: role == 'Owner' ? Colors.orange : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildAddMemberButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          print('➕ Add Member');
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.2),
              ),
              child: const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.add, color: Colors.black54, size: 28),
              ),
            ),
            const SizedBox(height: 6),
            const SizedBox(
              width: 60,
              child: Text(
                "Нэмэх",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
 void _showMemberDetailSheet(String fullName, String email, String currentRole) {
  String selectedRole = currentRole; // анх Role-ийг сонгосон
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Баруун дээд буланд delete icon
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    print('🔴 Remove clicked!');
                    Get.back();
                    // TODO: Remove Member API дуудахад бэлдэх
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Овог нэр
            const Text(
              "Нэр",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              fullName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Мэйл хаяг
            const Text(
              "И-Мэйл",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              email,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Role
            const Text(
              "Role",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: selectedRole,
                isExpanded: true,
                underline: const SizedBox(),
                items: ['Owner', 'Member'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newRole) {
                  if (newRole != null) {
                    selectedRole = newRole;
                    Get.back();
                    _showMemberDetailSheet(fullName, email, selectedRole); // refresh хийж дуудаж байна
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            // Save button
            ElevatedButton.icon(
              onPressed: () {
                print('🔵 Save clicked! Selected Role: $selectedRole');
                Get.back(); 
                // TODO: API call хийх
              },
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size.fromHeight(45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
}

class _FamilyTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final Color color; // ✅ Өнгө нэмлээ!

  const _FamilyTile({Key? key, required this.icon, required this.text, this.onTap, this.color = Colors.black87})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(fontSize: 16, color: color)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
      onTap: onTap,
    );
  }
}

