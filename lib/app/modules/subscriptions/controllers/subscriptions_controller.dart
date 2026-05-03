import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/subscription_model.dart';
 
class SubscriptionsController extends GetxController {
  final storage = GetStorage();
  final plans = <SubscriptionPlan>[].obs;
  final isLoading = false.obs;
 
  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }
 
  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      final token = storage.read('token');
      
      final response = await GetConnect().get(
        'https://boost-funder.onrender.com/api/v1/subscription/',
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
      );
 
      if (response.status.isOk && response.body != null) {
        final data = response.body['data'];
        if (data != null && data['plans'] != null) {
          final List<dynamic> plansJson = data['plans'];
          plans.value = plansJson.map((json) => SubscriptionPlan.fromJson(json)).toList();
        }
      } else {
        Get.snackbar('Error', 'Failed to load subscription plans',
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Error fetching plans: $e');
    } finally {
      isLoading.value = false;
    }
  }
 
  void subscribe(SubscriptionPlan plan) {
    if (plan.price == 0) {
      Get.snackbar('Success', 'You are now on the Free plan',
          backgroundColor: const Color(0xFF22C55E).withOpacity(0.1),
          colorText: Colors.white);
      return;
    }
    
    Get.toNamed(Routes.PAYMENT, arguments: {
      'planId': plan.id,
      'planName': plan.name,
      'planPrice': plan.price.toInt().toString(),
    });
  }
}
