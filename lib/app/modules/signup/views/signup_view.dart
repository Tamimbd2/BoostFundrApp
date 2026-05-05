import 'package:boost_fundr/export.dart';
import '../controllers/signup_controller.dart';
import '../../../routes/app_pages.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SplashBackground(
        child: SafeArea(
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
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Join BoostFundr and start your journey.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 40),

                   Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        // First Name Field
                        CustomInput(
                          hint: 'First Name',
                          onChanged: (val) => controller.firstName.value = val,
                        ),
                        const SizedBox(height: 20),

                        // Last Name Field
                        CustomInput(
                          hint: 'Last Name',
                          onChanged: (val) => controller.lastName.value = val,
                        ),
                        const SizedBox(height: 20),

                        // Email Field
                        CustomInput(
                          hint: 'Email Address',
                          onChanged: (val) => controller.email.value = val,
                        ),
                        const SizedBox(height: 20),

                        // Role Selection Dropdown
                        Obx(
                          () => Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.selectedRole.value,
                                dropdownColor: Colors.black,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                                items: controller.roles.map((String role) {
                                  return DropdownMenuItem<String>(value: role, child: Text(role));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) controller.selectedRole.value = val;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        Obx(
                          () => CustomInput(
                            hint: 'Password',
                            obscureText: !controller.isPasswordVisible.value,
                            onChanged: (val) => controller.password.value = val,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white.withValues(alpha: 0.3),
                                size: 20,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Confirm Password Field
                        Obx(
                          () => CustomInput(
                            hint: 'Confirm Password',
                            obscureText: !controller.isConfirmPasswordVisible.value,
                            onChanged: (val) => controller.confirmPassword.value = val,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isConfirmPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white.withValues(alpha: 0.3),
                                size: 20,
                              ),
                              onPressed: controller.toggleConfirmPasswordVisibility,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Sign Up Button
                  Obx(
                    () => PrimaryButton(
                      text: 'signup'.tr,
                      isLoading: controller.isLoading.value,
                      onPressed: controller.signup,
                    ),
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
                            color: Colors.white.withValues(alpha: 0.45),
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
      ),
    );
  }

}
