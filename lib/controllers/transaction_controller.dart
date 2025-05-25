import 'dart:ui';

import 'package:flutter/material.dart';
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
    loadTransactions();
    if (newTxn != null) {
      transactions.add(newTxn);

      // Амжилтын snackbar controller дээр шууд харуулна
      Get.snackbar(
        'Амжилттай', // Title
        'Гүйлгээ амжилттай үүслээ',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      // **0.7 секунд хүлээгээд дараа нь хаана**
      await Future.delayed(const Duration(milliseconds: 700));
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
