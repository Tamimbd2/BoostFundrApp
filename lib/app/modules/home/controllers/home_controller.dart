import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/deal_model.dart';
import '../../../data/providers/deals_provider.dart';

class HomeController extends GetxController {
  final DealsProvider _dealsProvider = Get.put(DealsProvider());
  final storage = GetStorage();
  
  final deals = <DealModel>[].obs;
  final isLoading = true.obs;
  final userName = 'Mohammed'.obs;
  final currentUserId = ''.obs;
  final profileImage = ''.obs;

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

      final response = await GetConnect().get(
        'https://boost-funder.onrender.com/api/v1/users/me/founder-profile',
        headers: {
          'Authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
      );

      if (response.status.isOk && response.body != null) {
        final data = response.body['data'];
        if (data != null && data['user'] != null) {
          final user = data['user'];
          if (user['profile'] != null && user['profile']['profileImage'] != null) {
            profileImage.value = user['profile']['profileImage'];
          }
        }
      }
    } catch (_) {}
  }

  void _loadUser() {
    final user = storage.read('user');
    if (user != null) {
      if (user['firstName'] != null) userName.value = user['firstName'];
      if (user['id'] != null) currentUserId.value = user['id'];
      else if (user['_id'] != null) currentUserId.value = user['_id'];
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

  void increment() {}
}
