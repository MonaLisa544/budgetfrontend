import 'package:budgetfrontend/controllers/auth_controller.dart';
import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showPasswordChangeDialog(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const BlueTextFieldTheme(
      child: PasswordChangeContent(),
    ),
  );
}

class PasswordChangeContent extends StatefulWidget {
  const PasswordChangeContent({super.key});

  @override
  State<PasswordChangeContent> createState() => _PasswordChangeContentState();
}

class _PasswordChangeContentState extends State<PasswordChangeContent> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      maxChildSize: 0.8,
      minChildSize: 0.4,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Нууц үг солих",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _currentPasswordController,
                label: "Одоогийн нууц үг",
                obscureText: _obscureCurrent,
                toggle: () {
                  setState(() {
                    _obscureCurrent = !_obscureCurrent;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildPasswordField(
                controller: _newPasswordController,
                label: "Шинэ нууц үг",
                obscureText: _obscureNew,
                toggle: () {
                  setState(() {
                    _obscureNew = !_obscureNew;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: "Шинэ нууц үг баталгаажуулах",
                obscureText: _obscureConfirm,
                toggle: () {
                  setState(() {
                    _obscureConfirm = !_obscureConfirm;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
               onPressed: () async {
  final current = _currentPasswordController.text.trim();
  final newPassword = _newPasswordController.text.trim();
  final confirmPassword = _confirmPasswordController.text.trim();

  if (current.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Бүх талбарыг бөглөнө үү")),
    );
    return;
  }

  if (newPassword != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Шинэ нууц үг таарахгүй байна")),
    );
    return;
  }

  final authController = Get.find<AuthController>(); // ✅ AuthController олж авна
  final success = await authController.changePassword(
    currentPassword: current,
    newPassword: newPassword,
    confirmPassword: confirmPassword,
  );

  if (success) {
    Navigator.pop(context); // ✅ Хэрвээ амжилттай бол BottomSheet хаана
  }
},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(45),
                ),
                icon: const Icon(Icons.lock_reset),
                label: const Text("Нууц үг солих"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: const Color.fromARGB(255, 164, 164, 165),
          ),
          onPressed: toggle,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 149, 149, 150)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

