import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/platform_guidlines_controller.dart';

class PlatformGuidlinesView extends GetView<PlatformGuidlinesController> {
  const PlatformGuidlinesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlatformGuidlinesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PlatformGuidlinesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
