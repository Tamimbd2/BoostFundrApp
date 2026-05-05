import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final storage = GetStorage();

  final userName = 'Mohammed'.obs;
  final userEmail = 'm@gmail.com'.obs;
  final profileImage = ''.obs;
  final isVerified = false.obs;
  final isLoading = false.obs;
  final userRole = 'founder'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final token = storage.read('token');
      if (token == null) return;

      final endpoint = userRole.value == 'investor' 
          ? 'https://boost-funder.onrender.com/api/v1/users/me/investor-profile'
          : 'https://boost-funder.onrender.com/api/v1/users/me/founder-profile';

      final response = await GetConnect().get(
        endpoint,
        headers: {
          'Authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
      );

      if (response.status.isOk && response.body != null) {
        final data = response.body['data'];
        if (data != null && data['user'] != null) {
          final user = data['user'];

          if (user['firstName'] != null) {
            final first = user['firstName'] ?? '';
            final last = user['lastName'] ?? '';
            userName.value = "$first $last".trim();
          }
          if (user['email'] != null) {
            userEmail.value = user['email'];
          }

          // Strictly update isVerified from API response
          isVerified.value = user['isVerified'] == true;

          if (user['profile'] != null) {
            if (user['profile']['profileImage'] != null) {
              profileImage.value = user['profile']['profileImage'];
            }
          }

          // Persist updated user info to storage
          final storedUser = storage.read('user') ?? {};
          storedUser['isVerified'] = isVerified.value;
          if (user['firstName'] != null) storedUser['firstName'] = user['firstName'];
          if (user['lastName'] != null) storedUser['lastName'] = user['lastName'];
          if (user['email'] != null) storedUser['email'] = user['email'];
          storage.write('user', storedUser);
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _loadUser() {
    final user = storage.read('user');
    if (user != null) {
      final firstName = user['firstName'] ?? '';
      final lastName = user['lastName'] ?? '';
      if (firstName.isNotEmpty || lastName.isNotEmpty) {
        userName.value = '$firstName $lastName'.trim();
      }
      if (user['email'] != null) {
        userEmail.value = user['email'];
      }
      if (user['role'] != null) {
        userRole.value = user['role'];
      }
      
      // We no longer load isVerified from storage here to ensure 
      // it is strictly updated only from the API response.
    }
  }

  void logout() {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        storage.remove('token');
                        Get.offAllNamed('/select-language');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
