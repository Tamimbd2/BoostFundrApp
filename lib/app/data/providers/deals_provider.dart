import 'package:get/get.dart';
import '../api_constants.dart';

class DealsProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;
    httpClient.timeout = const Duration(seconds: 60);
  }

  Future<Response> getAllDeals() async {
    const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OWU2M2NlNDAwMzQyNjBjMjRiNzM2NDUiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3NzY3Nzc4NzQsImV4cCI6MTc3NzM4MjY3NH0.HcYVYYT2rFPnsul2ZhOYy2vz37CbDnf4_UEBD0LOj2k';
    return get(
      ApiConstants.dealsAll,
      headers: {
        'Authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
    );
  }

  Future<Response> createDeal(FormData data) async {
    const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OWU2M2NlNDAwMzQyNjBjMjRiNzM2NDUiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3NzY3Nzc4NzQsImV4cCI6MTc3NzM4MjY3NH0.HcYVYYT2rFPnsul2ZhOYy2vz37CbDnf4_UEBD0LOj2k';
    return post(
      '/deals',
      data,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }
}
