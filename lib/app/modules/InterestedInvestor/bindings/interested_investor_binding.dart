import 'package:get/get.dart';

import '../controllers/interested_investor_controller.dart';

class InterestedInvestorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterestedInvestorController>(
      () => InterestedInvestorController(),
    );
  }
}
