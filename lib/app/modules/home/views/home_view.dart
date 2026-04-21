import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/deal_model.dart';
import '../../../routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildCreateCampaignButton(),
                    const SizedBox(height: 32),
                    _buildSectionHeader('Progress Overview'),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(color: Color(0xFF22C55E)),
                        );
                      }
                      if (controller.deals.isEmpty) {
                        return Center(
                          child: Text(
                            'No campaigns yet',
                            style: TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.deals.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return _buildCampaignCard(controller.deals[index]);
                        },
                      );
                    }),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          Icon(Icons.menu, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Hi, Mohammed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('👋', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Founder Dashboard',
                  style: TextStyle(
                    color: const Color(0xFF22C55E),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Icon(Icons.notifications_none_outlined, color: Colors.white, size: 28),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.withOpacity(0.2),
            backgroundImage: const NetworkImage(
              'https://ui-avatars.com/api/?name=Mohammed+A&background=random',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateCampaignButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.CREATE_CAMPAIGN),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF22C55E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
            const SizedBox(width: 8),
            const Text(
              'Create New Campaign',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'View All',
          style: TextStyle(
            color: const Color(0xFF22C55E),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignCard(DealModel deal) {
    // Generate some dummy progress for visualization since API doesn't provide it yet
    final raised = 82000 + (deal.startupName.hashCode % 10000);
    final goal = 100000;
    final progress = raised / goal;
    final daysLeft = 12 + (deal.startupName.hashCode % 10);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E1E1E)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  deal.imageUrl ?? 'https://via.placeholder.com/150',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[900],
                    child: const Icon(Icons.business, color: Colors.white24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          deal.startupName ?? 'Unnamed Startup',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.more_vert, color: Colors.white.withOpacity(0.3), size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          deal.category ?? 'Startup',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'AED ',
                                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11),
                              ),
                              TextSpan(
                                text: '${raised.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '  /  ${goal ~/ 1000}k',
                                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: (daysLeft > 15 ? Colors.redAccent : const Color(0xFFB45309)).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: daysLeft > 15 ? Colors.redAccent : const Color(0xFFFBBF24),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$daysLeft Days Left',
                                style: TextStyle(
                                  color: daysLeft > 15 ? Colors.redAccent : const Color(0xFFFBBF24),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Color(0xFF1E1E1E), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_filled, 'Home', isActive: true),
          _buildNavItem(Icons.campaign_outlined, 'Campaigns'),
          _buildNavItem(Icons.people_outline, 'Investors'),
          _buildNavItem(Icons.account_balance_wallet_outlined, 'Wallet'),
          _buildNavItem(Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF22C55E) : Colors.white.withOpacity(0.4),
          size: 26,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF22C55E) : Colors.white.withOpacity(0.4),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
