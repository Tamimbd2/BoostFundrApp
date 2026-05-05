import 'package:get/get.dart';
import '../api_constants.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;
  }

  Future<Response> login(Map data) => post(ApiConstants.login, data);
  Future<Response> googleLogin(Map data) => post(ApiConstants.googleLogin, data);
  Future<Response> facebookLogin(Map data) => post(ApiConstants.facebookLogin, data);
  Future<Response> register(Map data) => post(ApiConstants.register, data);
  Future<Response> forgotPassword(Map data) => post(
        ApiConstants.forgotPassword,
        data,
        headers: {'Content-Type': 'application/json'},
      );

  Future<Response> resetPassword(Map data) => post(
        ApiConstants.resetPassword,
        data,
        headers: {'Content-Type': 'application/json'},
      );
}
