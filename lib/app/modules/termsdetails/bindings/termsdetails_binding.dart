import 'package:get/get.dart';

import '../controllers/termsdetails_controller.dart';

class TermsdetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsdetailsController>(
      () => TermsdetailsController(),
    );
  }
}
