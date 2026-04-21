import 'package:get/get.dart';
import '../../../data/models/deal_model.dart';
import '../../../data/providers/deals_provider.dart';

class HomeController extends GetxController {
  final DealsProvider _dealsProvider = Get.put(DealsProvider());
  
  final deals = <DealModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeals();
  }

  Future<void> fetchDeals() async {
    try {
      isLoading.value = true;
      final response = await _dealsProvider.getAllDeals();
      if (response.status.isOk) {
        final List<dynamic> items = response.body['data']['items'];
        deals.value = items.map((json) => DealModel.fromJson(json)).toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void increment() {}
}
