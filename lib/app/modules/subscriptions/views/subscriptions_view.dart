import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../controllers/subscriptions_controller.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final clean = newValue.text.replaceAll(',', '').replaceAll(' ', '');
    final intValue = int.tryParse(clean);
    if (intValue == null) return oldValue;
    final formatted = intValue.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class SubscriptionsView extends GetView<SubscriptionsController> {
  const SubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF22C55E);
    const darkBg = Color(0xFF050505);
    const cardColor = Color(0xFF111827);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Subscription',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.6),
            radius: 1.5,
            colors: [
              Color(0xFF0D2818), // Rich deep emerald glow
              Color(0xFF050B08), // Midnight pitch black
              Color(0xFF030504), 
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: neonGreen),
            );
          }

          final isFounder = controller.userRole.value == 'founder';

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 10),
                
                // Current Plan Header
                if (controller.currentPlan.value.isNotEmpty)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 32),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [neonGreen.withValues(alpha: 0.2), Colors.transparent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: neonGreen.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: neonGreen.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.star, color: neonGreen, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isFounder ? 'Current Package' : 'Current Plan',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.currentPlan.value.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                Text(
                  isFounder ? 'Founder Packages' : 'Available Plans',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isFounder ? 'Boost your startup with premium exposure' : 'Choose a plan to upgrade your account',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 36),
                
                if (isFounder) ...[
                  // Premium Glassmorphic Goal Estimator Container
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 32),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF132A1C).withValues(alpha: 0.8),
                          const Color(0xFF09140D).withValues(alpha: 0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: neonGreen.withValues(alpha: 0.5), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: neonGreen.withValues(alpha: 0.15),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: neonGreen.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.calculate_outlined, color: neonGreen, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'TEST FUNDING GOAL',
                              style: TextStyle(
                                color: neonGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'AED',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: TextField(
                                  controller: controller.fundingGoalController,
                                  onChanged: controller.onFundingGoalChanged,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyInputFormatter(),
                                  ],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '1,000,000',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Icon(Icons.edit_note, color: Colors.white.withValues(alpha: 0.2), size: 24),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.white.withValues(alpha: 0.4), size: 14),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Enter target raise to instantly preview estimated fees',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                if (controller.plans.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(isFounder ? 'No packages available' : 'No other plans available', style: TextStyle(color: Colors.white.withValues(alpha: 0.3))),
                  ),

                ...(() {
                  final currentFees = controller.calculatedFeeNumbers;
                  return controller.plans.map((plan) {
                    final nameLower = plan.name.toLowerCase();
                    final isFree = nameLower == 'free' || plan.price == 0;
                    final isPopular = nameLower == 'pro' || nameLower == 'growth' || nameLower == 'popular' || nameLower == 'standard' || nameLower == 'gold' || plan.price == 49 || plan.price == 99;

                    final isCurrent = controller.currentPlan.value.toLowerCase() == nameLower || (controller.currentPlan.value.isEmpty && isFree);

                    String badge = plan.badge;
                    String subtitle = plan.subtitle;
                    String description = plan.description;
                    String approvalTime = plan.approvalTime;

                    String priceDisplay;
                    String periodDisplay;
                    String buttonText;

                    if (isFounder) {
                      final feeVal = plan.successFee == plan.successFee.roundToDouble() 
                          ? plan.successFee.toInt().toString()
                          : plan.successFee.toString();
                      priceDisplay = '$feeVal%';
                      periodDisplay = '/ SUCCESS FEE';
                      buttonText = isCurrent ? 'SELECTED PACKAGE' : 'SELECT ${badge.isEmpty ? plan.name.toUpperCase() : badge.toUpperCase()} >';
                    } else {
                      priceDisplay = 'AED ${plan.price.toInt()}';
                      periodDisplay = plan.price == 0 ? '/forever' : '/month';
                      if (isFree) {
                        buttonText = 'Get Started';
                      } else {
                        buttonText = 'Upgrade Now';
                      }
                    }

                    final targetFeeNumber = currentFees[plan.id] ?? 0.0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _buildPlanCard(
                        planId: plan.id,
                        onSubscribe: (isCurrent && !isFounder) ? () {} : () => controller.subscribe(plan),
                        title: isFounder ? (badge.isNotEmpty ? badge : plan.name) : plan.name.capitalizeFirst ?? plan.name,
                        subtitle: subtitle,
                        description: description,
                        price: priceDisplay,
                        period: periodDisplay,
                        approvalTime: isFounder && !isFree && approvalTime.isNotEmpty ? approvalTime : '',
                        badge: isFounder ? badge : '',
                        targetFeeNumber: targetFeeNumber,
                        features: plan.features,
                        buttonText: buttonText,
                        isPopular: isPopular,
                        isFounder: isFounder,
                        neonGreen: neonGreen,
                        cardColor: cardColor,
                      ),
                    );
                  });
                })(),

                const SizedBox(height: 12),
                Text(
                  'All plans include secure payments and can be cancelled anytime',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPlanCard({
    required String planId,
    required VoidCallback onSubscribe,
    required String title,
    required String subtitle,
    required String description,
    required String price,
    required String period,
    required String approvalTime,
    required String badge,
    required double targetFeeNumber,
    required List<String> features,
    required String buttonText,
    required bool isPopular,
    required bool isFounder,
    required Color neonGreen,
    required Color cardColor,
  }) {
    final isSelected = buttonText.contains('SELECTED');
    final hasFee = targetFeeNumber > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected ? [
            const Color(0xFF162A1D),
            const Color(0xFF0C1610),
          ] : [
            const Color(0xFF131A16),
            const Color(0xFF080D0A),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isSelected ? neonGreen : (isPopular ? neonGreen.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.08)),
          width: isSelected || isPopular ? 2 : 1,
        ),
        boxShadow: isSelected || isPopular ? [
          BoxShadow(
            color: neonGreen.withValues(alpha: isSelected ? 0.25 : 0.15),
            blurRadius: 28,
            spreadRadius: 3,
          )
        ] : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: neonGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: neonGreen.withValues(alpha: 0.2)),
                ),
                child: Icon(isFounder ? Icons.rocket_launch : Icons.bolt, color: neonGreen, size: 20),
              ),
              if (badge.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: neonGreen,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: neonGreen.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Text(
                    badge.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 22),

          // Title
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          if (subtitle.isNotEmpty)
            Text(
              subtitle.toUpperCase(),
              style: TextStyle(
                color: isFounder ? neonGreen : Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          
          // Description
          if (description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Fee / Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                period,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),

          // Calculated Total Fees Container
          if (isFounder) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    neonGreen.withValues(alpha: 0.18),
                    neonGreen.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: neonGreen.withValues(alpha: 0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: neonGreen.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.monetization_on_outlined, color: neonGreen, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'TOTAL FEES :',
                        style: TextStyle(
                          color: neonGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: targetFeeNumber),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Text(
                        'AED ${controller.formatNumber(value)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],

          // Approval Time Pill
          if (approvalTime.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule, color: Colors.white.withValues(alpha: 0.5), size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Approval: $approvalTime',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Action Button (Visible only when fee calculated or selected)
          if (!isFounder || hasFee || isSelected)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                boxShadow: hasFee ? [
                  BoxShadow(
                    color: neonGreen.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ] : [],
              ),
              child: ElevatedButton(
                onPressed: onSubscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasFee 
                      ? neonGreen 
                      : (isSelected ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.05)),
                  foregroundColor: hasFee 
                      ? Colors.black 
                      : (isSelected ? Colors.white.withValues(alpha: 0.4) : Colors.white),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  side: isSelected && !hasFee ? BorderSide(color: Colors.white.withValues(alpha: 0.1)) : BorderSide.none,
                ),
                child: Text(
                  isFounder && hasFee 
                      ? (isSelected ? 'PAY SELECTED PACKAGE (AED ${controller.formatNumber(targetFeeNumber)})' : 'SELECT & PAY AED ${controller.formatNumber(targetFeeNumber)}')
                      : buttonText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 28),

          // Key Benefits Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.12))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'KEY BENEFITS',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.12))),
            ],
          ),
          const SizedBox(height: 20),

          // Features List
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: neonGreen,
                  size: 18,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
