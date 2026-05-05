import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

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
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isInitialLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF22C55E)));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Personal Info'),
              const SizedBox(height: 20),
              _buildImagePicker(),
              const SizedBox(height: 24),
              _buildTextField(label: 'First Name', controller: controller.firstNameController, isRequired: true),
              const SizedBox(height: 16),
              _buildTextField(label: 'Last Name', controller: controller.lastNameController, isRequired: true),
              const SizedBox(height: 16),
              _buildTextField(label: 'Email', controller: controller.emailController, isRequired: true, readOnly: true),
              const SizedBox(height: 16),
              _buildTextField(label: 'Mobile Number', controller: controller.phoneController, hint: 'Enter phone number', isRequired: true),
              const SizedBox(height: 16),
              _buildTextField(label: 'Location', controller: controller.locationController, hint: 'e.g. San Francisco, USA'),
              const SizedBox(height: 16),
              _buildTextField(label: 'Bio', controller: controller.bioController, hint: 'Short bio', maxLines: 3),
              const SizedBox(height: 32),
              
              const SizedBox(height: 32),
              
              if (controller.userRole.value == 'founder') ...[
                _buildSectionTitle('Company Info'),
                const SizedBox(height: 20),
                _buildTextField(label: 'Company Name', controller: controller.companyNameController, hint: 'Enter company name', isRequired: true),
                const SizedBox(height: 16),
                _buildTextField(label: 'Company Website', controller: controller.companyWebsiteController, hint: 'https://...'),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Startup Stage',
                  value: controller.selectedStage.value,
                  items: controller.stages,
                  onChanged: (val) => controller.selectedStage.value = val!,
                ),
                const SizedBox(height: 16),
                _buildTextField(label: 'Startup Description', controller: controller.startupDescriptionController, hint: 'Describe your startup', maxLines: 3),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField(label: 'Funding Goal', controller: controller.fundingGoalController, hint: 'e.g. 150000', keyboardType: TextInputType.number)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(label: 'Team Size', controller: controller.teamSizeController, hint: 'e.g. 6', keyboardType: TextInputType.number)),
                  ],
                ),
              ] else ...[
                _buildSectionTitle('Investment Preferences'),
                const SizedBox(height: 20),
                _buildTextField(label: 'Interests', controller: controller.interestsController, hint: 'e.g. fintech, saas, technology'),
                const SizedBox(height: 16),
                _buildTextField(label: 'Target Sectors', controller: controller.sectorsController, hint: 'e.g. technology, healthcare'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField(label: 'Min Investment', controller: controller.minInvestmentController, hint: 'e.g. 1000', keyboardType: TextInputType.number)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(label: 'Max Investment', controller: controller.maxInvestmentController, hint: 'e.g. 50000', keyboardType: TextInputType.number)),
                  ],
                ),
              ],
              const SizedBox(height: 32),

              _buildSectionTitle('Social Links'),
              const SizedBox(height: 20),
              _buildTextField(label: 'LinkedIn', controller: controller.linkedinController, hint: 'URL'),
              const SizedBox(height: 16),
              _buildTextField(label: 'Twitter', controller: controller.twitterController, hint: 'URL'),
              const SizedBox(height: 16),
              _buildTextField(label: 'Facebook', controller: controller.facebookController, hint: 'URL'),
              const SizedBox(height: 16),
              _buildTextField(label: 'GitHub', controller: controller.githubController, hint: 'URL'),
              
              const SizedBox(height: 40),
              _buildActionButtons(),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildImagePicker() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => controller.pickImage(),
          child: Stack(
            children: [
              Obx(() => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
                  image: controller.selectedImagePath.value.isNotEmpty
                      ? DecorationImage(image: FileImage(File(controller.selectedImagePath.value)), fit: BoxFit.cover)
                      : (controller.profileImage.value.isNotEmpty
                          ? DecorationImage(image: NetworkImage(controller.profileImage.value), fit: BoxFit.cover)
                          : null),
                ),
                child: controller.selectedImagePath.value.isEmpty && controller.profileImage.value.isEmpty
                    ? const Icon(Icons.person, color: Colors.white24, size: 40)
                    : null,
              )),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile Photo', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('Tap to change', style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    String? hint,
    int maxLines = 1,
    bool isRequired = false,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
            children: isRequired ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent))] : [],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: TextStyle(color: readOnly ? Colors.white38 : Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
            filled: true,
            fillColor: const Color(0xFF111111),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E1E1E))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF22C55E))),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({required String label, required String value, required List<String> items, required Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E1E1E))),
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF1E1E1E)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : () => controller.updateProfile(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: controller.isLoading.value
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )),
        ),
      ],
    );
  }
}
