import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/uploaded_document_controller.dart';

class UploadedDocumentView extends GetView<UploadedDocumentController> {
  const UploadedDocumentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UploadedDocumentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UploadedDocumentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
