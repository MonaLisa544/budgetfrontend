import 'package:budgetfrontend/views/main_tab/main_tab_view.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isPasswordVisible = true.obs;
  var isConfirmPasswordVisible = true.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    bool success = await AuthService.login(email, password);
    isLoading.value = false;

    if (success) {
      String? token = await AuthService.getToken();
      if (token != null) {
        Get.snackbar('Success', 'Logged in successfully');
        Get.offAll(() => MainTabView()); // Navigate to main tab
      }
    } else {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }

  Future<void> signup(String lastName, String firstName, String email, String password, String passwordConfirmation) async {
    isLoading.value = true;
    bool success = await AuthService.signup(lastName, firstName, email, password, passwordConfirmation);
    isLoading.value = false;

    if (success) {
      Get.snackbar('Success', 'Account created');
      Get.offAll(() => MainTabView());  // Navigate to the main tab
    } else {
      Get.snackbar('Error', 'Signup failed');
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
}
