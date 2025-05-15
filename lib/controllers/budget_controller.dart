import 'package:budgetfrontend/services/api_service.dart';
import 'package:get/get.dart';
import 'package:budgetfrontend/models/budget_model.dart';
class BudgetController extends GetxController {
  var budgets = <BudgetModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchBudgets();
    super.onInit();
  }

  void fetchBudgets() async {
    try {
      isLoading(true);
      var fetched = await ApiService.fetchBudgets();
      budgets.value = fetched;
    } catch (e) {
      print("Failed to fetch budgets: $e");
    } finally {
      isLoading(false);
    }
  }
   Future<void> createBudget(BudgetModel budget) async {
    await ApiService.createBudget(budget);
    fetchBudgets(); // ✅ автоматаар шинэчлэх
  }

  Future<void> updateBudget(int id, BudgetModel budget) async {
    await ApiService.updateBudget(id, budget);
    fetchBudgets(); // ✅ автоматаар шинэчлэх
  }

  Future<void> deleteBudget(int id) async {
  await ApiService.deleteBudget(id);
  fetchBudgets(); // ✅ автоматаар шинэчлэх
}
}