import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/deal_model.dart';

import '../../../data/providers/deals_provider.dart';

class MyCampaignController extends GetxController {
  final DealsProvider _dealsProvider = Get.find<DealsProvider>();
  final storage = GetStorage();
  final deals = <DealModel>[].obs;
  final isLoading = true.obs;
  final currentUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final userMap = storage.read('user');
    if (userMap != null && userMap['id'] != null) {
      currentUserId.value = userMap['id'];
    }
    fetchMyDeals();
  }

  Future<void> fetchMyDeals() async {
    try {
      isLoading.value = true;
      final token = storage.read('token');
      if (token == null) {
        isLoading.value = false;
        return;
      }

      final response = await _dealsProvider.getMyDeals();
      
      if (response.status.isOk && response.body != null) {
        final data = response.body['data'];
        if (data != null) {
          // Check if data is a list directly or has items
          final List<dynamic> dealsJson = (data is List) ? data : (data['items'] ?? []);
          deals.assignAll(dealsJson.map((json) => DealModel.fromJson(json)).toList());
        }
      } else {
        debugPrint('Failed to fetch my deals: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching my deals: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
