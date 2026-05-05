import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class SplashController extends GetxController {
  static SplashController get to => Get.find();
  final storage = GetStorage();


  void checkNavigation() {
    Future.delayed(const Duration(seconds: 3), () {
      final token = storage.read('token');
      if (token != null && token.toString().isNotEmpty) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/select-language');
      }
    });
  }
}
