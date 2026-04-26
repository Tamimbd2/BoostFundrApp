import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../api_constants.dart';

class VerificationsProvider extends GetConnect {
  final storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;
    httpClient.timeout = const Duration(seconds: 60);
  }

  Future<Response> getVerificationStatus() async {
    final token = storage.read('token');
    return get(
      ApiConstants.verificationStatus,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
    );
  }

  Future<Response> submitVerification(FormData data) async {
    final token = storage.read('token');
    return post(
      ApiConstants.submitVerification,
      data,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
}
