import 'package:get/get.dart';
import 'package:boost_fundr/app/data/providers/auth_provider.dart';
import 'package:boost_fundr/app/routes/app_pages.dart';

class ChangePasswordController extends GetxController {
  final AuthProvider _authProvider = Get.put(AuthProvider());

  final email = ''.obs;
  final otp = ''.obs;
  final newPassword = ''.obs;
  final confirmPassword = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get email from arguments
    if (Get.arguments != null) {
      email.value = Get.arguments;
    }
  }

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  void changePassword() async {
    if (otp.value.isEmpty || newPassword.value.isEmpty || confirmPassword.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    if (newPassword.value != confirmPassword.value) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authProvider.resetPassword({
        'email': email.value,
        'otp': otp.value,
        'newPassword': newPassword.value,
      });

      if (response.status.isOk) {
        Get.snackbar('Success', 'Password updated successfully');
        Get.offAllNamed(Routes.LOGIN);
      } else {
        String message = 'Something went wrong';
        if (response.body != null && response.body is Map) {
          message = response.body['message'] ?? message;
        }
        Get.snackbar('Error', message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update password');
    } finally {
      isLoading.value = false;
    }
  }
}
