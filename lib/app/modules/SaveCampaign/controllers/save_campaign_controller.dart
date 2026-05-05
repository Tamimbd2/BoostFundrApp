import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/deal_model.dart';
import '../../../data/providers/deals_provider.dart';

class SaveCampaignController extends GetxController {
  final DealsProvider _dealsProvider = Get.find<DealsProvider>();

  final savedDeals = <DealModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavedDeals();
  }

  Future<void> fetchSavedDeals() async {
    try {
      isLoading.value = true;
      final response = await _dealsProvider.getBookmarks();

      if (response.status.isOk && response.body != null) {
        final dynamic data = response.body['data'];
        List<dynamic> items = [];

        if (data is List) {
          items = data;
        } else if (data != null && data['items'] != null) {
          items = data['items'];
        }

        // The API might return the deal objects directly or as part of a bookmark object
        // Usually it's a list of deals. Let's map them.
        savedDeals.value = items.map((json) {
          // If the JSON is a bookmark object containing the deal, extract it
          if (json is Map && json['deal'] != null) {
            return DealModel.fromJson(json['deal'])..isBookmarked = true;
          }
          return DealModel.fromJson(json)..isBookmarked = true;
        }).toList();
      }
    } catch (e) {
      debugPrint('Error fetching saved deals: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleBookmark(DealModel deal) async {
    if (deal.id == null) return;

    try {
      final response = await _dealsProvider.toggleBookmark(deal.id!);
      if (response.status.isOk) {
        // If successfully removed (unsaved), remove from list
        savedDeals.removeWhere((d) => d.id == deal.id);
        Get.snackbar('Success', 'Deal removed from saved list');
      } else {
        Get.snackbar('Error', 'Failed to update bookmark');
      }
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
    }
  }
}
