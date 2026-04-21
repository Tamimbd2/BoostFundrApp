import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/select_language_controller.dart';

class SelectLanguageView extends GetView<SelectLanguageController> {
  const SelectLanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  // Title
                  const Text(
                    'Select Language',
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
                    'Choose your preferred language.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Language Options
                  Obx(
                    () => Column(
                      children: [
                        _LanguageTile(
                          label: 'English',
                          isSelected: controller.selectedLanguage.value == 'en',
                          onTap: () => controller.selectLanguage('en'),
                        ),
                        const SizedBox(height: 16),
                        _LanguageTile(
                          label: 'عربي',
                          isSelected: controller.selectedLanguage.value == 'ar',
                          onTap: () => controller.selectLanguage('ar'),
                          isRtl: true,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),

          // Continue Button at bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: controller.onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A1F12) : const Color(0xFF111111),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF22C55E)
                : const Color(0xFF2A2A2A),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: isRtl ? 'Arial' : null,
              ),
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFF22C55E)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF22C55E)
                      : const Color(0xFF3A3A3A),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
