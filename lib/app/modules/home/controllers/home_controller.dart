import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/deal_model.dart';
import '../../../data/providers/deals_provider.dart';
import '../../../data/api_constants.dart';

class HomeController extends GetxController {
  final DealsProvider _dealsProvider = Get.put(DealsProvider());
  final storage = GetStorage();

  final deals = <DealModel>[].obs;
  final isLoading = true.obs;
  final userName = 'Mohammed'.obs;
  final currentUserId = ''.obs;
  final profileImage = ''.obs;
  final userRole = 'founder'.obs;
  final isVerified = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    fetchDeals();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final token = storage.read('token');
      if (token == null) return;

      final endpoint = userRole.value == 'investor'
          ? ApiConstants.investorProfile
          : ApiConstants.founderProfile;

      final response = await GetConnect().get(
        '${ApiConstants.baseUrl}$endpoint',
        headers: {
          'Authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
      );

      if (response.status.isOk && response.body != null) {
        final data = response.body['data'];
        if (data != null && data['user'] != null) {
          final user = data['user'];

          // Strictly update isVerified from API response
          isVerified.value = user['isVerified'] == true;

          if (user['profile'] != null &&
              user['profile']['profileImage'] != null) {
            profileImage.value = user['profile']['profileImage'];
          }

          // Persist updated user info to storage
          final storedUser = storage.read('user') ?? {};
          storedUser['isVerified'] = isVerified.value;
          
          // Save plan/accessLevel if present
          if (user['plan'] != null) storedUser['plan'] = user['plan'];
          if (user['accessLevel'] != null) storedUser['accessLevel'] = user['accessLevel'];

          if (user['firstName'] != null)
            storedUser['firstName'] = user['firstName'];
          if (user['lastName'] != null)
            storedUser['lastName'] = user['lastName'];
          storage.write('user', storedUser);
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  void _loadUser() {
    final user = storage.read('user');
    if (user != null) {
      if (user['firstName'] != null) userName.value = user['firstName'];
      if (user['id'] != null) {
        currentUserId.value = user['id'];
      } else if (user['_id'] != null) {
        currentUserId.value = user['_id'];
      }
      if (user['role'] != null) userRole.value = user['role'];

      // We no longer load isVerified from storage here to ensure
      // it is strictly updated only from the API response.
    }
  }

  Future<void> fetchDeals() async {
    try {
      isLoading.value = true;
      final response = await _dealsProvider.getDealsFeed();

      if (response.status.isOk && response.body != null) {
        final dynamic data = response.body['data'];
        List<dynamic> items = [];

        if (data is List) {
          items = data;
        } else if (data != null && data['items'] != null) {
          items = data['items'];
        }

        deals.value = items.map((json) => DealModel.fromJson(json)).toList();
      }
    } catch (_) {
      // Error handling
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleBookmark(DealModel deal) async {
    if (deal.id == null) return;

    try {
      // Optimistic UI update
      final bool wasBookmarked = deal.isBookmarked ?? false;
      deal.isBookmarked = !wasBookmarked;
      deals.refresh(); // Refresh list to show change

      final response = await _dealsProvider.toggleBookmark(deal.id!);

      if (!response.status.isOk) {
        // Rollback on error
        deal.isBookmarked = wasBookmarked;
        deals.refresh();
        Get.snackbar('Error', 'Failed to update bookmark');
      }
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
    }
  }

  void increment() {}
}
