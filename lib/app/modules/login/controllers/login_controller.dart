import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';

class LoginController extends GetxController {
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  final email = ''.obs;
  final password = ''.obs;
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool _validate() {
    if (email.value.isEmpty || !GetUtils.isEmail(email.value)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (password.value.isEmpty || password.value.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters long',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  Future<void> login() async {
    if (!_validate()) return;

    try {
      isLoading.value = true;
      final response = await _authProvider.login({
        'email': email.value,
        'password': password.value,
      });

      if (response.status.isOk) {
        Get.snackbar(
          'Success',
          'Logged in successfully!',
          backgroundColor: const Color(0xFF22C55E).withOpacity(0.1),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        // Navigate to home or store token
        Get.offAllNamed('/home');
      } else {
        String message = response.body?['message'] ?? 'Login failed';
        Get.snackbar(
          'Login Failed',
          message,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
