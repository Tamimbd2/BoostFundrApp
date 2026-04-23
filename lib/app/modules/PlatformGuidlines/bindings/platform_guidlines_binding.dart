import 'package:get/get.dart';

import '../controllers/platform_guidlines_controller.dart';

class PlatformGuidlinesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlatformGuidlinesController>(
      () => PlatformGuidlinesController(),
    );
  }
}
