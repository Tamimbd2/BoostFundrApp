import 'package:boost_fundr/export.dart';
import '../controllers/register_role_controller.dart';

class RegisterRoleView extends GetView<RegisterRoleController> {
  const RegisterRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SplashBackground(
        child: SafeArea(
          child: Padding(
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
                Text(
                  'select_category'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'tell_us_purpose'.tr,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 48),

                // Role Options
                Obx(
                  () => Column(
                    children: [
                      _RoleTile(
                        label: 'investor'.tr,
                        isSelected: controller.selectedRole.value == 'Investor',
                        onTap: () => controller.selectRole('Investor'),
                      ),
                      const SizedBox(height: 16),
                      _RoleTile(
                        label: 'founder'.tr,
                        isSelected: controller.selectedRole.value == 'Founder',
                        onTap: () => controller.selectRole('Founder'),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Continue Button pinned to bottom
                PrimaryButton(
                  text: 'continue'.tr,
                  onPressed: controller.onContinue,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primary
                      : Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
