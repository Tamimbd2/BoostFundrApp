import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/interested_investor_controller.dart';

class InterestedInvestorView extends GetView<InterestedInvestorController> {
  const InterestedInvestorView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InterestedInvestorView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InterestedInvestorView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
