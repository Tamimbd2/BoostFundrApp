import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../routes/app_pages.dart';

class PaymentMethod {
  final int paymentMethodId;
  final String paymentMethodEn;
  final String paymentMethodAr;
  final String paymentMethodImageUrl;

  PaymentMethod({
    required this.paymentMethodId,
    required this.paymentMethodEn,
    required this.paymentMethodAr,
    required this.paymentMethodImageUrl,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      paymentMethodId: (json['PaymentMethodId'] ?? json['paymentMethodId'] ?? 0) as int,
      paymentMethodEn: json['PaymentMethodEn'] ?? json['paymentMethodEn'] ?? '',
      paymentMethodAr: json['PaymentMethodAr'] ?? json['paymentMethodAr'] ?? '',
      paymentMethodImageUrl: json['ImageUrl'] ?? json['imageUrl'] ?? '',
    );
  }
}

class PaymentController extends GetxController {
  final storage = GetStorage();
  final planId = ''.obs;
  final planName = 'pro'.obs;
  final planPrice = '49'.obs;

  final isProcessing = true.obs;
  final isLoadingMethods = true.obs;
  final paymentUrl = ''.obs;
  final paymentMethods = <PaymentMethod>[].obs;
  final selectedMethod = Rxn<PaymentMethod>();
  final errorMessage = ''.obs;

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

    fetchPaymentMethods();
  }

  Future<void> fetchPaymentMethods() async {
    try {
      isLoadingMethods.value = true;
      errorMessage.value = '';
      final token = storage.read('token');

      final response = await GetConnect().get(
        'https://boost-funder.onrender.com/api/v1/payments/methods',
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
      );

      debugPrint('Payment Methods Response: ${response.body}');

      List<PaymentMethod> fetchedMethods = [];

      if (response.status.isOk && response.body != null) {
        final data = response.body['data'];
        List<dynamic> methodsList = [];

        if (data is List) {
          methodsList = data;
        } else if (data is Map) {
          methodsList = data['paymentMethods'] ?? data['PaymentMethods'] ?? data['methods'] ?? [];
        }

        if (methodsList.isNotEmpty) {
          fetchedMethods = methodsList
              .map((m) => PaymentMethod.fromJson(m as Map<String, dynamic>))
              .toList();
        }
      }

      // Filter or define the specific 3 methods requested
      final List<PaymentMethod> requiredMethods = [
        PaymentMethod(
          paymentMethodId: 6,
          paymentMethodEn: 'Debit/Credit Cards',
          paymentMethodAr: 'بطاقة ائتمان / سحب',
          paymentMethodImageUrl: '', // Will use icon fallback in view
        ),
        PaymentMethod(
          paymentMethodId: 9,
          paymentMethodEn: 'Apple Pay',
          paymentMethodAr: 'أبل باي',
          paymentMethodImageUrl: '', // Will use icon fallback in view
        ),
        PaymentMethod(
          paymentMethodId: 16,
          paymentMethodEn: 'Google Pay',
          paymentMethodAr: 'جوجل باي',
          paymentMethodImageUrl: '', // Will use icon fallback in view
        ),
      ];

      // If API returned these methods, use their data (like images)
      // otherwise keep the hardcoded ones
      paymentMethods.value = requiredMethods.map((req) {
        final apiMatch = fetchedMethods.firstWhereOrNull(
          (m) => m.paymentMethodId == req.paymentMethodId,
        );
        return apiMatch ?? req;
      }).toList();

    } catch (e) {
      debugPrint('Error fetching payment methods: $e');
      // Fallback to the 3 required methods
      paymentMethods.value = [
        PaymentMethod(
          paymentMethodId: 6,
          paymentMethodEn: 'Debit/Credit Cards',
          paymentMethodAr: 'بطاقة ائتمان / سحب',
          paymentMethodImageUrl: '',
        ),
        PaymentMethod(
          paymentMethodId: 9,
          paymentMethodEn: 'Apple Pay',
          paymentMethodAr: 'أبل باي',
          paymentMethodImageUrl: '',
        ),
        PaymentMethod(
          paymentMethodId: 16,
          paymentMethodEn: 'Google Pay',
          paymentMethodAr: 'جوجل باي',
          paymentMethodImageUrl: '',
        ),
      ];
    } finally {
      isLoadingMethods.value = false;
      isProcessing.value = false;
    }
  }

  Future<void> processPayment({int? methodId}) async {
    final id = methodId ?? selectedMethod.value?.paymentMethodId;
    if (id == null) {
      Get.snackbar('Error', 'Please select a payment method',
          backgroundColor: Colors.redAccent.withValues(alpha: 0.1), colorText: Colors.white);
      return;
    }

    try {
      isProcessing.value = true;
      paymentUrl.value = '';
      errorMessage.value = '';
      final token = storage.read('token');

      final response = await GetConnect().post(
        'https://boost-funder.onrender.com/api/v1/payments/create',
        {
          'planName': planName.value,
          'paymentMethodId': id,
        },
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
      );

      debugPrint('Payment Create Response: ${response.body}');

      if (response.status.isOk &&
          response.body != null &&
          response.body['success'] == true) {
        final data = response.body['data'];
        String? url;

        if (data is String) {
          url = data;
        } else if (data is Map) {
          url = data['url']?.toString() ??
              data['payment_url']?.toString() ??
              data['paymentUrl']?.toString() ??
              data['PaymentURL']?.toString() ??
              data['InvoiceURL']?.toString();
        }

        if (url != null && url.isNotEmpty) {
          debugPrint('Payment URL: $url');
          paymentUrl.value = url;
        } else {
          errorMessage.value = 'Payment URL not found in response.';
        }
      } else {
        final msg = response.body?['message'] ?? 'Failed to initiate payment';
        errorMessage.value = msg;
        Get.snackbar('Payment Error', msg,
            backgroundColor: Colors.redAccent.withValues(alpha: 0.1), colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Error creating payment: $e');
      errorMessage.value = 'Something went wrong. Please try again.';
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
                  color: const Color(0xFF22C55E).withValues(alpha: 0.1),
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
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.offAllNamed(Routes.HOME);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Go to Dashboard',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
