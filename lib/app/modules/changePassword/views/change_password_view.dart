import 'package:boost_fundr/export.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        
                        // Back Button
                        IconButton(
                          onPressed: () => Get.back(),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                        ),

                        const SizedBox(height: 20),

                        // Title
                        Text(
                          'set_new_password'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          'set_new_password_subtitle'.tr,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Email Display
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.alternate_email, color: Colors.white.withValues(alpha: 0.5), size: 18),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Obx(() => Text(
                                  controller.email.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Glass Card for Input
                        GlassCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // OTP Field
                              Text(
                                'otp'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              CustomInput(
                                hint: 'enter_otp'.tr,
                                onChanged: (val) => controller.otp.value = val,
                                prefixIcon: Icon(
                                  Icons.vpn_key_outlined,
                                  color: Colors.white.withValues(alpha: 0.3),
                                  size: 20,
                                ),
                              ),

                              const SizedBox(height: 24),

                              // New Password
                              Text(
                                'new_password'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Obx(() => CustomInput(
                                hint: 'enter_new_password'.tr,
                                obscureText: !controller.isPasswordVisible.value,
                                onChanged: (val) => controller.newPassword.value = val,
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white.withValues(alpha: 0.3),
                                  size: 20,
                                ),
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

                              const SizedBox(height: 24),

                              // Confirm Password
                              Text(
                                'confirm_new_password'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Obx(() => CustomInput(
                                hint: 'retype_new_password'.tr,
                                obscureText: !controller.isConfirmPasswordVisible.value,
                                onChanged: (val) => controller.confirmPassword.value = val,
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white.withValues(alpha: 0.3),
                                  size: 20,
                                ),
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
                              )),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Update Button
                        Obx(
                          () => PrimaryButton(
                            text: 'update_password'.tr,
                            isLoading: controller.isLoading.value,
                            onPressed: controller.changePassword,
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
