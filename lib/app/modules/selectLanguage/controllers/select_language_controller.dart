import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SelectLanguageController extends GetxController {
  final selectedLanguage = 'en'.obs;

  void selectLanguage(String language) {
    selectedLanguage.value = language;
  }

  void onContinue() {
    Get.toNamed(Routes.LOGIN);
  }
}
