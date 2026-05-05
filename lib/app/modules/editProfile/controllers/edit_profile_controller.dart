import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../data/api_constants.dart';

class EditProfileController extends GetxController {
  final storage = GetStorage();
  
  // Basic Info Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();
  final websiteController = TextEditingController();
  
  // Founder Info Controllers
  final companyNameController = TextEditingController();
  final companyWebsiteController = TextEditingController();
  final startupDescriptionController = TextEditingController();
  final fundingGoalController = TextEditingController();
  final teamSizeController = TextEditingController();
  
  // Investor Info Controllers
  final minInvestmentController = TextEditingController();
  final maxInvestmentController = TextEditingController();
  final interestsController = TextEditingController(); // Comma separated
  final sectorsController = TextEditingController(); // Comma separated
  
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
  final userRole = 'founder'.obs;
  
  final _picker = ImagePicker();
  bool _isPickerActive = false;

  @override
  void onInit() {
    super.onInit();
    final user = storage.read('user');
    userRole.value = user?['role'] ?? 'founder';
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      isInitialLoading.value = true;
      final token = storage.read('token');
      if (token == null) return;

      final endpoint = userRole.value == 'investor' 
          ? ApiConstants.investorProfile 
          : ApiConstants.founderProfile;

      final response = await GetConnect().get(
        '${ApiConstants.baseUrl}$endpoint',
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
            profileImage.value = profile['profileImage'] ?? '';
            
            // Founder specific
            companyNameController.text = profile['companyName'] ?? '';
            companyWebsiteController.text = profile['companyWebsite'] ?? '';
            startupDescriptionController.text = profile['startupDescription'] ?? '';
            fundingGoalController.text = (profile['fundingGoal'] ?? '').toString();
            teamSizeController.text = (profile['teamSize'] ?? '').toString();
            selectedStage.value = profile['startupStage'] ?? 'MVP';

            // Investor specific
            if (userRole.value == 'investor') {
              if (profile['interests'] != null && profile['interests'] is List) {
                interestsController.text = (profile['interests'] as List).join(', ');
              }
              if (profile['investmentPreferences'] != null) {
                final prefs = profile['investmentPreferences'];
                minInvestmentController.text = (prefs['minInvestment'] ?? '').toString();
                maxInvestmentController.text = (prefs['maxInvestment'] ?? '').toString();
                if (prefs['sectors'] != null && prefs['sectors'] is List) {
                  sectorsController.text = (prefs['sectors'] as List).join(', ');
                }
              }
            }
            
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
    if (_isPickerActive) return;
    
    try {
      _isPickerActive = true;
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    } finally {
      _isPickerActive = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final token = storage.read('token');
      
      final Map<String, String> fields = {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'location': locationController.text.trim(),
        'bio': bioController.text.trim(),
        'phone': phoneController.text.trim(),
        'website': websiteController.text.trim(),
        'socialLinks[linkedin]': linkedinController.text.trim(),
        'socialLinks[twitter]': twitterController.text.trim(),
        'socialLinks[facebook]': facebookController.text.trim(),
        'socialLinks[github]': githubController.text.trim(),
      };

      if (userRole.value == 'investor') {
        // Investor specific fields
        fields['investmentPreferences[minInvestment]'] = minInvestmentController.text.trim();
        fields['investmentPreferences[maxInvestment]'] = maxInvestmentController.text.trim();
        
        // Handle interests array
        final interests = interestsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        for (int i = 0; i < interests.length; i++) {
          fields['interests[$i]'] = interests[i];
        }

        // Handle sectors array
        final sectors = sectorsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        for (int i = 0; i < sectors.length; i++) {
          fields['investmentPreferences[sectors][$i]'] = sectors[i];
        }
      } else {
        // Founder specific fields
        fields['companyName'] = companyNameController.text.trim();
        fields['companyWebsite'] = companyWebsiteController.text.trim();
        fields['startupStage'] = selectedStage.value;
        fields['startupDescription'] = startupDescriptionController.text.trim();
        fields['fundingGoal'] = fundingGoalController.text.trim();
        fields['teamSize'] = teamSizeController.text.trim();
      }

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

      final endpoint = userRole.value == 'investor' 
          ? ApiConstants.investorProfile 
          : ApiConstants.founderProfile;

      final response = await GetConnect().put(
        '${ApiConstants.baseUrl}$endpoint',
        formData,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.status.isOk) {
        // Refresh other controllers
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchProfile();
        }
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().fetchProfile();
        }

        _showSuccessDialog();
      } else {
        final msg = response.body?['message'] ?? 'Failed to update profile';
        Get.snackbar('Error', msg,
            backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred',
          backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
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
                  color: const Color(0xFF22C55E).withValues(alpha: 0.1),
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
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
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
    minInvestmentController.dispose();
    maxInvestmentController.dispose();
    interestsController.dispose();
    sectorsController.dispose();
    linkedinController.dispose();
    twitterController.dispose();
    facebookController.dispose();
    githubController.dispose();
    super.onClose();
  }
}
