import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/subscriptions_controller.dart';

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
      body: Obx(() {
        if (controller.userRole.value == 'founder') {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rocket_launch_outlined, color: neonGreen.withValues(alpha: 0.5), size: 80),
                const SizedBox(height: 24),
                const Text(
                  'Coming Soon',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Founder subscription plans are in development.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                ),
              ],
            ),
          );
        }

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: neonGreen),
          );
        }

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
                      colors: [neonGreen.withValues(alpha: 0.15), Colors.transparent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                        child: const Icon(Icons.star, color: neonGreen, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Plan',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                          ),
                          Text(
                            controller.currentPlan.value.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              const Text(
                'Available Plans',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a plan to upgrade your account',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              
              if (controller.plans.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text('No other plans available', style: TextStyle(color: Colors.white.withValues(alpha: 0.3))),
                ),

              ...controller.plans.map((plan) {
                final isPro = plan.name.toLowerCase() == 'pro';
                final isElite = plan.name.toLowerCase() == 'elite';
                final isFree = plan.name.toLowerCase() == 'free';

                IconData icon;
                Color iconColor;
                Color iconBg;
                String subtitle;
                String buttonText;

                if (isFree) {
                  icon = Icons.star_border;
                  iconColor = neonGreen;
                  iconBg = Colors.white.withValues(alpha: 0.05);
                  subtitle = 'Perfect for exploring deals';
                  buttonText = 'Get Started';
                } else if (isPro) {
                  icon = Icons.bolt;
                  iconColor = Colors.black;
                  iconBg = neonGreen;
                  subtitle = 'Most popular for investors';
                  buttonText = 'Upgrade Now';
                } else {
                  icon = Icons.workspace_premium_outlined;
                  iconColor = const Color(0xFFFBBF24);
                  iconBg = Colors.white.withValues(alpha: 0.05);
                  subtitle = isElite ? 'For serious investors' : 'Exclusive access';
                  buttonText = 'Upgrade Now';
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _buildPlanCard(
                    planId: plan.id,
                    onSubscribe: () => controller.subscribe(plan),
                    title: plan.name.capitalizeFirst ?? plan.name,
                    subtitle: subtitle,
                    price: plan.price.toInt().toString(),
                    period: plan.price == 0 ? '/forever' : '/month',
                    icon: icon,
                    iconBg: iconBg,
                    iconColor: iconColor,
                    features: plan.features,
                    buttonText: buttonText,
                    isPopular: isPro,
                    neonGreen: neonGreen,
                    cardColor: cardColor,
                  ),
                );
              }),

              const SizedBox(height: 8),
              Text(
                'All plans include secure payments and can be cancelled anytime',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPlanCard({
    required String planId,
    required VoidCallback onSubscribe,
    required String title,
    required String subtitle,
    required String price,
    required String period,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required List<String> features,
    required String buttonText,
    required bool isPopular,
    required Color neonGreen,
    required Color cardColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isPopular ? neonGreen.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05),
              width: isPopular ? 2 : 1,
            ),
            boxShadow: isPopular ? [
              BoxShadow(
                color: neonGreen.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ] : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$$price',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 4),
                    child: Text(
                      period,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: isPopular ? neonGreen : neonGreen.withValues(alpha: 0.5),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: onSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPopular ? neonGreen : Colors.white.withValues(alpha: 0.05),
                    foregroundColor: isPopular ? Colors.black : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isPopular)
          Positioned(
            top: -12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: neonGreen,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: neonGreen.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'Most Popular',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
