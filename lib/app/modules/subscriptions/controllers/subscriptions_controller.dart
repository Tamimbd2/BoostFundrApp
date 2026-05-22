import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/subscription_model.dart';

class SubscriptionsController extends GetxController {
  final storage = GetStorage();
  final plans = <SubscriptionPlan>[].obs;
  final currentPlan = ''.obs;
  final userRole = 'founder'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserRole();
    fetchPlans();
    if (userRole.value == 'investor') {
      fetchCurrentSubscription();
    }
  }

  void _loadUserRole() {
    final user = storage.read('user');
    if (user != null && user['role'] != null) {
      userRole.value = user['role'];
    }
  }

  Future<void> fetchCurrentSubscription() async {
    try {
      final token = storage.read('token');
      final response = await GetConnect().get(
        'https://boost-funder.onrender.com/api/v1/users/me/investor-profile',
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
      );

      if (response.status.isOk && response.body != null) {
        final data = response.body['data'];
        if (data != null &&
            data['user'] != null &&
            data['user']['plan'] != null) {
          currentPlan.value = data['user']['plan'];
        }
      }
    } catch (e) {
      debugPrint('Error fetching current subscription: $e');
    }
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
          plans.value = plansJson
              .map((json) => SubscriptionPlan.fromJson(json))
              .toList();
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to load subscription plans',
          backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error fetching plans: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void subscribe(SubscriptionPlan plan) {
    if (plan.price == 0) {
      Get.snackbar(
        'Success',
        'You are now on the Free plan',
        backgroundColor: const Color(0xFF22C55E).withValues(alpha: 0.1),
        colorText: Colors.white,
      );
      return;
    }

    Get.toNamed(
      Routes.PAYMENT,
      arguments: {
        'planId': plan.id,
        'planName': plan.name,
        'planPrice': plan.price.toInt().toString(),
      },
    );
  }
}
