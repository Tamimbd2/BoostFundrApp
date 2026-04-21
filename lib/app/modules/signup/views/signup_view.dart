import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';
import '../../../routes/app_pages.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Back Button
                  IconButton(
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Join BoostFundr and start your journey.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // First Name Field
                  _buildTextField(
                    label: 'First Name',
                    hintText: 'Enter your first name',
                    onChanged: (val) => controller.firstName.value = val,
                  ),
                  const SizedBox(height: 20),

                  // Last Name Field
                  _buildTextField(
                    label: 'Last Name',
                    hintText: 'Enter your last name',
                    onChanged: (val) => controller.lastName.value = val,
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  _buildTextField(
                    label: 'Email Address',
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) => controller.email.value = val,
                  ),
                  const SizedBox(height: 20),

                  // Role Selection Dropdown
                  Obx(() => _buildDropdownField(
                    label: 'Register As',
                    value: controller.selectedRole.value,
                    items: controller.roles,
                    onChanged: (val) {
                      if (val != null) controller.selectedRole.value = val;
                    },
                  )),
                  const SizedBox(height: 20),

                  // Password Field
                  Obx(() => _buildTextField(
                    label: 'Password',
                    hintText: 'Create a password',
                    isPassword: !controller.isPasswordVisible.value,
                    onChanged: (val) => controller.password.value = val,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.3),
                        size: 20,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  )),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  Obx(() => _buildTextField(
                    label: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    isPassword: !controller.isConfirmPasswordVisible.value,
                    onChanged: (val) => controller.confirmPassword.value = val,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.3),
                        size: 20,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  )),

                  const SizedBox(height: 40),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: const Color(0xFF22C55E).withOpacity(0.5),
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
                              'Create Account',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                    )),
                  ),

                  const SizedBox(height: 32),

                  // Login Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.offNamed(Routes.LOGIN),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Color(0xFF22C55E),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    bool isPassword = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: TextField(
            obscureText: isPassword,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              border: InputBorder.none,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: const Color(0xFF111111),
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white.withOpacity(0.3)),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              items: items.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
