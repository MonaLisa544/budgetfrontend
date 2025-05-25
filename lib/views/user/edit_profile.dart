import 'dart:io';
import 'dart:ui';
import 'package:budgetfrontend/controllers/auth_controller.dart';
import 'package:budgetfrontend/views/home/back_app_bar.dart';
import 'package:budgetfrontend/views/user/password_change.dart';
import 'package:budgetfrontend/widgets/blue_field_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final AuthController authController = Get.find();
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  File? pickedImage;

  @override
  void initState() {
    super.initState();
    final user = authController.user.value;
    if (user != null) {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

 Future<void> _saveProfile() async {
  if (_formKey.currentState!.validate()) {
    final success = await authController.updateProfile(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      profilePhotoFile: pickedImage,
    );

    if (success) {
      await authController.fetchUser(); // 🛠 шинэчилж дахин татна
     Navigator.pop(context); // ✅ буцна
    } else {
      Get.snackbar('Алдаа', 'Profile шинэчилж чадсангүй');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 245, 255),
      appBar: BackAppBar(title: 'Edit Profile'),
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
                children: [
                  const SizedBox(height: 25),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                     
                     Container(
  width: 100,
  height: 100,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
      color: const Color.fromARGB(255, 113, 145, 192), // ✅ Border өнгө
      width: 3,                 // ✅ Border өргөн
    ),
    boxShadow: [
      BoxShadow(
        color: const Color.fromARGB(255, 80, 133, 247).withOpacity(0.5), // ✅ Сүүдэр
        spreadRadius: 2,
        blurRadius: 10,
        offset: Offset(0, 4), // доош чиглэсэн сүүдэр
      ),
    ],
  ),
  child: CircleAvatar(
    radius: 45,
    backgroundColor: Colors.white, // ✅ Шилэн нимгэн фон
    backgroundImage: pickedImage != null
        ? FileImage(pickedImage!)
        : (authController.user.value?.profilePhotoUrl != null
            ? NetworkImage(authController.user.value!.profilePhotoUrl!)
            : const AssetImage('assets/img/default_profile.png')) as ImageProvider,
  ),
),
                      GestureDetector(
                        onTap: _showImagePickerOptions,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 14,
                          child: const Icon(Icons.edit, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: media.width,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                   child: BlueTextFieldTheme(
  child: Form(
    key: _formKey,
    child: Column(
      children: [
        SizedBox(height: 15),
        _buildTextField(controller: lastNameController, label: "Овог"),
        const SizedBox(height: 12),
        _buildTextField(controller: firstNameController, label: "Нэр"),
        const SizedBox(height: 12),
        
        _buildTextField(controller: emailController, label: "Мэйл хаяг"),
        const SizedBox(height: 10),
        Align(
  alignment: Alignment.centerLeft,
  child: GestureDetector(
    onTap: () {
  showPasswordChangeDialog(context);
},

    child: Text(
      "нууц үг солих",
      style: TextStyle(
        color: Colors.blue.withOpacity(0.8),
        decoration: TextDecoration.underline,
        fontSize: 14,
      ),
    ),
  ),
),

        const SizedBox(height: 10),
       ElevatedButton(
  onPressed: _saveProfile,
  style: ElevatedButton.styleFrom(
    minimumSize: const Size.fromHeight(48),
    backgroundColor: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
    ),
  ),
  child: const Text(
    'Хадгалах',
    style: TextStyle(fontSize: 16),
  ),
),
const SizedBox(height: 10),
OutlinedButton(
  onPressed: () => Navigator.pop(context),
  style: OutlinedButton.styleFrom(
    side: const BorderSide(color: Colors.blue, width: 1.5),
    minimumSize: const Size.fromHeight(48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
    ),
  ),
  child: const Text(
    'Цуцлах',
    style: TextStyle(color: Colors.blue, fontSize: 16),
  ),
),
      ],
    ),
  ),
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

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: TextStyle(color: const Color.fromARGB(255, 175, 175, 175), fontWeight:  FontWeight.bold), 
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
