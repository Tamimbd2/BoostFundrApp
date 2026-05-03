import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_controller.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF22C55E);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          controller.isProcessing.value ? 'Initiating Payment...' : 'Secure Payment',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        )),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isProcessing.value && controller.paymentUrl.value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: neonGreen),
          );
        }

        if (controller.paymentUrl.value.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                const SizedBox(height: 16),
                const Text('Failed to load payment portal', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.processPayment(),
                  style: ElevatedButton.styleFrom(backgroundColor: neonGreen.withOpacity(0.1), foregroundColor: neonGreen),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(controller.paymentUrl.value)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useWideViewPort: true,
                loadWithOverviewMode: true,
                transparentBackground: true,
              ),
              onWebViewCreated: (webController) {
                controller.webViewController = webController;
              },
              onLoadStart: (webController, url) {
                debugPrint('WebView started loading: $url');
              },
              onLoadStop: (webController, url) {
                debugPrint('WebView stopped loading: $url');
                if (url != null) {
                  final urlString = url.toString();
                  if (urlString.contains('/success')) {
                    controller.showSuccessDialog();
                  } else if (urlString.contains('/cancel') || urlString.contains('/fail')) {
                    Get.back();
                    Get.snackbar('Payment Cancelled', 'The payment process was cancelled.',
                        backgroundColor: Colors.orangeAccent.withOpacity(0.1),
                        colorText: Colors.white);
                  }
                }
              },
              onReceivedError: (webController, request, error) {
                debugPrint('WebView Error: ${error.description}');
              },
              onReceivedHttpError: (webController, request, response) {
                debugPrint('WebView HTTP Error: ${response.statusCode}');
              },
            ),
            Obx(() => controller.isProcessing.value 
              ? const Center(child: CircularProgressIndicator(color: neonGreen))
              : const SizedBox.shrink()
            ),
          ],
        );
      }),
    );
  }
}
