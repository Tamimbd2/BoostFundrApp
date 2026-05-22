import 'dart:async';
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

  final fundingGoalController = TextEditingController();
  final fundingGoal = 0.0.obs;
  final calculatedFeeNumbers = <String, double>{}.obs;
  final isCalculatingFee = false.obs;
  final feeCurrency = 'AED'.obs;
  Timer? _debounce;
 
  @override
  void onInit() {
    super.onInit();
    _loadUserRole();
    fetchPlans();
    fetchCurrentSubscription();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    fundingGoalController.dispose();
    super.onClose();
  }

  void _loadUserRole() {
    final user = storage.read('user');
    if (user != null && user['role'] != null) {
      userRole.value = user['role'];
    }
  }

  void onFundingGoalChanged(String value) {
    final cleanValue = value.replaceAll(',', '').replaceAll(' ', '');
    final goal = double.tryParse(cleanValue) ?? 0.0;
    fundingGoal.value = goal;
    debugPrint('=== Funding Goal Changed: $goal ===');

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (goal <= 0) {
      final zeros = <String, double>{};
      for (var plan in plans) {
        zeros[plan.id] = 0.0;
      }
      calculatedFeeNumbers.value = zeros;
      calculatedFeeNumbers.refresh();
      plans.refresh();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _calculateFeesFromApi(goal);
    });
  }

  String formatNumber(double num) {
    if (num == num.roundToDouble()) {
      return num.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }
    return num.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  Future<void> _calculateFeesFromApi(double goal) async {
    final token = storage.read('token');
    if (token == null) {
      debugPrint('=== Cannot calculate fee: User token is null ===');
      return;
    }

    final newFeeMap = <String, double>{...calculatedFeeNumbers};
    bool anyUpdated = false;

    for (var plan in plans) {
      if (plan.successFee <= 0) {
        newFeeMap[plan.id] = 0.0;
        continue;
      }

      debugPrint('=== Hitting Calculate Fee API for [${plan.name}] (Package ID: ${plan.id}) ===');
      debugPrint('Payload: {"packageId": "${plan.id}", "fundingGoal": $goal}');

      try {
        final response = await GetConnect().post(
          'https://boost-funder.onrender.com/api/founder/packages/calculate-fee',
          {
            'packageId': plan.id,
            'fundingGoal': goal,
          },
          headers: {
            'Authorization': 'Bearer $token',
            'content-type': 'application/json',
          },
        );

        debugPrint('=== Response for [${plan.name}]: Status: ${response.statusCode}, Body: ${response.body} ===');

        if (response.status.isOk && response.body != null) {
          final body = response.body;
          if (body['success'] == true && body['data'] != null) {
            final data = body['data'];
            if (data['calculatedFee'] != null) {
              final feeVal = double.tryParse(data['calculatedFee'].toString()) ?? (goal * plan.successFee / 100);
              newFeeMap[plan.id] = feeVal;
              anyUpdated = true;
            }
          }
        }
      } catch (e) {
        debugPrint('Error calculating fee for ${plan.id}: $e');
      }

      if (newFeeMap[plan.id] == null || newFeeMap[plan.id] == 0.0) {
        final feeVal = goal * plan.successFee / 100;
        newFeeMap[plan.id] = feeVal;
        anyUpdated = true;
      }
    }

    if (anyUpdated) {
      calculatedFeeNumbers.value = newFeeMap;
      calculatedFeeNumbers.refresh();
      plans.refresh();
    }
  }

  Future<void> fetchCurrentSubscription() async {
    try {
      final token = storage.read('token');
      final endpoint = userRole.value == 'founder'
          ? 'https://boost-funder.onrender.com/api/v1/users/me/founder-profile'
          : 'https://boost-funder.onrender.com/api/v1/users/me/investor-profile';

      final response = await GetConnect().get(
        endpoint,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
      );

      if (response.status.isOk && response.body != null) {
        final data = response.body['data'];
        if (data != null && data['user'] != null) {
          final plan = data['user']['plan'] ?? data['user']['package'] ?? data['user']['currentPlan'] ?? data['user']['subscriptionPlan'];
          if (plan != null && plan.toString().isNotEmpty) {
            currentPlan.value = plan.toString();
          }
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
      
      final endpoint = userRole.value == 'founder'
          ? 'https://boost-funder.onrender.com/api/founder/packages'
          : 'https://boost-funder.onrender.com/api/v1/subscription/';

      final response = await GetConnect().get(
        endpoint,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
      );
 
      if (response.status.isOk && response.body != null) {
        List<dynamic> itemsJson = [];
        final body = response.body;
        if (body is List) {
          itemsJson = body;
        } else if (body is Map) {
          if (body['data'] != null) {
            final data = body['data'];
            if (data is List) {
              itemsJson = data;
            } else if (data is Map) {
              itemsJson = data['packages'] ?? data['plans'] ?? data['data'] ?? [];
            }
          } else if (body['packages'] != null) {
            itemsJson = body['packages'] as List<dynamic>;
          } else if (body['plans'] != null) {
            itemsJson = body['plans'] as List<dynamic>;
          }
        }

        if (itemsJson.isNotEmpty) {
          plans.value = itemsJson.map((json) => SubscriptionPlan.fromJson(json as Map<String, dynamic>)).toList();
          final initial = <String, double>{};
          for (var plan in plans) {
            initial[plan.id] = 0.0;
          }
          calculatedFeeNumbers.value = initial;
        }
      } else {
        Get.snackbar('Error', 'Failed to load subscription plans',
            backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
            colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Error fetching plans: $e');
    } finally {
      isLoading.value = false;
    }
  }
 
  void subscribe(SubscriptionPlan plan) {
    if (userRole.value == 'founder') {
      double fee = calculatedFeeNumbers[plan.id] ?? 0.0;
      if (fee <= 0) fee = plan.price > 0 ? plan.price : 100.0;
      double currentGoal = fundingGoal.value > 0 ? fundingGoal.value : 1000000.0;

      _showPaymentMethodDialog(plan, fee, currentGoal);
      return;
    }

    if (plan.price == 0) {
      Get.snackbar('Success', 'You are now on the Free plan',
          backgroundColor: const Color(0xFF22C55E).withValues(alpha: 0.1),
          colorText: Colors.white);
      return;
    }

    Get.toNamed(Routes.PAYMENT, arguments: {
      'planId': plan.id,
      'planName': plan.name,
      'planPrice': plan.price.toInt().toString(),
      'isFounder': false,
    });
  }

  void _showPaymentMethodDialog(SubscriptionPlan plan, double fee, double currentGoal) {
    final feeString = formatNumber(fee);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF0C120E),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.3), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${plan.name.toUpperCase()} PACKAGE',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total Fee: AED $feeString',
                      style: const TextStyle(color: Color(0xFF22C55E), fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              'Select Payment Method',
              style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            _buildMethodOption(6, 'Debit / Credit Card', Icons.credit_card, plan, feeString, currentGoal),
            const SizedBox(height: 12),
            _buildMethodOption(9, 'Apple Pay', Icons.apple, plan, feeString, currentGoal),
            const SizedBox(height: 12),
            _buildMethodOption(16, 'Google Pay', Icons.account_balance_wallet, plan, feeString, currentGoal),
            const SizedBox(height: 32),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildMethodOption(int methodId, String name, IconData icon, SubscriptionPlan plan, String feeString, double currentGoal) {
    return InkWell(
      onTap: () {
        Get.back(); // close bottom sheet
        Get.toNamed(Routes.PAYMENT, arguments: {
          'planId': plan.id,
          'planName': plan.name,
          'planPrice': feeString,
          'isFounder': true,
          'selectedMethodId': methodId,
          'fundingGoal': currentGoal,
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF22C55E), size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
          ],
        ),
      ),
    );
  }
}
