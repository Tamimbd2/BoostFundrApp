import 'package:boost_fundr/export.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../controllers/create_campaign_controller.dart';

class CreateCampaignView extends GetView<CreateCampaignController> {
  const CreateCampaignView({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Create Deal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileScoreBar(),
              const SizedBox(height: 32),
              _buildStepper(),
              const SizedBox(height: 32),
              Obx(() => _buildStepContent()),
              const SizedBox(height: 40),
              _buildBottomButtons(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileScoreBar() {
    return Obx(() {
      // Simple calculation: check how many controllers have text
      int totalFields = 15; // Approximate number of key fields
      int filledFields = 0;
      if (controller.startupNameController.text.isNotEmpty) filledFields++;
      if (controller.startupWebsiteController.text.isNotEmpty) filledFields++;
      if (controller.locationController.text.isNotEmpty) filledFields++;
      if (controller.shortPitchController.text.isNotEmpty) filledFields++;
      if (controller.goalAmountController.text.isNotEmpty) filledFields++;
      if (controller.currencyController.text.isNotEmpty) filledFields++;
      if (controller.deadlineController.text.isNotEmpty) filledFields++;
      if (controller.problemController.text.isNotEmpty) filledFields++;
      if (controller.solutionController.text.isNotEmpty) filledFields++;
      if (controller.tractionController.text.isNotEmpty) filledFields++;
      if (controller.teamController.text.isNotEmpty) filledFields++;
      if (controller.pitchDeckController.text.isNotEmpty) filledFields++;
      if (controller.founderContactController.text.isNotEmpty) filledFields++;
      if (controller.taglineController.text.isNotEmpty) filledFields++;
      if (controller.whatsappNumberController.text.isNotEmpty) filledFields++;
      if (controller.selectedImages.isNotEmpty) filledFields++;

      double progress = (filledFields / totalFields).clamp(0.0, 1.0);
      int percentage = (progress * 100).toInt();

      // Use API score if available (non-zero)
      int displayPercentage = controller.profileCompletionScore.value > 0 
          ? controller.profileCompletionScore.value 
          : percentage;
      double displayProgress = controller.profileCompletionScore.value > 0 
          ? controller.profileCompletionScore.value / 100.0 
          : progress;

      return GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "Let's get started on your deal!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorConst.kPrimaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ColorConst.kPrimaryColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    "$displayPercentage% Profile Score",
                    style: TextStyle(
                      color: ColorConst.kPrimaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: displayProgress,
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                valueColor: AlwaysStoppedAnimation<Color>(ColorConst.kPrimaryColor),
                minHeight: 6,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStepper() {
    final steps = [
      {'id': 1, 'title': 'Basics'},
      {'id': 2, 'title': 'Story'},
      {'id': 3, 'title': 'Funding'},
      {'id': 4, 'title': 'Execution'},
      {'id': 5, 'title': 'Documents'},
    ];

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: steps.map((step) {
          int id = step['id'] as int;
          String title = step['title'] as String;
          bool isActive = controller.currentStep.value == id;
          bool isCompleted = controller.currentStep.value > id;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (id < controller.currentStep.value) {
                  controller.currentStep.value = id;
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: id == 1
                            ? const SizedBox.shrink()
                            : Container(
                                height: 2,
                                color: isCompleted || isActive
                                    ? ColorConst.kPrimaryColor
                                    : Colors.white.withValues(alpha: 0.05),
                              ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? ColorConst.kPrimaryColor
                              : isActive
                                  ? Colors.transparent
                                  : Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCompleted || isActive
                                ? ColorConst.kPrimaryColor
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check, color: Colors.white, size: 16)
                              : Text(
                                  "$id",
                                  style: TextStyle(
                                    color: isActive ? ColorConst.kPrimaryColor : Colors.white38,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        child: id == 5
                            ? const SizedBox.shrink()
                            : Container(
                                height: 2,
                                color: isCompleted
                                    ? ColorConst.kPrimaryColor
                                    : Colors.white.withValues(alpha: 0.05),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isActive ? ColorConst.kPrimaryColor : Colors.white38,
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (controller.currentStep.value) {
      case 1:
        return _buildBasicsStep();
      case 2:
        return _buildStoryStep();
      case 3:
        return _buildFundingStep();
      case 4:
        return _buildExecutionStep();
      case 5:
        return _buildDocumentsStep();
      default:
        return Center(
          child: Text(
            "Step ${controller.currentStep.value} Content Coming Soon",
            style: const TextStyle(color: Colors.white),
          ),
        );
    }
  }

  Widget _buildFundingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Goal Amount',
          hint: 'e.g. 250000',
          controller: controller.goalAmountController,
          isRequired: true,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Currency',
          hint: 'e.g. AED',
          controller: controller.currencyController,
          isRequired: true,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Revenue',
          hint: 'e.g. 25000',
          controller: controller.revenueController,
          isRequired: true,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Deadline',
          hint: '2026-06-01',
          controller: controller.deadlineController,
          isRequired: true,
          readOnly: true,
          onTap: () => controller.chooseDate(),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Use of Funds',
          hint: 'How will the funds be used?',
          controller: controller.useOfFundsController,
          isRequired: true,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildExecutionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Traction',
          hint: 'Current traction details',
          controller: controller.tractionController,
          isRequired: true,
          maxLines: 4,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Go To Market',
          hint: 'e.g. Channel partners',
          controller: controller.goToMarketController,
          isRequired: true,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Top Competitor',
          hint: 'e.g. Competitor X',
          controller: controller.topCompetitorController,
          isRequired: true,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Competitive Advantage',
          hint: 'e.g. Lower cost',
          controller: controller.advantageController,
          isRequired: true,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Founder Name (Team)',
          hint: 'e.g. Ada',
          controller: controller.teamController,
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilePicker('Pitch Deck', controller.pitchDeckFile, isRequired: true),
        const SizedBox(height: 16),
        _buildFilePicker('SAFE Agreement', controller.safeAgreementFile, isRequired: false),
        const SizedBox(height: 16),
        _buildFilePicker('Term Sheet', controller.termSheetFile, isRequired: false),
        const SizedBox(height: 16),
        _buildFilePicker('Registration Certificate', controller.registrationCertificateFile, isRequired: false),
        const SizedBox(height: 16),
        _buildFilePicker('Trade License', controller.tradeLicenseFile, isRequired: false),
        const SizedBox(height: 16),
        _buildFilePicker('Balance Sheet', controller.balanceSheetFile, isRequired: false),
        const SizedBox(height: 16),
        _buildFilePicker('Revenue Proof', controller.revenueProofFile, isRequired: false),
        const SizedBox(height: 16),
        _buildFilePicker('Cap Table', controller.capTableFile, isRequired: false),
        const SizedBox(height: 16),
        _buildFilePicker('Shareholder Agreement', controller.shareholderAgreementFile, isRequired: false),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'FAQ',
          hint: 'Commonly asked questions',
          controller: controller.faqController,
          isRequired: false,
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Founder Contact',
          hint: 'Email or phone number',
          controller: controller.founderContactController,
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildFilePicker(String label, Rxn<XFile> fileRx, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
                    const TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent)),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => GestureDetector(
          onTap: () => controller.pickDocument(fileRx),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: fileRx.value != null ? const Color(0xFF22C55E) : const Color(0xFF1E1E1E),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  fileRx.value != null ? Icons.description : Icons.upload_file,
                  color: fileRx.value != null ? const Color(0xFF22C55E) : Colors.white38,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    fileRx.value != null ? fileRx.value!.name : 'Choose file...',
                    style: TextStyle(
                      color: fileRx.value != null ? Colors.white : Colors.white38,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (fileRx.value != null)
                  const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 20),
              ],
            ),
          ),
        )),
      ],
    );
  }

  bool _validateStep() {
    switch (controller.currentStep.value) {
      case 1:
        if (controller.startupNameController.text.isEmpty ||
            controller.selectedImages.isEmpty ||
            controller.startupWebsiteController.text.isEmpty ||
            controller.taglineController.text.isEmpty ||
            controller.whatsappNumberController.text.isEmpty ||
            controller.locationController.text.isEmpty) {
          Get.snackbar('Required', 'Please fill all fields in the Basics section',
              backgroundColor: Colors.redAccent.withValues(alpha: 0.1), colorText: Colors.white);
          return false;
        }
        return true;
      case 2:
        if (controller.shortPitchController.text.isEmpty ||
            controller.problemController.text.isEmpty ||
            controller.solutionController.text.isEmpty ||
            controller.targetMarketController.text.isEmpty ||
            controller.whyNowController.text.isEmpty ||
            controller.businessModelController.text.isEmpty) {
          Get.snackbar('Required', 'Please fill all fields in the Story section',
              backgroundColor: Colors.redAccent.withValues(alpha: 0.1), colorText: Colors.white);
          return false;
        }
        return true;
      case 3:
        if (controller.goalAmountController.text.isEmpty ||
            controller.currencyController.text.isEmpty ||
            controller.revenueController.text.isEmpty ||
            controller.deadlineController.text.isEmpty ||
            controller.useOfFundsController.text.isEmpty) {
          Get.snackbar('Required', 'Please fill all fields in the Funding section',
              backgroundColor: Colors.redAccent.withValues(alpha: 0.1), colorText: Colors.white);
          return false;
        }
        return true;
      case 4:
        if (controller.tractionController.text.isEmpty ||
            controller.goToMarketController.text.isEmpty ||
            controller.topCompetitorController.text.isEmpty ||
            controller.advantageController.text.isEmpty ||
            controller.teamController.text.isEmpty) {
          Get.snackbar('Required', 'Please fill all fields in the Execution section',
              backgroundColor: Colors.redAccent.withValues(alpha: 0.1), colorText: Colors.white);
          return false;
        }
        return true;
      case 5:
        if (controller.pitchDeckFile.value == null ||
            controller.founderContactController.text.isEmpty) {
          Get.snackbar('Required', 'Pitch Deck and Founder Contact are mandatory',
              backgroundColor: Colors.redAccent.withValues(alpha: 0.1), colorText: Colors.white);
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  Widget _buildBasicsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Startup Name',
          hint: 'e.g. EcoPulse Solutions',
          controller: controller.startupNameController,
          isRequired: true,
        ),
        const SizedBox(height: 24),
        _buildLogoPicker(),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Startup Website',
          hint: 'https://yourstartup.com',
          controller: controller.startupWebsiteController,
          isRequired: true,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Tagline',
          hint: 'A catchy one-liner for your brand',
          controller: controller.taglineController,
          isRequired: true,
        ),
        const SizedBox(height: 24),
        Obx(
          () => _buildDropdown(
            label: 'Category',
            value: controller.category.value,
            items: controller.categories,
            onChanged: (val) => controller.category.value = val!,
            isRequired: true,
          ),
        ),
        const SizedBox(height: 24),
        Obx(
          () => _buildDropdown(
            label: 'Stage',
            value: controller.stage.value,
            items: controller.stages,
            onChanged: (val) => controller.stage.value = val!,
            isRequired: true,
          ),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Location',
          hint: 'e.g. San Francisco, CA',
          controller: controller.locationController,
          isRequired: true,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'WhatsApp Number',
          hint: 'e.g. 01564561555',
          controller: controller.whatsappNumberController,
          isRequired: true,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  Widget _buildStoryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Short Pitch',
          hint: 'AI-powered fundraising for founders.',
          controller: controller.shortPitchController,
          isRequired: true,
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Problem',
          hint: 'Retailers and logistics managers often fail...',
          controller: controller.problemController,
          isRequired: true,
          maxLines: 4,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Solution',
          hint: 'A B2B analytics engine that utilizes...',
          controller: controller.solutionController,
          isRequired: true,
          maxLines: 4,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Target Market',
          hint: 'Mid-to-large scale e-commerce platforms...',
          controller: controller.targetMarketController,
          isRequired: true,
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Why Now',
          hint: 'With rising operational costs...',
          controller: controller.whyNowController,
          isRequired: true,
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Business Model',
          hint: 'How will you make money?',
          controller: controller.businessModelController,
          isRequired: true,
          maxLines: 3,
        ),
      ],
    );
  }



  Widget _buildLogoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Startup Logo',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.redAccent),
              )
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Upload your startup logo',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 12),
        ),
        const SizedBox(height: 12),
        Obx(
          () => GestureDetector(
            onTap: () => controller.pickImages(), 
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: controller.selectedImages.isNotEmpty 
                      ? ColorConst.kPrimaryColor.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: controller.selectedImages.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ColorConst.kPrimaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.cloud_upload_outlined,
                            color: ColorConst.kPrimaryColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          text: TextSpan(
                            text: 'Drag & drop or ',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 13),
                            children: [
                              TextSpan(
                                text: 'click to browse',
                                style: TextStyle(color: ColorConst.kPrimaryColor, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            File(controller.selectedImages[0].path),
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => controller.selectedImages.clear(),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => controller.submit(navigateBack: true), // Cancel saves and exits
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () async {
                      if (_validateStep()) {
                        await controller.submit(); // Save progress
                        if (controller.currentStep.value < 5) {
                          controller.currentStep.value++;
                        } else {
                          // Final step: maybe show success and go back
                          controller.submit(navigateBack: true);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      controller.currentStep.value < 5 ? 'Save & Continue' : 'Finish',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.redAccent),
                    )
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.15), fontSize: 14),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.03),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ColorConst.kPrimaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.redAccent),
                    )
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: ColorConst.kGray600,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
