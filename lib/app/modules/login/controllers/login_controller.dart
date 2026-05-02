import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../../data/providers/auth_provider.dart' as local;

class LoginController extends GetxController {
  final local.AuthProvider _authProvider = Get.find<local.AuthProvider>();
  final storage = GetStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  final email = ''.obs;
  final password = ''.obs;
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final selectedRole = 'investor'.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool _validate() {
    if (email.value.isEmpty || !GetUtils.isEmail(email.value)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (password.value.isEmpty || password.value.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters long',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  Future<void> login() async {
    if (!_validate()) return;

    try {
      isLoading.value = true;
      final response = await _authProvider.login({
        'email': email.value,
        'password': password.value,
      });

      if (response.status.isOk) {
        Get.snackbar(
          'Success',
          'Logged in successfully!',
          backgroundColor: const Color(0xFF22C55E).withOpacity(0.1),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Save token and navigate
        final data = response.body['data'];
        final token =
            response.body['token'] ??
            response.body['access_token'] ??
            (data is Map ? data['token'] : null);

        if (token != null) {
          debugPrint('🔑 Login Token: $token');
          storage.write('token', token);
          if (data is Map && data['user'] != null) {
            storage.write('user', data['user']);
            final role = data['user']['role'];
            print('User logged in with role: $role');
          }
          Get.offAllNamed('/home');
        } else {
          Get.offAllNamed('/home');
        }
      } else {
        String message = response.body?['message'] ?? 'Login failed';
        Get.snackbar(
          'Login Failed',
          message,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle(String role) async {
    try {
      isLoading.value = true;
      
      // Clear previous session for a fresh start
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        return; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 🔥 Create Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 🔥 Sign in to Firebase
      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);

      // 🔥 Get the Firebase ID Token (this is what your backend expects)
      final String? firebaseToken = await userCredential.user?.getIdToken();

      if (firebaseToken == null) {
        debugPrint('❌ Firebase ID Token is null');
        Get.snackbar('Error', 'Could not get Firebase ID Token');
        return;
      }

      debugPrint('📩 Sending Firebase Token: $firebaseToken');

      final response = await _authProvider.googleLogin({
        'token': firebaseToken,
        'role': role,
      });

      if (response.status.isOk) {
        final data = response.body['data'];
        final token =
            response.body['token'] ??
            response.body['access_token'] ??
            (data is Map ? data['token'] : null);

        if (token != null) {
          debugPrint('🔑 Backend Token: $token');
          storage.write('token', token);
          if (data is Map && data['user'] != null) {
            storage.write('user', data['user']);
          }
          Get.offAllNamed('/home');
        } else {
          Get.offAllNamed('/home');
        }
      } else {
        String message = response.body?['message'] ?? 'Google Login failed';
        Get.snackbar('Login Failed', message);
      }
    } catch (e) {
      print('Google Login Error: $e');
      Get.snackbar('Error', 'Google Sign-In failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithFacebook() async {
    try {
      isLoading.value = true;
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        debugPrint("FB TOKEN: ${accessToken.token}");

        final response = await _authProvider.facebookLogin({
          "token": accessToken.token,
          "role": "founder", // or investor, defaulting to founder as per request
        });

        if (response.status.isOk) {
          final data = response.body['data'];
          final token =
              response.body['token'] ??
              response.body['access_token'] ??
              (data is Map ? data['token'] : null);

          if (token != null) {
            debugPrint('🔑 Backend Token: $token');
            storage.write('token', token);
            if (data is Map && data['user'] != null) {
              storage.write('user', data['user']);
            }
            Get.offAllNamed('/home');
          } else {
            Get.offAllNamed('/home');
          }
        } else {
          String message = response.body?['message'] ?? 'Facebook Login failed';
          Get.snackbar('Login Failed', message);
        }
      } else {
        debugPrint("Login failed: ${result.message}");
        if (result.status != LoginStatus.cancelled) {
          Get.snackbar('Login Failed', result.message ?? 'Unknown error');
        }
      }
    } catch (e) {
      debugPrint("Facebook Login Error: $e");
      Get.snackbar('Error', 'Facebook Sign-In failed');
    } finally {
      isLoading.value = false;
    }
  }
}
