import 'package:get/get.dart';

import '../controllers/contact_u_s_controller.dart';

class ContactUSBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactUSController>(
      () => ContactUSController(),
    );
  }
}
