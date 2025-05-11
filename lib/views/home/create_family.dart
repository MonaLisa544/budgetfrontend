import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';
import 'package:flutter/material.dart';

Future<String?> showFamilyDialog(BuildContext context) {
  return showModalBottomSheet<String>(  // 👈 String буцаана
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlueTextFieldTheme(
      child: const FamilyDialogContent(),
    ),
  );
}

class FamilyDialogContent extends StatefulWidget {
  const FamilyDialogContent({super.key});

  @override
  State<FamilyDialogContent> createState() => _FamilyDialogContentState();
}

class _FamilyDialogContentState extends State<FamilyDialogContent> {
  bool isCreate = true;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _familyNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      maxChildSize: 0.9,
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
              Center(
                child: Text(
                  isCreate ? "Гэр бүл үүсгэх" : "Гэр бүлд элсэх",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ToggleButtons(
                isSelected: [isCreate, !isCreate],
                onPressed: (index) {
                  setState(() {
                    isCreate = index == 0;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                selectedColor: Colors.white,
                fillColor: Colors.blue,
                color: Colors.black54,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("🏠 Үүсгэх"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("👨‍👩‍👧‍👦 Элсэх"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _familyNameController,
                decoration: InputDecoration(
                  labelText: "Гэр бүлийн нэр",
                  labelStyle: const TextStyle(color: Colors.black54),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 149, 149, 150)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Нууц үг",
                  labelStyle: const TextStyle(color: Colors.black54),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,  color: Color.fromARGB(255, 164, 164, 165)),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 149, 149, 150)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              if (isCreate) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: "Нууц үг баталгаажуулах",
                    labelStyle: const TextStyle(color: Colors.black54),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,  color: const Color.fromARGB(255, 164, 164, 165),),
                      onPressed: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color.fromARGB(255, 149, 149, 150)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  final name = _familyNameController.text.trim();
                  final password = _passwordController.text.trim();
                  final confirm = _confirmController.text.trim();

                  if (name.isEmpty || password.isEmpty || (isCreate && confirm.isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Бүх талбарыг бөглөнө үү")),
                    );
                    return;
                  }

                  if (isCreate && password != confirm) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Нууц үг таарахгүй байна")),
                    );
                    return;
                  }

                  if (isCreate) {
                    print("👨‍👩‍👧‍👦 Үүсгэж байна: $name, $password");
                  } else {
                    print("👥 Элсэж байна: $name, $password");
                  }

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(45),
                ),
                icon: Icon(isCreate ? Icons.add : Icons.group_add),
                label: Text(isCreate ? "Гэр бүл үүсгэх" : "Гэр бүлд элсэх"),
              )
            ],
          ),
        );
      },
    );
  }
}