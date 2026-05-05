import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_campaign_controller.dart';
import '../../../data/models/deal_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/gradient_background.dart';

class MyCampaignView extends GetView<MyCampaignController> {
  const MyCampaignView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'My Deals',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF22C55E)),
          );
        }

        if (controller.deals.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.campaign_outlined,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 16),
                Text(
                  'You haven\'t created any deals yet.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          itemCount: controller.deals.length,
          itemBuilder: (context, index) {
            final deal = controller.deals[index];
            return _buildCampaignCard(deal);
          },
        );
      }),
      ),
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

    final daysLeft = 12 + ((deal.id ?? '').hashCode.abs() % 10);
    final Color timeColor = daysLeft <= 12
        ? const Color(0xFFFFB020) // Yellow for 12 days
        : daysLeft > 15
        ? const Color(0xFFFF5252) // Red for 18 days
        : const Color(0xFF00FF55); // Green otherwise

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.MYDEALDETAILS, arguments: deal),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF161616), // Dark background matching screenshot
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Image + Overlapping Badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    deal.imageUrl ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
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
                // Overlapping percentage badge
                Positioned(
                  bottom: -8,
                  left: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: scoreColor, width: 2),
                    ),
                    child: Text(
                      '$profileScore%',
                      style: TextStyle(
                        color: scoreColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
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
                        child: Text(
                          deal.startupName ?? 'Unnamed',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600, // Thinner title
                            letterSpacing: 0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                              arguments: deal,
                            );
                          }
                        },
                        itemBuilder: (context) => [
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
                                    color: Colors.white.withValues(alpha: 0.9),
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
                                    color: Colors.redAccent.withValues(alpha: 0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                        '$daysLeft Days Left',
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
}
