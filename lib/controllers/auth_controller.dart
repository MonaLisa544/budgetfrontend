import 'dart:io';

import 'package:budgetfrontend/controllers/wallet_controller.dart';
import 'package:budgetfrontend/models/user_model.dart';
import 'package:budgetfrontend/views/home/main_tab_view.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isPasswordVisible = true.obs;
  var isConfirmPasswordVisible = true.obs;
  var hasFamily = false.obs;
  var user = Rxn<UserModel>();

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    bool success = await AuthService.login(email, password);
    isLoading.value = false;

    if (success) {
      String? token = await AuthService.getToken();
      if (token != null) {
        Get.snackbar('Success', 'Logged in successfully');
         Get.offAll(() {
        Get.put(WalletController()); // 👉 ЭНД WalletController-оо бүртгэнэ
        return MainTabView();
      }); 
        await fetchUser();// Navigate to main tab
      }
    } else {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }
  Future<bool> joinFamily(String familyName, String password) async {
  isLoading.value = true;
  try {
    bool result = await AuthService.joinFamily(
      familyName: familyName,
      password: password,
    );
    if (result) {
      // Амжилттай бол хэрэглэгчийн мэдээллийг дахин татаж, UI шинэчилнэ!
      await fetchUser();
      hasFamily.value = true;
      Get.snackbar('Амжилттай', 'Гэр бүлд амжилттай нэгдлээ!');
    } else {
      Get.snackbar('Алдаа', 'Гэр бүлд нэгдэхэд алдаа гарлаа!');
    }
    return result;
  } finally {
    isLoading.value = false;
  }
}

  Future<void> signup(String lastName, String firstName, String email, String password, String passwordConfirmation) async {
    isLoading.value = true;
    bool success = await AuthService.signup(lastName, firstName, email, password, passwordConfirmation);
    isLoading.value = false;

    if (success) {
       await fetchUser();// Navigate to main tab
      Get.snackbar('Success', 'Account created');
       Get.offAll(() {
        Get.put(WalletController()); // 👉 ЭНД WalletController-оо бүртгэнэ
        return MainTabView();
      });   // Navigate to the main tab
    } else {
      Get.snackbar('Error', 'Signup failed');
    }
  }
 Future<void> fetchUser() async {
  try {
    isLoading.value = true;
    print("✅ fetchUser эхэлж байна...");

    UserModel? fetchedUser = await AuthService.getMe();

    if (fetchedUser != null) {
      user.value = fetchedUser;
      hasFamily.value = fetchedUser.familyId != null;
      print("✅ User data амжилттай татлаа: ${fetchedUser.firstName} (${fetchedUser.email})");
    } else {
      print("❌ User fetch хоосон байна!");
    }

  } catch (e, stackTrace) {
    print("❌ fetchUser алдаа гарлаа: $e");
    print("🛠 StackTrace: $stackTrace");
    Get.snackbar('Error', 'User мэдээлэл татаж чадсангүй.');
  } finally {
    isLoading.value = false;
    print("✅ fetchUser дууслаа");
  }
}
Future<bool> updateProfile({
  required String firstName,
  required String lastName,
  required String email,
  File? profilePhotoFile, // ✅ ЭНЭ БАЙХ ЁСТОЙ
}) async {
  try {
    isLoading.value = true;
    bool success = await AuthService.updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      profilePhotoFile: profilePhotoFile, // ✅ ЭНЭГҮЙ бол алдаа гарна
    );
    if (success) {
      await fetchUser(); // ✅ update хийсний дараа дахин шинэчилж авна
    }
    return success;
  } finally {
    isLoading.value = false;
  }
}

Future<bool> changePassword({
  required String currentPassword,
  required String newPassword,
  required String confirmPassword,
}) async {
  try {
    isLoading.value = true;
    bool success = await AuthService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    if (success) {
      Get.snackbar('Success', 'Нууц үг амжилттай солигдлоо');
    } else {
      Get.snackbar('Error', 'Нууц үг солих үед алдаа гарлаа');
    }
    return success;
  } finally {
    isLoading.value = false;
  }
}


  

    Future<void> logout() async {
    await AuthService.logout();
    user.value = null;
    Get.offAll(() => const MainTabView()); // logout хийсэн бол main screen рүү оруулах
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  


  // ----------------------------------

  
}
