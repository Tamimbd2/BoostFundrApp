import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verifications_controller.dart';
import '../../../widgets/custom_app_bar.dart';

class PostVerificationView extends GetView<VerificationsController> {
  const PostVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const CustomAppBar(title: 'Submit Documents'),
          Expanded(
            child: Obx(() => SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Upload Verification Data'),
                  const SizedBox(height: 8),
                  Text(
                    'Please upload clear photos of your documents to verify your identity and business.',
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                  ),
                  const SizedBox(height: 32),
                  
                  // Show NID sections only if Passport and Driving Licence are NOT uploaded
                  if (controller.passport.value == null && controller.drivingLicence.value == null) ...[
                    _buildUploadSection(
                      title: 'NID Front Side',
                      file: controller.nicFront.value,
                      onTap: () => controller.pickImage('nicFront'),
                    ),
                    const SizedBox(height: 20),
                    _buildUploadSection(
                      title: 'NID Back Side',
                      file: controller.nicBack.value,
                      onTap: () => controller.pickImage('nicBack'),
                    ),
                    if (controller.nicFront.value != null || controller.nicBack.value != null)
                      const SizedBox(height: 20),
                  ],

                  // Show Passport section only if NID and Driving Licence are NOT uploaded
                  if (controller.nicFront.value == null && controller.nicBack.value == null && controller.drivingLicence.value == null) ...[
                    _buildUploadSection(
                      title: 'Passport',
                      file: controller.passport.value,
                      onTap: () => controller.pickImage('passport'),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Show Driving Licence section only if NID and Passport are NOT uploaded
                  if (controller.nicFront.value == null && controller.nicBack.value == null && controller.passport.value == null) ...[
                    _buildUploadSection(
                      title: 'Driving Licence',
                      file: controller.drivingLicence.value,
                      onTap: () => controller.pickImage('drivingLicence'),
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (controller.userRole.value == 'investor') ...[
                    const Divider(color: Colors.white10, height: 40),
                    _buildUploadSection(
                      title: 'Selfie with ID',
                      file: controller.selfie.value,
                      onTap: () => controller.pickImage('selfie'),
                    ),
                    const SizedBox(height: 20),
                  ],
                  
                  const SizedBox(height: 40),
                  _buildSubmitButton(),
                  const SizedBox(height: 40),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection({
    required String title,
    required dynamic file,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: file != null ? const Color(0xFF22C55E) : const Color(0xFF1E1E1E),
                width: 1.5,
              ),
            ),
            child: file != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(file.path),
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      const Center(
                        child: Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 40),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            if (title.contains('NID Front')) controller.nicFront.value = null;
                            else if (title.contains('NID Back')) controller.nicBack.value = null;
                            else if (title.contains('Passport')) controller.passport.value = null;
                            else if (title.contains('Driving Licence')) controller.drivingLicence.value = null;
                            else if (title.contains('Selfie')) controller.selfie.value = null;
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        title.contains('Selfie') ? Icons.face_outlined : Icons.cloud_upload_outlined,
                        color: Colors.white.withOpacity(0.3),
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title.contains('Selfie') ? 'Take a Selfie' : 'Tap to upload',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isSubmitting.value ? null : () => controller.submit(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF22C55E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: controller.isSubmitting.value
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Submit for Verification',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
