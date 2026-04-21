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
          'Create Campaign',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePickerSection(),
            const SizedBox(height: 32),
            _buildTextField(
              label: 'Startup Name',
              hint: 'Enter startup name',
              controller: controller.startupNameController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Short Pitch',
              hint: 'Describe your startup in one sentence',
              controller: controller.shortPitchController,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Obx(() => _buildDropdown(
                    label: 'Category',
                    value: controller.category.value,
                    items: controller.categories,
                    onChanged: (val) => controller.category.value = val!,
                  )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => _buildDropdown(
                    label: 'Stage',
                    value: controller.stage.value,
                    items: controller.stages,
                    onChanged: (val) => controller.stage.value = val!,
                  )),
                ),
              ],
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
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.submit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Create Deal',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              )),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Campaign Media',
          style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Obx(() => SizedBox(
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
                      border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
                    ),
                    child: const Icon(Icons.add_a_photo_outlined, color: Color(0xFF22C55E), size: 28),
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
                        image: FileImage(File(controller.selectedImages[index].path)),
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
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(Icons.close, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
            filled: true,
            fillColor: const Color(0xFF111111),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
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
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
