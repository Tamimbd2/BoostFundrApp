import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/save_campaign_controller.dart';

class SaveCampaignView extends GetView<SaveCampaignController> {
  const SaveCampaignView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SaveCampaignView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SaveCampaignView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
