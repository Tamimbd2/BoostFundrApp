import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';

class SignupController extends GetxController {
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  final firstName = ''.obs;
  final lastName = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  
  final roles = ['Guest', 'Founder', 'Investor'];
  final selectedRole = 'Guest'.obs;
  
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['role'] != null) {
      selectedRole.value = Get.arguments['role'];
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  bool _validate() {
    if (firstName.value.isEmpty || lastName.value.isEmpty) {
      Get.snackbar('Error', 'Please enter your first and last name', 
        backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.white);
      return false;
    }
    if (!GetUtils.isEmail(email.value)) {
      Get.snackbar('Error', 'Please enter a valid email', 
        backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.white);
      return false;
    }
    if (password.value.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters', 
        backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.white);
      return false;
    }
    if (password.value != confirmPassword.value) {
      Get.snackbar('Error', 'Passwords do not match', 
        backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.white);
      return false;
    }
    return true;
  }

  Future<void> signup() async {
    if (!_validate()) return;

    try {
      isLoading.value = true;
      final response = await _authProvider.register({
        'firstName': firstName.value,
        'lastName': lastName.value,
        'email': email.value,
        'password': password.value,
        'role': selectedRole.value.toLowerCase(), // API expects lowercase
      });

      if (response.status.isOk) {
        Get.snackbar(
          'Success',
          'Account created successfully!',
          backgroundColor: const Color(0xFF22C55E).withOpacity(0.1),
          colorText: Colors.white,
        );
        Get.offAllNamed('/login');
      } else {
        String message = response.body?['message'] ?? 'Registration failed';
        Get.snackbar('Error', message, 
          backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred', 
        backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
