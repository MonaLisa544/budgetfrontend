import 'package:get/get.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryController extends GetxController {
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxString currentType = 'expense'.obs;
  final RxBool isLoading = false.obs;

  List<CategoryModel> get filteredCategories =>
      categories.where((c) => c.transactionType.toLowerCase() == currentType.value.toLowerCase()).toList();

  @override
  void onInit() {
    super.onInit();
    loadCategories(currentType.value);
  }

  Future<void> loadCategories(String type) async {
    isLoading.value = true;
    try {
      currentType.value = type;
      final list = await ApiService.getCategories(type);
      categories.assignAll(list);
    } catch (e) {
      Get.snackbar('Алдаа', 'Категори татаж чадсангүй');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createCategory(CategoryModel category) async {
  isLoading.value = true;
  try {
    final newCategory = await ApiService.createCategory(category);
    if (newCategory != null) {
      categories.add(newCategory);
      Get.snackbar('Амжилттай', 'Категори амжилттай нэмэгдлээ'); // ✅
      return true;
    }
    Get.snackbar('Алдаа', 'Категори үүсгэж чадсангүй');
    return false;
  } catch (e) {
    Get.snackbar('Алдаа', 'Категори үүсгэхэд алдаа гарлаа');
    return false;
  } finally {
    isLoading.value = false;
  }
}

  Future<void> updateCategory(CategoryModel updatedCategory) async {
    isLoading.value = true;
    try {
      final updated = await ApiService.updateCategory(updatedCategory);
      final index = categories.indexWhere((c) => c.id == updatedCategory.id);
      if (index != -1 && updated != null) {
        categories[index] = updated;
      }
    } catch (e) {
      Get.snackbar('Алдаа', 'Категори шинэчлэхэд алдаа гарлаа');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(int id) async {
    isLoading.value = true;
    try {
      final success = await ApiService.deleteCategory(id);
      if (success) categories.removeWhere((c) => c.id == id);
    } catch (e) {
      Get.snackbar('Алдаа', 'Категори устгах үед алдаа гарлаа');
    } finally {
      isLoading.value = false;
    }
  }
}
