import 'package:get/get.dart';
import '../api_constants.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;
  }

  Future<Response> login(Map data) => post(ApiConstants.login, data);
  Future<Response> googleLogin(Map data) => post(ApiConstants.googleLogin, data);
  Future<Response> register(Map data) => post(ApiConstants.register, data);
}
