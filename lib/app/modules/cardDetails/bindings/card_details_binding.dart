import 'package:get/get.dart';

import '../controllers/card_details_controller.dart';

class CardDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CardDetailsController>(
      () => CardDetailsController(),
    );
  }
}
