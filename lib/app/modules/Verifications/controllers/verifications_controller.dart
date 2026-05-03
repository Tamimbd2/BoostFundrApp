import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../../../data/providers/verifications_provider.dart';

class VerificationsController extends GetxController {
  final VerificationsProvider _provider = Get.put(VerificationsProvider());
  final ImagePicker _picker = ImagePicker();
  
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  
  final identityStatus = 'Not Started'.obs;
  final businessStatus = 'Not Started'.obs;
  final addressStatus = 'Not Started'.obs;
  final overallStatus = 'Not Started'.obs;
  final isVerified = false.obs;

  // Selected files
  final nidFront = Rxn<XFile>();
  final nidBack = Rxn<XFile>();
  final businessCertificate = Rxn<XFile>();

  @override
  void onInit() {
    super.onInit();
    fetchStatus();
  }

  Future<void> fetchStatus() async {
    try {
      isLoading.value = true;
      final response = await _provider.getVerificationStatus();
      
      if (response.status.isOk) {
        final data = response.body['data'];
        if (data != null && data['verification'] != null) {
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
    } catch (e) {
      print('Error fetching verification status: $e');
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
          case 'nidFront':
            nidFront.value = image;
            break;
          case 'nidBack':
            nidBack.value = image;
            break;
          case 'business':
            businessCertificate.value = image;
            break;
        }
      }
    } finally {
      _isPickerActive = false;
    }
  }

  Future<void> submit() async {
    if (nidFront.value == null || nidBack.value == null || businessCertificate.value == null) {
      Get.snackbar('Error', 'Please upload all required documents', 
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isSubmitting.value = true;
      
      final nidFrontFile = File(nidFront.value!.path);
      final nidBackFile = File(nidBack.value!.path);
      final businessFile = File(businessCertificate.value!.path);

      final nidFrontMime = lookupMimeType(nidFront.value!.path) ?? 'image/jpeg';
      final nidBackMime = lookupMimeType(nidBack.value!.path) ?? 'image/jpeg';
      final businessMime = lookupMimeType(businessCertificate.value!.path) ?? 'image/jpeg';

      final formData = FormData({
        'nidFront': MultipartFile(
          nidFrontFile.readAsBytesSync(),
          filename: nidFront.value!.name,
          contentType: nidFrontMime,
        ),
        'nidBack': MultipartFile(
          nidBackFile.readAsBytesSync(),
          filename: nidBack.value!.name,
          contentType: nidBackMime,
        ),
        'businessCertificate': MultipartFile(
          businessFile.readAsBytesSync(),
          filename: businessCertificate.value!.name,
          contentType: businessMime,
        ),
      });

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
      print('Error submitting verification: $e');
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
                  color: const Color(0xFF22C55E).withOpacity(0.1),
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
                  color: Colors.white.withOpacity(0.6),
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
