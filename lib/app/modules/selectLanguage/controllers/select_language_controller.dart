import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';

class SelectLanguageController extends GetxController {
  final storage = GetStorage();
  final selectedLanguage = 'en_US'.obs;

  @override
  void onInit() {
    super.onInit();
    final savedLang = storage.read('language') ?? 'en_US';
    selectedLanguage.value = savedLang;
  }

  bool get isFromProfile => Get.arguments == 'profile';

  void selectLanguage(String language) {
    selectedLanguage.value = language;
  }

  void onContinue() {
    // Save to storage
    storage.write('language', selectedLanguage.value);
    
    // Update Locale
    if (selectedLanguage.value.contains('_')) {
      final parts = selectedLanguage.value.split('_');
      Get.updateLocale(Locale(parts[0], parts[1]));
    } else {
      Get.updateLocale(Locale(selectedLanguage.value));
    }

    if (isFromProfile) {
      Get.back();
    } else {
      Get.toNamed(Routes.LOGIN);
    }
  }
}
