import 'package:boost_fundr/export.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
                          'forgot_password_title'.tr,
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
                          'forgot_password_subtitle'.tr,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Glass Card for Input
                        GlassCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'email_address'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              CustomInput(
                                hint: 'enter_email'.tr,
                                onChanged: (val) => controller.email.value = val,
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.white.withValues(alpha: 0.3),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Reset Button
                        Obx(
                          () => PrimaryButton(
                            text: 'send_reset_link'.tr,
                            isLoading: controller.isLoading.value,
                            onPressed: controller.sendOtp,
                          ),
                        ),

                        const Spacer(),

                        // Back to Login
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'remember_password'.tr,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.45),
                                    fontSize: 14,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    'login_btn'.tr,
                                    style: const TextStyle(
                                      color: Color(0xFF22C55E),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
