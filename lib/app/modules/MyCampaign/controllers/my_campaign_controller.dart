import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/deal_model.dart';

class MyCampaignController extends GetxController {
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

      final response = await GetConnect().get(
        'https://boost-funder.onrender.com/api/v1/deals/founder/me',
        headers: {
          'Authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
      );

      if (response.status.isOk && response.body != null) {
        final data = response.body['data'];
        if (data != null && data['items'] != null) {
          final List<dynamic> dealsJson = data['items'];
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
