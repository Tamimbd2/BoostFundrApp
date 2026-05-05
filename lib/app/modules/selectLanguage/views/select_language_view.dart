import 'package:boost_fundr/export.dart';
import '../controllers/select_language_controller.dart';

class SelectLanguageView extends GetView<SelectLanguageController> {
  const SelectLanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // Title
                Text(
                  'select_language'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'choose_language_subtitle'.tr,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 48),

                // Language Options
                Obx(
                  () => Column(
                    children: [
                      _LanguageTile(
                        label: 'English',
                        isSelected: controller.selectedLanguage.value == 'en_US',
                        onTap: () => controller.selectLanguage('en_US'),
                      ),
                      const SizedBox(height: 16),
                      _LanguageTile(
                        label: 'عربي',
                        isSelected: controller.selectedLanguage.value == 'ar_AR',
                        onTap: () => controller.selectLanguage('ar_AR'),
                        isRtl: true,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Continue Button
                PrimaryButton(
                  text: controller.isFromProfile ? 'save'.tr : 'continue'.tr,
                  onPressed: controller.onContinue,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isRtl;

  const _LanguageTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isRtl = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected 
              ? ColorConst.kPrimaryColor.withValues(alpha: 0.1) 
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? ColorConst.kPrimaryColor 
                : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontFamily: isRtl ? 'Arial' : null,
              ),
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? ColorConst.kPrimaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? ColorConst.kPrimaryColor : Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.black, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
