import 'package:budgetfrontend/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:budgetfrontend/models/family_model.dart';
import 'package:budgetfrontend/models/user_model.dart';

class FamilyController extends GetxController {
  var family = Rxn<FamilyModel>();
  var familyMembers = <UserModel>[].obs;

  var isLoadingFamily = false.obs;
  var isLoadingMembers = false.obs;
  var errorMessage = ''.obs;
  
  Future<void> fetchFamilyInfo() async {
    try {
      isLoadingFamily.value = true;
      final familyData = await AuthService.getFamilyInfo();
      if (familyData != null) {
        family.value = familyData;
      }
    } catch (e) {
      errorMessage.value = 'Гэр бүлийн мэдээлэл татахад алдаа гарлаа: $e';
    } finally {
      isLoadingFamily.value = false;
    }
  }

  Future<void> fetchFamilyMembers() async {
    try {
      isLoadingMembers.value = true;
      final membersData = await AuthService.getFamilyMembers();
      familyMembers.value = membersData;
    } catch (e) {
      errorMessage.value = 'Гэр бүлийн гишүүд татахад алдаа гарлаа: $e';
    } finally {
      isLoadingMembers.value = false;
    }
  }
}
