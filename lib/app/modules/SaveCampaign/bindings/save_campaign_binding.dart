import 'package:get/get.dart';

import '../controllers/save_campaign_controller.dart';

class SaveCampaignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaveCampaignController>(
      () => SaveCampaignController(),
    );
  }
}
