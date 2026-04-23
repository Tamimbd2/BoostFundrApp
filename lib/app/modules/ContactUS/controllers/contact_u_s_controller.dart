import 'package:get/get.dart';

class ContactUSController extends GetxController {
  final fullName = ''.obs;
  final email = ''.obs;
  final countryCode = '+971'.obs;
  final mobileNumber = ''.obs;
  final message = ''.obs;

  void submit() {
    // Implement submission logic
    Get.back();
  }
}
