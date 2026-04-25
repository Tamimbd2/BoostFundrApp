import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/providers/auth_provider.dart';

class LoginController extends GetxController {
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  final storage = GetStorage();

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
        
        // Save token and navigate
        final data = response.body['data'];
        final token = response.body['token'] ?? 
                      response.body['access_token'] ?? 
                      (data is Map ? data['token'] : null);
        
        if (token != null) {
          storage.write('token', token);
          if (data is Map && data['user'] != null) {
            storage.write('user', data['user']);
            final role = data['user']['role'];
            print('User logged in with role: $role');
          }
          Get.offAllNamed('/home');
        } else {
          // If no token is found, still navigate to home if the response was OK, 
          // or handle as error if token is mandatory
          Get.offAllNamed('/home');
        }
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
