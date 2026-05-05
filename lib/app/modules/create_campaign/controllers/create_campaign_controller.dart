import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/deal_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart' as fp;
import '../../../data/providers/deals_provider.dart';

class CreateCampaignController extends GetxController {
  final DealsProvider _dealsProvider = Get.find<DealsProvider>();
  final profileCompletionScore = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      if (args is String) {
        dealId = args;
        _fetchDealData(dealId!);
      } else if (args is DealModel) {
        dealId = args.id;
        _populateFieldsFromModel(args);
      }
    }
  }

  void _populateFieldsFromModel(DealModel deal) {
    startupNameController.text = deal.startupName ?? '';
    taglineController.text = deal.tagline ?? '';
    startupWebsiteController.text = deal.startupWebsite ?? '';
    locationController.text = deal.location ?? '';
    category.value = deal.category ?? 'AI';
    stage.value = deal.stage ?? 'idea';
    
    shortPitchController.text = deal.shortPitch ?? '';
    problemController.text = deal.problem ?? '';
    solutionController.text = deal.solution ?? '';
    businessModelController.text = deal.businessModel ?? '';
    targetMarketController.text = deal.targetMarket ?? '';
    whyNowController.text = deal.whyNow ?? '';
    
    goalAmountController.text = (deal.raisedGoal ?? '').toString();
    currencyController.text = deal.raisedCurrency ?? 'AED';
    deadlineController.text = deal.deadline ?? '';
    revenueController.text = (deal.revenue ?? '').toString();
    
    tractionController.text = deal.traction ?? '';
    goToMarketController.text = deal.goToMarket ?? '';
    topCompetitorController.text = deal.topCompetitor ?? '';
    advantageController.text = deal.advantage ?? '';
    
    whatsappNumberController.text = deal.whatsappNumber ?? '';
    if (deal.qa != null && deal.qa is List && (deal.qa as List).isNotEmpty) {
      final firstQa = (deal.qa as List)[0];
      if (firstQa is Map) {
        faqController.text = firstQa['question'] ?? '';
      } else {
        faqController.text = firstQa.toString();
      }
    }

    profileCompletionScore.value = deal.profileCompletionScore ?? 0;
    currentStep.value = deal.currentStep ?? 1;
  }

  Future<void> _fetchDealData(String id) async {
    try {
      isLoading.value = true;
      final response = await _dealsProvider.getDealById(id);
      if (response.status.isOk) {
        final data = response.body?['data'];
        if (data != null) {
          startupNameController.text = data['startupName'] ?? '';
          taglineController.text = data['tagline'] ?? '';
          startupWebsiteController.text = data['startupWebsite'] ?? '';
          locationController.text = data['location'] ?? '';
          category.value = data['category'] ?? 'AI';
          stage.value = data['stage'] ?? 'idea';
          
          shortPitchController.text = data['shortPitch'] ?? '';
          problemController.text = data['problem'] ?? '';
          solutionController.text = data['solution'] ?? '';
          businessModelController.text = data['businessModel'] ?? '';
          targetMarketController.text = data['targetMarket'] ?? '';
          whyNowController.text = data['whyNow'] ?? '';
          
          goalAmountController.text = (data['goalAmount'] ?? '').toString();
          currencyController.text = data['currency'] ?? 'AED';
          deadlineController.text = data['deadline'] ?? '';
          revenueController.text = (data['revenue'] ?? '').toString();
          
          tractionController.text = data['traction'] ?? '';
          goToMarketController.text = data['goToMarket'] ?? '';
          topCompetitorController.text = data['topCompetitor'] ?? '';
          advantageController.text = data['advantage'] ?? '';
          
          founderContactController.text = data['founderContact'] ?? '';
          whatsappNumberController.text = data['whatsappNumber'] ?? '';
          faqController.text = (data['faq'] is List && (data['faq'] as List).isNotEmpty) 
              ? data['faq'][0] 
              : '';

          profileCompletionScore.value = (data['profileCompletionScore'] ?? 0).toInt();
        }
      }
    } catch (e) {
      debugPrint('Error fetching deal data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  final startupNameController = TextEditingController();
  final shortPitchController = TextEditingController();
  final founderContactController = TextEditingController();
  final whatsappNumberController = TextEditingController();
  final pitchDeckController = TextEditingController();
  final financialDetailsController = TextEditingController();
  final detailedTractionDataController = TextEditingController();
  final privateDocumentsController = TextEditingController();
  final goalAmountController = TextEditingController();
  final currencyController = TextEditingController();
  final deadlineController = TextEditingController();
  final raisedAmountController = TextEditingController();
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
  final startupWebsiteController = TextEditingController();
  final targetMarketController = TextEditingController();
  final whyNowController = TextEditingController();
  final revenueController = TextEditingController();
  final goToMarketController = TextEditingController();
  final topCompetitorController = TextEditingController();
  final advantageController = TextEditingController();
  
  // Document Files
  final pitchDeckFile = Rxn<XFile>();
  final safeAgreementFile = Rxn<XFile>();
  final termSheetFile = Rxn<XFile>();
  final registrationCertificateFile = Rxn<XFile>();
  final tradeLicenseFile = Rxn<XFile>();
  final balanceSheetFile = Rxn<XFile>();
  final revenueProofFile = Rxn<XFile>();
  final capTableFile = Rxn<XFile>();
  final shareholderAgreementFile = Rxn<XFile>();

  String? dealId;

  bool _isPicking = false;

  Future<void> pickDocument(Rxn<XFile> target) async {
    if (_isPicking) return;
    try {
      _isPicking = true;
      fp.FilePickerResult? result = await fp.FilePicker.pickFiles(
        type: fp.FileType.custom,
        allowedExtensions: ['pdf'],
      );
      
      if (result != null && result.files.single.path != null) {
        target.value = XFile(result.files.single.path!);
      }
    } catch (e) {
      debugPrint('Error picking PDF: $e');
      Get.snackbar('Error', 'Could not open file manager: $e', 
          backgroundColor: Colors.redAccent.withOpacity(0.1), colorText: Colors.white);
    } finally {
      _isPicking = false;
    }
  }

  final category = 'AI'.obs;
  final stage = 'idea'.obs;
  
  final tractionHighlights = <String>[].obs;
  final selectedImages = <XFile>[].obs;
  final _picker = ImagePicker();

  final currentStep = 1.obs;
  final isLoading = false.obs;

  final categories = [
    'AI',
    'HealthTech',
    'FinTech',
    'E-commerce',
    'SaaS',
    'Enterprise AI & Data Analytics',
    'Web3',
    'CleanTech',
    'EdTech',
    'Other'
  ];
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
    if (_isPicking) return;
    try {
      _isPicking = true;
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImages.addAll(images);
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    } finally {
      _isPicking = false;
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> submit({bool navigateBack = false}) async {
    try {
      isLoading.value = true;

      if (currentStep.value == 1 && dealId == null) {
        // Step 1: Create the deal (POST)
        final formData = FormData({
          'startupName': startupNameController.text,
          'startupWebsite': startupWebsiteController.text,
          'tagline': taglineController.text,
          'category': category.value,
          'stage': stage.value,
          'location': locationController.text,
          'whatsappNumber': whatsappNumberController.text,
        });

        if (selectedImages.isNotEmpty) {
          final file = selectedImages[0];
          final mimeType = lookupMimeType(file.path);
          formData.files.add(MapEntry(
            'startupLogo',
            MultipartFile(
              file.path,
              filename: file.name,
              contentType: mimeType ?? 'image/jpeg',
            ),
          ));
        }

        final response = await _dealsProvider.createDeal(formData);
        if (response.status.isOk) {
          dealId = response.body?['data']?['_id'] ?? response.body?['data']?['id'];
          _handleSuccess(response, navigateBack);
        } else {
          _handleError(response);
        }
      } else if (dealId != null) {
        // Step 2-5: Update the deal (PATCH)
        dynamic updateData;
        
        if (currentStep.value == 1) {
          updateData = {
            'startupName': startupNameController.text,
            'startupWebsite': startupWebsiteController.text,
            'tagline': taglineController.text,
            'category': category.value,
            'stage': stage.value,
            'location': locationController.text,
            'whatsappNumber': whatsappNumberController.text,
          };
        } else if (currentStep.value == 2) {
          updateData = {
            'shortPitch': shortPitchController.text,
            'problem': problemController.text,
            'solution': solutionController.text,
            'businessModel': businessModelController.text,
            'targetMarket': targetMarketController.text,
            'whyNow': whyNowController.text,
          };
        } else if (currentStep.value == 3) {
          updateData = {
            'goalAmount': int.tryParse(goalAmountController.text) ?? 0,
            'currency': currencyController.text,
            'deadline': deadlineController.text,
            'revenue': int.tryParse(revenueController.text) ?? 0,
            'useOfFunds': [
              {'category': 'General', 'percentage': 100} // Simplified for now
            ],
          };
        } else if (currentStep.value == 4) {
          updateData = {
            'traction': tractionController.text,
            'goToMarket': goToMarketController.text,
            'topCompetitor': topCompetitorController.text,
            'advantage': advantageController.text,
            'team': [
              {'name': teamController.text, 'role': 'Founder'} // Simplified
            ],
          };
        } else if (currentStep.value == 5) {
          // Use FormData for files in PATCH
          final fd = FormData({
            'faq': faqController.text.isNotEmpty ? [faqController.text] : [],
            'founderContact': founderContactController.text,
          });

          void addFile(String key, XFile? file) {
            if (file != null) {
              final mimeType = lookupMimeType(file.path);
              fd.files.add(MapEntry(
                key,
                MultipartFile(
                  file.path,
                  filename: file.name,
                  contentType: mimeType ?? 'application/pdf',
                ),
              ));
            }
          }

          addFile('pitchDeck', pitchDeckFile.value);
          addFile('safeAgreement', safeAgreementFile.value);
          addFile('termSheet', termSheetFile.value);
          addFile('registrationCertificate', registrationCertificateFile.value);
          addFile('tradeLicense', tradeLicenseFile.value);
          addFile('balanceSheet', balanceSheetFile.value);
          addFile('revenueProof', revenueProofFile.value);
          addFile('capTable', capTableFile.value);
          addFile('shareholderAgreement', shareholderAgreementFile.value);

          updateData = fd;
        }

        final response = await _dealsProvider.updateDeal(dealId!, updateData);
        if (response.status.isOk) {
          _handleSuccess(response, navigateBack);
        } else {
          _handleError(response);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred',
          backgroundColor: Colors.redAccent.withOpacity(0.1), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleSuccess(Response response, bool navigateBack) {
    // Extract profile completion score if available
    final score = response.body?['data']?['profileCompletionScore'];
    if (score != null) {
      profileCompletionScore.value = (score as num).toInt();
    }

    if (navigateBack) {
      _showSuccessDialog();
    } else {
      Get.snackbar(
        'Success',
        'Progress saved',
        backgroundColor: const Color(0xFF22C55E).withOpacity(0.1),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _handleError(Response response) {
    Get.snackbar(
      'Error',
      response.body?['message'] ?? 'Action failed',
      backgroundColor: Colors.redAccent.withOpacity(0.1),
      colorText: Colors.white,
    );
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
    startupWebsiteController.dispose();
    targetMarketController.dispose();
    whyNowController.dispose();
    revenueController.dispose();
    goToMarketController.dispose();
    topCompetitorController.dispose();
    advantageController.dispose();
    whatsappNumberController.dispose();
    super.onClose();
  }
}
