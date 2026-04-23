import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/my_campaign_controller.dart';

class MyCampaignView extends GetView<MyCampaignController> {
  const MyCampaignView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyCampaignView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MyCampaignView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
