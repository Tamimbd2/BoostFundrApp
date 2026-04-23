import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../../../data/providers/deals_provider.dart';

class CreateCampaignController extends GetxController {
  final DealsProvider _dealsProvider = Get.find<DealsProvider>();

  final startupNameController = TextEditingController();
  final shortPitchController = TextEditingController();
  final founderContactController = TextEditingController();
  final pitchDeckController = TextEditingController();
  final financialDetailsController = TextEditingController();
  final detailedTractionDataController = TextEditingController();
  final privateDocumentsController = TextEditingController();
  final goalAmountController = TextEditingController();
  final currencyController = TextEditingController();
  final deadlineController = TextEditingController();
  final raisedAmountController = TextEditingController();
  
  // Missing schema fields
  final locationController = TextEditingController();
  final taglineController = TextEditingController();
  final problemController = TextEditingController();
  final solutionController = TextEditingController();
  final businessModelController = TextEditingController();
  final marketController = TextEditingController();
  final tractionController = TextEditingController();
  final founderDetailsController = TextEditingController();
  final teamController = TextEditingController();
  final geographyController = TextEditingController();
  final useOfFundsController = TextEditingController();
  final faqController = TextEditingController();

  final category = 'AI'.obs;
  final stage = 'MVP'.obs;
  
  final tractionHighlights = <String>[].obs;
  final selectedImages = <XFile>[].obs;
  final _picker = ImagePicker();

  final isLoading = false.obs;

  final categories = ['AI', 'HealthTech', 'FinTech', 'E-commerce', 'SaaS', 'Other'];
  final stages = ['idea', 'MVP', 'growth', 'scale'];

  Future<void> chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF22C55E),
              onPrimary: Colors.white,
              surface: Color(0xFF111111),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      deadlineController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.addAll(images);
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> submit() async {
    if (selectedImages.isEmpty) {
      Get.snackbar(
        'Error',
        'Please upload at least one image',
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      List<MultipartFile> imageFiles = [];
      for (var file in selectedImages) {
        final mimeType = lookupMimeType(file.path);
        imageFiles.add(MultipartFile(
          file.path, 
          filename: file.name,
          contentType: mimeType != null ? mimeType : 'image/jpeg',
        ));
      }
      
      final formData = FormData({
        'startupName': startupNameController.text,
        'shortPitch': shortPitchController.text,
        'category': category.value,
        'stage': stage.value,
        'goalAmount': int.tryParse(goalAmountController.text) ?? 0,
        'raisedAmount': int.tryParse(raisedAmountController.text) ?? 0,
        'currency': currencyController.text,
        'deadline': deadlineController.text,
        'location': locationController.text,
        'tagline': taglineController.text,
        'problem': problemController.text,
        'solution': solutionController.text,
        'businessModel': businessModelController.text,
        'market': marketController.text,
        'traction': tractionController.text,
        'founderDetails': founderDetailsController.text,
        'team': teamController.text,
        'geography': geographyController.text,
        'useOfFunds': useOfFundsController.text,
        'founderContact': founderContactController.text,
        'pitchDeck': pitchDeckController.text,
        'financialDetails': financialDetailsController.text,
        'detailedTractionData': detailedTractionDataController.text,
        'privateDocuments': privateDocumentsController.text,
        'faq': faqController.text.isNotEmpty ? [faqController.text] : [],
        'media': imageFiles,
      });

      final response = await _dealsProvider.createDeal(formData);

      if (response.status.isOk) {
        _showSuccessDialog();
      } else {
        Get.snackbar(
          'Error',
          response.body?['message'] ?? 'Failed to create campaign',
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.white,
      );
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
                'Success!',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Your deal has been created successfully.',
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
      Get.back(); // Go back to Home
    });
  }

  @override
  void onClose() {
    startupNameController.dispose();
    shortPitchController.dispose();
    founderContactController.dispose();
    pitchDeckController.dispose();
    financialDetailsController.dispose();
    detailedTractionDataController.dispose();
    privateDocumentsController.dispose();
    goalAmountController.dispose();
    currencyController.dispose();
    deadlineController.dispose();
    super.onClose();
  }
}
