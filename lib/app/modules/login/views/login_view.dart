import 'package:boost_fundr/export.dart';
import '../controllers/login_controller.dart';
import '../../../routes/app_pages.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SplashBackground(
        child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Back Button (Optional, can go back to Select Language)
                  IconButton(
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'welcome_back'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'login_to_continue'.tr,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Social Login Section
                  Center(
                    child: SocialButton(
                      iconPath: 'assets/logo/icon/google.svg',
                      label: 'Google',
                      onTap: () => _showRoleSelectionDialog(context),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Or divider
                  Center(
                    child: Text(
                      'or'.tr,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Email Field
                  Obx(() => CustomInput(
                    hint: 'enter_email'.tr,
                    controller: TextEditingController(text: controller.email.value)..selection = TextSelection.fromPosition(TextPosition(offset: controller.email.value.length)),
                    onChanged: (val) => controller.email.value = val,
                    errorText: controller.emailError.value,
                  )),
                  const SizedBox(height: 20),

                  // Password Field
                  Obx(() => CustomInput(
                    hint: 'enter_password'.tr,
                    obscureText: !controller.isPasswordVisible.value,
                    onChanged: (val) => controller.password.value = val,
                    errorText: controller.passwordError.value,
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
                  )),

                  const SizedBox(height: 12),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                      child: Text(
                        'forgot_password'.tr,
                        style: TextStyle(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Obx(() => PrimaryButton(
                    text: 'sign_in'.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.login,
                  )),

                  const SizedBox(height: 24),


                  const SizedBox(height: 48),

                  // Register Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${'dont_have_account'.tr} ',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.REGISTER_ROLE),
                          child: Text(
                            'signup'.tr,
                            style: const TextStyle(
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

  void _showRoleSelectionDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'select_role'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'select_role_desc'.tr,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
              ),
              const SizedBox(height: 24),
              Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildRoleCard(
                      title: 'investor'.tr,
                      icon: Icons.person_outline,
                      isSelected: controller.selectedRole.value == 'investor',
                      onTap: () => controller.selectedRole.value = 'investor',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRoleCard(
                      title: 'founder'.tr,
                      icon: Icons.rocket_launch_outlined,
                      isSelected: controller.selectedRole.value == 'founder',
                      onTap: () => controller.selectedRole.value = 'founder',
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'continue'.tr,
                onPressed: () {
                  Get.back();
                  controller.loginWithGoogle(controller.selectedRole.value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : Colors.white,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppTheme.primary : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


