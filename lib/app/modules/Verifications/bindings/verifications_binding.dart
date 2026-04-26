import 'package:get/get.dart';

import '../controllers/verifications_controller.dart';

class VerificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationsController>(
      () => VerificationsController(),
    );
  }
}
