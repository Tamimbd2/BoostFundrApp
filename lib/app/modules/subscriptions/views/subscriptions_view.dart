import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/subscriptions_controller.dart';

class SubscriptionsView extends GetView<SubscriptionsController> {
  const SubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF00FF88);
    const darkBg = Color(0xFF050505);
    const cardColor = Color(0xFF111827);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Choose Your Plan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Unlock exclusive startup deals and investment\nopportunities',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            
            // FREE PLAN
            _buildPlanCard(
              title: 'Free',
              subtitle: 'Perfect for exploring deals',
              price: '0',
              period: '/forever',
              icon: Icons.star_border,
              iconBg: Colors.white.withOpacity(0.05),
              iconColor: neonGreen,
              features: [
                'Browse 50+ startup deals',
                'Basic deal information',
                'Save up to 5 deals',
                'Community access',
                'Email notifications',
              ],
              buttonText: 'Get Started',
              isPopular: false,
              neonGreen: neonGreen,
              cardColor: cardColor,
            ),
            
            const SizedBox(height: 24),

            // PRO PLAN
            _buildPlanCard(
              title: 'Pro',
              subtitle: 'Most popular for investors',
              price: '49',
              period: '/month',
              icon: Icons.bolt,
              iconBg: neonGreen,
              iconColor: Colors.black,
              features: [
                'Unlimited deal browsing',
                'Full deal details access',
                'Unlimited saved deals',
                'Priority support',
                'Advanced analytics',
                'Direct founder messaging',
                'Early deal access',
                'Investment tracking',
              ],
              buttonText: 'Upgrade Now',
              isPopular: true,
              neonGreen: neonGreen,
              cardColor: cardColor,
            ),
            
            const SizedBox(height: 24),

            // ELITE PLAN
            _buildPlanCard(
              title: 'Elite',
              subtitle: 'For serious investors',
              price: '199',
              period: '/month',
              icon: Icons.workspace_premium_outlined,
              iconBg: Colors.white.withOpacity(0.05),
              iconColor: const Color(0xFFFBBF24),
              features: [
                'Everything in Pro',
                'Exclusive deal flow',
                'Dedicated account manager',
                'Custom due diligence reports',
                'Portfolio management tools',
                'API access',
                'White-glove onboarding',
                'Quarterly strategy calls',
              ],
              buttonText: 'Upgrade Now',
              isPopular: false,
              neonGreen: neonGreen,
              cardColor: cardColor,
            ),

            const SizedBox(height: 32),
            Text(
              'All plans include secure payments and can be cancelled anytime',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
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
              color: isPopular ? neonGreen.withOpacity(0.5) : Colors.white.withOpacity(0.05),
              width: isPopular ? 2 : 1,
            ),
            boxShadow: isPopular ? [
              BoxShadow(
                color: neonGreen.withOpacity(0.1),
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
                          color: Colors.white.withOpacity(0.5),
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
                        color: Colors.white.withOpacity(0.4),
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
                      color: isPopular ? neonGreen : neonGreen.withOpacity(0.5),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to handle subscription
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPopular ? neonGreen : Colors.white.withOpacity(0.05),
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
                      color: neonGreen.withOpacity(0.4),
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
