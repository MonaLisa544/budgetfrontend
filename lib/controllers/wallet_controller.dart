import 'package:get/get.dart';
import 'package:budgetfrontend/services/auth_service.dart';
import 'package:budgetfrontend/models/wallet_model.dart';

class WalletController extends GetxController {
  var myWallet = Rxn<WalletModel>();
  var familyWallet = Rxn<WalletModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchWallets() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final my = await AuthService.fetchMyWallet();
      final family = await AuthService.fetchFamilyWallet();

      if (my != null) {
        myWallet.value = my;
      } else {
        errorMessage.value = "My Wallet татаж чадсангүй.";
      }

      if (family != null) {
        familyWallet.value = family;
      } else {
        errorMessage.value = "Family Wallet татаж чадсангүй.";
      }

    } catch (e) {
      errorMessage.value = "Wallet татах үед алдаа гарлаа: $e";
    } finally {
      isLoading.value = false;
    }
  }

   Future<void> updateMyWalletBalance(double newBalance) async {
    final success = await AuthService.updateMyWalletBalance(newBalance);
    if (success) {
      await fetchWallets(); // дахин татна
    }
  }

  Future<void> updateFamilyWalletBalance(double newBalance) async {
    final success = await AuthService.updateFamilyWalletBalance(newBalance);
    if (success) {
      await fetchWallets(); // дахин татна
    }
  }
}

