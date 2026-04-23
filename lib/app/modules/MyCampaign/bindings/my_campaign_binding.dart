import 'package:get/get.dart';

import '../controllers/my_campaign_controller.dart';

class MyCampaignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyCampaignController>(
      () => MyCampaignController(),
    );
  }
}
