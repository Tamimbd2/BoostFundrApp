import 'package:get/get.dart';

import '../controllers/uploaded_document_controller.dart';

class UploadedDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadedDocumentController>(
      () => UploadedDocumentController(),
    );
  }
}
