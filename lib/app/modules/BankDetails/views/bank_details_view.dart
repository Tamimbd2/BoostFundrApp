import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bank_details_controller.dart';

class BankDetailsView extends GetView<BankDetailsController> {
  const BankDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BankDetailsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BankDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
