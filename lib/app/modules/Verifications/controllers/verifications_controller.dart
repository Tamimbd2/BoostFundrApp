import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../../../data/providers/verifications_provider.dart';
import '../../../data/api_constants.dart';

class VerificationsController extends GetxController {
  final VerificationsProvider _provider = Get.put(VerificationsProvider());
  final ImagePicker _picker = ImagePicker();
  final storage = GetStorage();
  
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  
  final identityStatus = 'Not Started'.obs;
  final businessStatus = 'Not Started'.obs;
  final addressStatus = 'Not Started'.obs;
  final overallStatus = 'Not Started'.obs;
  final isVerified = false.obs;
  final userRole = 'founder'.obs;

  // Selected files
  final nicFront = Rxn<XFile>();
  final nicBack = Rxn<XFile>();
  final passport = Rxn<XFile>();
  final drivingLicence = Rxn<XFile>();
  final selfie = Rxn<XFile>();

  @override
  void onInit() {
    super.onInit();
    final user = storage.read('user');
    userRole.value = user?['role'] ?? 'founder';
    fetchStatus();
  }

  Future<void> fetchStatus() async {
    try {
      isLoading.value = true;
      
      // 1. Check existing verification status provider
      final response = await _provider.getVerificationStatus();
      
      if (response.status.isOk) {
        final data = response.body['data'];
        // The API for investor might return status differently
        if (data != null && data['status'] != null) {
          final status = _mapStatus(data['status']);
          overallStatus.value = status;
          identityStatus.value = status;
          businessStatus.value = status;
          isVerified.value = status == 'Verified';
        } else if (data != null && data['verification'] != null) {
          final verification = data['verification'];
          final status = _mapStatus(verification['status']);
          overallStatus.value = status;
          identityStatus.value = status;
          businessStatus.value = status;
          isVerified.value = status == 'Verified';
        } else if (data != null) {
          identityStatus.value = _mapStatus(data['identityStatus']);
          businessStatus.value = _mapStatus(data['businessStatus']);
          final status = _mapStatus(data['overallStatus'] ?? data['status']);
          overallStatus.value = status;
          isVerified.value = status == 'Verified' || data['isVerified'] == true;
        }
      }

      // 2. STRICTOR CHECK: Call profile API
      final token = storage.read('token');
      if (token != null) {
        final endpoint = userRole.value == 'investor' 
            ? ApiConstants.investorProfile 
            : ApiConstants.founderProfile;
            
        final profileResponse = await GetConnect().get(
          '${ApiConstants.baseUrl}$endpoint',
          headers: {
            'Authorization': 'Bearer $token',
            'content-type': 'application/json',
          },
        );

        if (profileResponse.status.isOk && profileResponse.body != null) {
          final profileData = profileResponse.body['data'];
          if (profileData != null && profileData['user'] != null) {
            final user = profileData['user'];
            if (user['isVerified'] == true) {
              isVerified.value = true;
              overallStatus.value = 'Verified';
              identityStatus.value = 'Verified';
              businessStatus.value = 'Verified';
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching verification status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _isPickerActive = false;

  Future<void> pickImage(String type) async {
    if (_isPickerActive) return;
    
    try {
      _isPickerActive = true;
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        switch (type) {
          case 'nicFront':
            nicFront.value = image;
            break;
          case 'nicBack':
            nicBack.value = image;
            break;
          case 'passport':
            passport.value = image;
            break;
          case 'drivingLicence':
            drivingLicence.value = image;
            break;
          case 'selfie':
            selfie.value = image;
            break;
        }
      }
    } finally {
      _isPickerActive = false;
    }
  }

  Future<void> submit() async {
    bool hasNid = nicFront.value != null && nicBack.value != null;
    bool hasPassport = passport.value != null;
    bool hasDrivingLicence = drivingLicence.value != null;

    if (userRole.value == 'investor') {
      // Investor specific validation if any, but let's keep it flexible
      if (!hasNid && !hasPassport && !hasDrivingLicence) {
        Get.snackbar('Error', 'Please upload NID, Passport, or Driving Licence', 
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }
    } else {
      if (!hasNid && !hasPassport && !hasDrivingLicence) {
        Get.snackbar('Error', 'Please upload NID, Passport, or Driving Licence', 
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }
    }

    try {
      isSubmitting.value = true;
      
      final Map<String, dynamic> formDataMap = {};

      if (nicFront.value != null) {
        formDataMap['nidFront'] = MultipartFile(
          File(nicFront.value!.path).readAsBytesSync(),
          filename: nicFront.value!.name,
          contentType: lookupMimeType(nicFront.value!.path) ?? 'image/jpeg',
        );
      }
      if (nicBack.value != null) {
        formDataMap['nidBack'] = MultipartFile(
          File(nicBack.value!.path).readAsBytesSync(),
          filename: nicBack.value!.name,
          contentType: lookupMimeType(nicBack.value!.path) ?? 'image/jpeg',
        );
      }
      if (passport.value != null) {
        formDataMap['passport'] = MultipartFile(
          File(passport.value!.path).readAsBytesSync(),
          filename: passport.value!.name,
          contentType: lookupMimeType(passport.value!.path) ?? 'image/jpeg',
        );
      }
      if (drivingLicence.value != null) {
        formDataMap['drivingLicence'] = MultipartFile(
          File(drivingLicence.value!.path).readAsBytesSync(),
          filename: drivingLicence.value!.name,
          contentType: lookupMimeType(drivingLicence.value!.path) ?? 'image/jpeg',
        );
      }
      if (selfie.value != null) {
        formDataMap['selfie'] = MultipartFile(
          File(selfie.value!.path).readAsBytesSync(),
          filename: selfie.value!.name,
          contentType: lookupMimeType(selfie.value!.path) ?? 'image/jpeg',
        );
      }

      final formData = FormData(formDataMap);

      final response = await _provider.submitVerification(formData);
      
      if (response.status.isOk) {
        _showSuccessDialog();
        fetchStatus();
      } else {
        final errorMessage = response.body?['message'] ?? 'Submission failed';
        Get.snackbar('Error', errorMessage, 
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Error submitting verification: $e');
      Get.snackbar('Error', 'An unexpected error occurred', 
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isSubmitting.value = false;
    }
  }

  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF22C55E),
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Success!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your verification documents have been submitted successfully. We will review them shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.back(); // Go back to Status screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  String _mapStatus(String? status) {
    if (status == null) return 'Not Started';
    switch (status.toLowerCase()) {
      case 'pending': return 'Pending';
      case 'verified':
      case 'approved': return 'Verified';
      case 'rejected':
      case 'failed': return 'Rejected';
      default: return 'Not Started';
    }
  }
}
