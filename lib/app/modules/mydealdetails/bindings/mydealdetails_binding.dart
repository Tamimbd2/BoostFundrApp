import 'package:get/get.dart';

import '../controllers/mydealdetails_controller.dart';

class MydealdetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MydealdetailsController>(
      () => MydealdetailsController(),
    );
  }
}
