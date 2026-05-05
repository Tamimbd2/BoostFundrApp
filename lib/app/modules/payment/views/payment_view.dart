import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_controller.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF22C55E);
    const darkBg = Color(0xFF050505);
    const cardColor = Color(0xFF111827);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
              controller.paymentUrl.value.isNotEmpty
                  ? 'Secure Payment'
                  : 'Choose Payment Method',
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            )),
        centerTitle: true,
      ),
      body: Obx(() {
        // ── Step 1: Loading payment methods ──────────────────────
        if (controller.isLoadingMethods.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: neonGreen),
                SizedBox(height: 16),
                Text('Loading payment methods...',
                    style: TextStyle(color: Colors.white54, fontSize: 13)),
              ],
            ),
          );
        }

        // ── Step 2: Creating payment (after method selected) ──────
        if (controller.isProcessing.value && controller.paymentUrl.value.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: neonGreen),
                SizedBox(height: 16),
                Text('Initiating payment...', style: TextStyle(color: Colors.white54)),
              ],
            ),
          );
        }

        // ── Step 3: WebView for payment ───────────────────────────
        if (controller.paymentUrl.value.isNotEmpty) {
          return Stack(
            children: [
              InAppWebView(
                initialUrlRequest:
                    URLRequest(url: WebUri(controller.paymentUrl.value)),
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
                  debugPrint('WebView loading: $url');
                },
                onLoadStop: (webController, url) {
                  if (url != null) {
                    final urlString = url.toString();
                    if (urlString.contains('/success') ||
                        urlString.contains('success=true')) {
                      controller.showSuccessDialog();
                    } else if (urlString.contains('/cancel') ||
                        urlString.contains('/fail') ||
                        urlString.contains('error=')) {
                      Get.back();
                      Get.snackbar(
                          'Payment Cancelled', 'The payment process was cancelled.',
                          backgroundColor: Colors.orangeAccent.withValues(alpha: 0.1),
                          colorText: Colors.white);
                    }
                  }
                },
                onReceivedError: (webController, request, error) {
                  debugPrint('WebView Error: ${error.description}');
                },
              ),
              Obx(() => controller.isProcessing.value
                  ? const Center(child: CircularProgressIndicator(color: neonGreen))
                  : const SizedBox.shrink()),
            ],
          );
        }

        // ── Step 0: Method selection UI ───────────────────────────
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plan Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: neonGreen.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: neonGreen.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.workspace_premium, color: neonGreen, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${controller.planName.value.capitalizeFirst} Plan',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Obx(() => Text(
                                '\$${controller.planPrice.value}/month',
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Select Payment Method',
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Error message if any
              if (controller.errorMessage.value.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Payment Method Cards
              ...controller.paymentMethods.map((method) {
                return Obx(() {
                  final isSelected =
                      controller.selectedMethod.value?.paymentMethodId ==
                          method.paymentMethodId;
                  return GestureDetector(
                    onTap: () => controller.selectedMethod.value = method,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? neonGreen.withValues(alpha: 0.08)
                            : cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? neonGreen
                              : Colors.white.withValues(alpha: 0.06),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Method Icon
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: method.paymentMethodImageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      method.paymentMethodImageUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(method, isSelected),
                                    ),
                                  )
                                : _buildFallbackIcon(method, isSelected),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              method.paymentMethodEn,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          // Radio indicator
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? neonGreen : Colors.white24,
                                width: 2,
                              ),
                              color: isSelected
                                  ? neonGreen.withValues(alpha: 0.2)
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(Icons.check,
                                        color: neonGreen, size: 14))
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }),

              const SizedBox(height: 32),

              // Pay Button
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.selectedMethod.value == null
                          ? null
                          : () => controller.processPayment(
                              methodId:
                                  controller.selectedMethod.value!.paymentMethodId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: neonGreen,
                        disabledBackgroundColor: neonGreen.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock, color: Colors.black, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Pay \$${controller.planPrice.value}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline,
                        color: Colors.white.withValues(alpha: 0.3), size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Secured by MyFatoorah',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFallbackIcon(PaymentMethod method, bool isSelected) {
    const neonGreen = Color(0xFF22C55E);
    
    IconData iconData;
    switch (method.paymentMethodId) {
      case 6:
        iconData = Icons.credit_card;
        break;
      case 9:
        iconData = Icons.apple;
        break;
      case 16:
        iconData = Icons.account_balance_wallet; // Google Pay fallback icon
        break;
      default:
        iconData = Icons.payment;
    }

    return Icon(
      iconData,
      color: isSelected ? neonGreen : Colors.white.withValues(alpha: 0.5),
      size: 26,
    );
  }
}
