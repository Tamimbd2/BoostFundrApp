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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Obx(
                      () => controller.userRole.value == 'investor'
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                _buildCreateCampaignButton(),
                                const SizedBox(height: 32),
                              ],
                            ),
                    ),
                    _buildSectionHeader('progress_overview'.tr),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(
                              color: Color(0xFF00FF88),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }
                      if (controller.deals.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'no_campaigns'.tr,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: controller.deals
                            .map((deal) => _buildCampaignCard(deal))
                            .toList(),
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

  // ─── Header ───────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Obx(
                      () => Flexible(
                        child: Text(
                          'hi'.tr + ' ${controller.userName.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Obx(
                      () => controller.isVerified.value
                          ? const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.verified,
                                color: Color(0xFF22C55E),
                                size: 18,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const Text('👋', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    controller.userRole.value == 'investor'
                        ? 'Investor Dashboard'
                        : 'Founder Dashboard',
                    style: const TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.PROFILE),
            child: Obx(
              () => Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF22C55E),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  backgroundImage: controller.profileImage.value.isNotEmpty
                      ? NetworkImage(controller.profileImage.value)
                      : NetworkImage(
                          'https://ui-avatars.com/api/?name=${controller.userName.value}&background=random',
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Create Deal Button ───────────────────────────────
  Widget _buildCreateCampaignButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.CREATE_CAMPAIGN),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF22C55E),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF22C55E).withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Create New Deal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Section Header ───────────────────────────────────
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
        const Text(
          'View All',
          style: TextStyle(
            color: Color(0xFF22C55E),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignCard(DealModel deal) {
    final raised = (deal.raisedAmount ?? 0).toInt();
    final goal = (deal.raisedGoal ?? 100000).toInt();
    final progress = goal > 0
        ? ((deal.raisedProgress ?? 0) / 100).clamp(0.0, 1.0)
        : 0.0;

    // profileCompletionScore badge (vibrant colors)
    final profileScore = (deal.profileCompletionScore ?? 0).clamp(0, 100);
    final Color scoreColor = profileScore >= 80
        ? const Color(0xFF00FF55) // Neon Green
        : profileScore >= 40
        ? const Color(0xFFFFB020) // Vibrant Yellow/Orange
        : const Color(0xFFFF5252); // Neon Red

    String fmt(int n) => n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );

    int daysLeft = 0;
    if (deal.deadline != null) {
      final deadlineDate = DateTime.tryParse(deal.deadline!);
      if (deadlineDate != null) {
        daysLeft = deadlineDate.difference(DateTime.now()).inDays;
      }
    }
    if (daysLeft <= 0 && deal.deadline != null) {
      // Fallback or show 0
      daysLeft = 0;
    } else if (deal.deadline == null) {
      // Dummy if no deadline
      daysLeft = 12 + ((deal.id ?? '').hashCode.abs() % 10);
    }

    final Color timeColor = daysLeft <= 12
        ? const Color(0xFFFFB020) // Yellow for <= 12 days
        : daysLeft > 30
        ? const Color(0xFF00FF55) // Green for > 30 days
        : const Color(0xFFFF5252); // Red otherwise

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.CARD_DETAILS, arguments: deal.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF161616), // Dark background matching screenshot
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                deal.imageUrl ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2333),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.image,
                    color: Colors.white24,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Right Side: Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Menu Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                deal.startupName ?? 'Unnamed',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (deal.isVerified == true) ...[
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified,
                                color: Color(0xFF22C55E),
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (controller.userRole.value == 'investor' ||
                          deal.founderId == controller.currentUserId.value)
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.white54,
                            size: 20,
                          ),
                          color: const Color(0xFF1C1C1E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              Get.toNamed(
                                Routes.CREATE_CAMPAIGN,
                                arguments: deal.id,
                              );
                            } else if (value == 'bookmark') {
                              controller.toggleBookmark(deal);
                            }
                          },
                          itemBuilder: (context) {
                            final List<PopupMenuEntry<String>> items = [];

                            if (controller.userRole.value == 'investor') {
                              items.add(
                                PopupMenuItem(
                                  value: 'bookmark',
                                  child: Row(
                                    children: [
                                      Icon(
                                        deal.isBookmarked == true
                                            ? Icons.bookmark
                                            : Icons.bookmark_border_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        deal.isBookmarked == true
                                            ? 'Unsave Deal'
                                            : 'Save Deal',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (controller.userRole.value == 'founder' &&
                                deal.founderId ==
                                    controller.currentUserId.value) {
                              items.addAll([
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.edit_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Edit Deal',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.redAccent.withOpacity(
                                            0.9,
                                          ),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]);
                            }

                            return items;
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A3B2A), // Dark green background
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      deal.category ?? 'Startup',
                      style: const TextStyle(
                        color: Color(0xFF34D399),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Amount
                  Text(
                    'AED ${fmt(raised)} / ${fmt(goal)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500, // Thinner amount text
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(
                        0xFF2C2C2E,
                      ), // Darker unfilled background
                      color: scoreColor,
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Days Left Badge (aligned to right)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: timeColor, width: 1.5),
                      ),
                      child: Text(
                        '${daysLeft} ' + 'days_left'.tr,
                        style: TextStyle(
                          color: timeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Bottom Navigation ────────────────────────────────
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
          _buildNavItem(Icons.home_filled, 'home'.tr, isActive: true),
          Obx(() {
            final isInvestor = controller.userRole.value == 'investor';
            return GestureDetector(
              onTap: () => Get.toNamed(isInvestor ? Routes.SAVE_CAMPAIGN : Routes.MY_CAMPAIGN),
              child: _buildNavItem(
                isInvestor ? Icons.bookmark_outline : Icons.campaign_outlined, 
                isInvestor ? 'save_deal'.tr : 'my_deal'.tr
              ),
            );
          }),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.PROFILE),
            child: _buildNavItem(Icons.person_outline, 'profile'.tr),
          ),
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
          color: isActive
              ? const Color(0xFF22C55E)
              : Colors.white.withOpacity(0.4),
          size: 26,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive
                ? const Color(0xFF22C55E)
                : Colors.white.withOpacity(0.4),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
