import 'package:get/get.dart';
import 'package:budgetfrontend/models/goal_model.dart';
import 'package:budgetfrontend/services/api_service.dart';

class GoalController extends GetxController {
  final RxList<GoalModel> goals = <GoalModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGoals();
  }

  Future<void> fetchGoals() async {
    try {
      isLoading.value = true;
      final result = await ApiService.fetchGoals();
      goals.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load goals');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createGoal(GoalModel goal) async {
    try {
      isLoading.value = true;
      final newGoal = await ApiService.createGoal(goal);
      if (newGoal != null) {
        goals.add(newGoal);
        Get.back();
        Get.snackbar('Success', 'Goal created successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create goal');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateGoal(GoalModel goal) async {
    try {
      isLoading.value = true;
      final updatedGoal = await ApiService.updateGoal(goal);
      if (updatedGoal != null) {
        final index = goals.indexWhere((g) => g.id == updatedGoal.id);
        if (index != -1) {
          goals[index] = updatedGoal;
          Get.back();
          Get.snackbar('Success', 'Goal updated successfully');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update goal');
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> deleteGoal(int id) async {
  //   try {
  //     isLoading.value = true;
  //     final success = await ApiService.deleteGoal(id);
  //     if (success) {
  //       goals.removeWhere((g) => g.id == id);
  //       Get.snackbar('Success', 'Goal deleted successfully');
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to delete goal');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
