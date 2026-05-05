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
    final user = storage.read('user');
    final role = user?['role'] ?? 'founder';
    
    final endpoint = role == 'investor' 
        ? ApiConstants.investorVerificationStatus 
        : ApiConstants.verificationStatus;

    return get(
      endpoint,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
    );
  }

  Future<Response> submitVerification(FormData data) async {
    final token = storage.read('token');
    final user = storage.read('user');
    final role = user?['role'] ?? 'founder';

    final endpoint = role == 'investor' 
        ? ApiConstants.submitInvestorVerification 
        : ApiConstants.submitVerification;

    return post(
      endpoint,
      data,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
}
