import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contact_u_s_controller.dart';
import '../../../widgets/custom_app_bar.dart';

class ContactUSView extends GetView<ContactUSController> {
  const ContactUSView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const CustomAppBar(title: 'Contact Us'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                 
                  const Text(
                    'Contact Us Message',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Full Name
                  _buildTextField(
                    label: 'Full Name',
                    onChanged: (val) => controller.fullName.value = val,
                  ),
                  const SizedBox(height: 20),

                  // Email
                  _buildTextField(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) => controller.email.value = val,
                  ),
                  const SizedBox(height: 20),

                  // Mobile Number
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 90,
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111111),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2A2A2A)),
                        ),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.countryCode.value,
                              dropdownColor: const Color(0xFF111111),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 20,
                              ),
                              isExpanded: true,
                              items: ['+971', '+880', '+1', '+44'].map((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null)
                                  controller.countryCode.value = val;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'Mobile Number',
                          keyboardType: TextInputType.phone,
                          onChanged: (val) =>
                              controller.mobileNumber.value = val,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Message
                  _buildTextField(
                    label: 'Message',
                    maxLines: 4,
                    onChanged: (val) => controller.message.value = val,
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),

          // Submit Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => controller.submit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF333333),
                  foregroundColor: Colors.white.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SafeArea(child: Container()),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 14,
                ),
              ),
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.redAccent, fontSize: 14),
              ),
            ],
          ),
        ),
        floatingLabelStyle: const TextStyle(color: Colors.white, fontSize: 14),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        filled: true,
        fillColor: const Color(0xFF111111),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
