import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final storage = GetStorage();
  
  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();
  final websiteController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyWebsiteController = TextEditingController();
  final startupDescriptionController = TextEditingController();
  final fundingGoalController = TextEditingController();
  final teamSizeController = TextEditingController();
  
  // Social Links Controllers
  final linkedinController = TextEditingController();
  final twitterController = TextEditingController();
  final facebookController = TextEditingController();
  final githubController = TextEditingController();

  final selectedStage = 'MVP'.obs;
  final stages = ['idea', 'MVP', 'growth', 'scale'];
  
  final profileImage = ''.obs;
  final selectedImagePath = ''.obs;
  final isLoading = false.obs;
  final isInitialLoading = true.obs;
  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      isInitialLoading.value = true;
      final token = storage.read('token');
      if (token == null) return;

      final response = await GetConnect().get(
        'https://boost-funder.onrender.com/api/v1/users/me/founder-profile',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.status.isOk && response.body != null) {
        final data = response.body['data'];
        if (data != null && data['user'] != null) {
          final user = data['user'];
          firstNameController.text = user['firstName'] ?? '';
          lastNameController.text = user['lastName'] ?? '';
          emailController.text = user['email'] ?? '';
          
          if (user['profile'] != null) {
            final profile = user['profile'];
            phoneController.text = profile['phone'] ?? '';
            locationController.text = profile['location'] ?? '';
            bioController.text = profile['bio'] ?? '';
            websiteController.text = profile['website'] ?? '';
            companyNameController.text = profile['companyName'] ?? '';
            companyWebsiteController.text = profile['companyWebsite'] ?? '';
            startupDescriptionController.text = profile['startupDescription'] ?? '';
            fundingGoalController.text = (profile['fundingGoal'] ?? '').toString();
            teamSizeController.text = (profile['teamSize'] ?? '').toString();
            selectedStage.value = profile['startupStage'] ?? 'MVP';
            profileImage.value = profile['profileImage'] ?? '';
            
            if (profile['socialLinks'] != null) {
              final social = profile['socialLinks'];
              linkedinController.text = social['linkedin'] ?? '';
              twitterController.text = social['twitter'] ?? '';
              facebookController.text = social['facebook'] ?? '';
              githubController.text = social['github'] ?? '';
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    } finally {
      isInitialLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final token = storage.read('token');
      
      final Map<String, String> fields = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'location': locationController.text,
        'bio': bioController.text,
        'phone': phoneController.text,
        'website': websiteController.text,
        'companyName': companyNameController.text,
        'companyWebsite': companyWebsiteController.text,
        'startupStage': selectedStage.value,
        'startupDescription': startupDescriptionController.text,
        'fundingGoal': fundingGoalController.text,
        'teamSize': teamSizeController.text,
        'socialLinks[linkedin]': linkedinController.text,
        'socialLinks[twitter]': twitterController.text,
        'socialLinks[facebook]': facebookController.text,
        'socialLinks[github]': githubController.text,
      };

      final formData = FormData(fields);

      if (selectedImagePath.value.isNotEmpty) {
        final file = File(selectedImagePath.value);
        final mimeType = lookupMimeType(file.path);
        formData.files.add(MapEntry(
          'profileImage',
          MultipartFile(
            file.path,
            filename: file.path.split('/').last,
            contentType: mimeType ?? 'image/jpeg',
          ),
        ));
      }

      final response = await GetConnect().put(
        'https://boost-funder.onrender.com/api/v1/users/me/founder-profile',
        formData,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.status.isOk) {
        // Refresh other controllers in real-time
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchProfile();
        }
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().fetchFounderProfile();
        }

        _showSuccessDialog();
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Failed to update profile',
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred',
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 60),
              ),
              const SizedBox(height: 24),
              const Text(
                'Profile Updated!',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Your profile information has been saved successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.back(); // Close dialog
      Get.back(result: true); // Go back to Profile screen
    });
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    bioController.dispose();
    websiteController.dispose();
    companyNameController.dispose();
    companyWebsiteController.dispose();
    startupDescriptionController.dispose();
    fundingGoalController.dispose();
    teamSizeController.dispose();
    linkedinController.dispose();
    twitterController.dispose();
    facebookController.dispose();
    githubController.dispose();
    super.onClose();
  }
}
