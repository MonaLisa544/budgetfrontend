import 'package:get/get.dart';
import '../models/transaction_model.dart';
import '../services/api_service.dart';

class TransactionController extends GetxController {
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

   Future<void> loadTransactions() async {
    isLoading.value = true;
    try {
      final list = await ApiService.getTransactions();
      transactions.assignAll(list);
    } catch (e) {
      Get.snackbar('Алдаа', 'Гүйлгээ татаж чадсангүй');
    } finally {
      isLoading.value = false;
    }
  }

  
Future<void> createTransaction(TransactionModel txn, String type) async {
  isLoading.value = true;
  try {
    final newTxn = await ApiService.postTransactionWithType(txn, type);
    if (newTxn != null) {
      transactions.add(newTxn);
      Get.back(); // form хаагдана
    }
  } catch (e) {
    Get.snackbar('Алдаа', 'Гүйлгээ үүсгэж чадсангүй');
  } finally {
    isLoading.value = false;
  }
}

  Future<void> updateTransaction(TransactionModel txn) async {
    isLoading.value = true;
    try {
      final updated = await ApiService.updateTransaction(txn);
      final index = transactions.indexWhere((t) => t.id == txn.id);
      if (index != -1 && updated != null) {
        transactions[index] = updated;
      }
    } catch (e) {
      Get.snackbar('Алдаа', 'Гүйлгээ шинэчлэхэд алдаа гарлаа');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTransaction(int id) async {
    isLoading.value = true;
    try {
      final success = await ApiService.deleteTransaction(id);
      if (success) transactions.removeWhere((t) => t.id == id);
    } catch (e) {
      Get.snackbar('Алдаа', 'Гүйлгээ устгах үед алдаа гарлаа');
    } finally {
      isLoading.value = false;
    }
  }
}
