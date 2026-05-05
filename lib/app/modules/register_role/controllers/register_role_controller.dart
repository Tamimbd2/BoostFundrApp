import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class RegisterRoleController extends GetxController {
  final selectedRole = 'Investor'.obs;

  void selectRole(String role) {
    selectedRole.value = role;
  }

  void onContinue() {
    // Navigate to Signup and pass the selected role
    Get.toNamed(Routes.SIGNUP, arguments: {'role': selectedRole.value});
  }
}
