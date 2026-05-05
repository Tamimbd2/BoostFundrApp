import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:boost_fundr/app/data/providers/auth_provider.dart';
import 'package:boost_fundr/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final AuthProvider _authProvider = Get.put(AuthProvider());

  final email = ''.obs;
  final isLoading = false.obs;

  void sendOtp() async {
    if (email.value.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authProvider.forgotPassword({'email': email.value});
      debugPrint('Forgot Password Status: ${response.statusCode}');
      debugPrint('Forgot Password Body: ${response.body}');
      
      if (response.status.isOk) {
        Get.snackbar('Success', 'Reset link sent to your email');
        Get.toNamed(Routes.CHANGE_PASSWORD, arguments: email.value);
      } else {
        String message = 'Something went wrong';
        if (response.body != null && response.body is Map) {
          message = response.body['message'] ?? message;
        }
        Get.snackbar('Error', message);
      }
    } catch (e) {
      debugPrint('Forgot Password Error: $e');
      Get.snackbar('Error', 'Failed to send reset link');
    } finally {
      isLoading.value = false;
    }
  }
}
