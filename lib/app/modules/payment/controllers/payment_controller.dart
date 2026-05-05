import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../routes/app_pages.dart';

class MyInAppBrowser extends InAppBrowser {
  final Function(String) onPageFinished;
  
  MyInAppBrowser({required this.onPageFinished});

  @override
  Future onBrowserCreated() async {
    debugPrint("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    debugPrint("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    debugPrint("Stopped $url");
    if (url != null) {
      onPageFinished(url.toString());
    }
  }

  @override
  void onExit() {
    debugPrint("Browser closed!");
  }
}

class PaymentController extends GetxController {
  final storage = GetStorage();
  final planId = ''.obs;
  final planName = 'pro'.obs;
  final planPrice = '49'.obs;
  
  final isProcessing = true.obs;
  final paymentUrl = ''.obs;
  
  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      planId.value = args['planId'] ?? '';
      planName.value = args['planName']?.toString().toLowerCase() ?? 'pro';
      planPrice.value = args['planPrice'] ?? '49';
    }
    
    // Automatically start payment process
    processPayment();
  }

  Future<void> processPayment() async {
    try {
      isProcessing.value = true;
      final token = storage.read('token');
      
      final response = await GetConnect().post(
        'https://boost-funder.onrender.com/api/v1/payments/create',
        {
          'planName': planName.value,
        },
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
      );

      debugPrint('Payment API Response: ${response.body}');
      if (response.status.isOk && response.body != null && response.body['success'] == true) {
        final data = response.body['data'];
        String? url;
        
        if (data is String) {
          url = data;
        } else if (data is Map) {
          url = data['url']?.toString() ?? 
                data['payment_url']?.toString() ?? 
                data['paymentUrl']?.toString();
        }

        if (url != null && url.isNotEmpty) {
          debugPrint('Extracted Payment URL: $url');
          paymentUrl.value = url;
        } else {
          throw 'Payment URL not found in response data: $data';
        }
      } else {
        final errorMsg = response.body?['message'] ?? 'Failed to initiate payment';
        Get.snackbar('Error', errorMsg,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Error initiating payment: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.',
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.white);
    } finally {
      isProcessing.value = false;
    }
  }

  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 60),
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment Successful!',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Your ${planName.value.capitalizeFirst} subscription is now active.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    // Use offAllNamed to trigger a full reload of the app state and go to home
                    Get.offAllNamed(Routes.HOME); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Go to Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
