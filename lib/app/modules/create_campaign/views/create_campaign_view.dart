import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_campaign_controller.dart';

class CreateCampaignView extends GetView<CreateCampaignController> {
  const CreateCampaignView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePickerSection(isRequired: true),
            const SizedBox(height: 32),
            _buildTextField(
              label: 'Startup Name',
              hint: 'Enter startup name',
              controller: controller.startupNameController,
              isRequired: true,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Short Pitch',
              hint: 'Describe your startup in one sentence',
              controller: controller.shortPitchController,
              maxLines: 3,
              isRequired: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => _buildDropdown(
                      label: 'Category',
                      value: controller.category.value,
                      items: controller.categories,
                      onChanged: (val) => controller.category.value = val!,
                      isRequired: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => _buildDropdown(
                      label: 'Stage',
                      value: controller.stage.value,
                      items: controller.stages,
                      onChanged: (val) => controller.stage.value = val!,
                      isRequired: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Goal Amount',
                    hint: 'e.g. 250000',
                    controller: controller.goalAmountController,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'Currency',
                    hint: 'e.g. AED',
                    controller: controller.currencyController,
                    isRequired: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Deadline',
              hint: 'Select deadline date',
              controller: controller.deadlineController,
              isRequired: true,
              readOnly: true,
              onTap: () => controller.chooseDate(),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Raised Amount',
              hint: 'e.g. 50000',
              controller: controller.raisedAmountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Location',
              hint: 'e.g. Bangladesh',
              controller: controller.locationController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Tagline',
              hint: 'Short catchy tagline',
              controller: controller.taglineController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Problem',
              hint: 'What problem are you solving?',
              controller: controller.problemController,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Solution',
              hint: 'What is your solution?',
              controller: controller.solutionController,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Business Model',
              hint: 'How will you make money?',
              controller: controller.businessModelController,
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Market',
              hint: 'Target market details',
              controller: controller.marketController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Traction',
              hint: 'Current traction details',
              controller: controller.tractionController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Team',
              hint: 'Who is on your team?',
              controller: controller.teamController,
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Geography',
              hint: 'Where do you operate?',
              controller: controller.geographyController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Use of Funds',
              hint: 'How will the funds be used?',
              controller: controller.useOfFundsController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'FAQ',
              hint: 'Commonly asked questions',
              controller: controller.faqController,
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Founder Contact',
              hint: 'Email or phone number',
              controller: controller.founderContactController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Financial Details',
              hint: 'e.g. 1250k raised',
              controller: controller.financialDetailsController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Pitch Deck / Nice Idea',
              hint: 'Link or description',
              controller: controller.pitchDeckController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Detailed Traction Data',
              hint: 'Traction details',
              controller: controller.detailedTractionDataController,
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Private Documents',
              hint: 'e.g. have cofounders',
              controller: controller.privateDocumentsController,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.submit(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
                      : const Text(
                          'Create Deal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerSection({bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Campaign Media',
            style: const TextStyle(
              color: Colors.white70,
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
        const SizedBox(height: 12),
        Obx(
          () => SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.selectedImages.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index == controller.selectedImages.length) {
                  return GestureDetector(
                    onTap: () => controller.pickImages(),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF22C55E).withOpacity(0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        color: Color(0xFF22C55E),
                        size: 28,
                      ),
                    ),
                  );
                }

                return Stack(
                  children: [
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: FileImage(
                            File(controller.selectedImages[index].path),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => controller.removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
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
  }) {
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
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
            filled: true,
            fillColor: const Color(0xFF111111),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1E1E1E)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF22C55E)),
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
            style: const TextStyle(
              color: Colors.white70,
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
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1E1E1E)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: const Color(0xFF111111),
              isExpanded: true,
              style: const TextStyle(color: Colors.white),
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
