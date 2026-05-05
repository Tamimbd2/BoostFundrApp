import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/save_campaign_controller.dart';
import '../../../data/models/deal_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_app_bar.dart';

class SaveCampaignView extends GetView<SaveCampaignController> {
  const SaveCampaignView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Saved Deals'),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF22C55E),
                      strokeWidth: 2,
                    ),
                  );
                }

                if (controller.savedDeals.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          color: Colors.white.withOpacity(0.1),
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No saved deals yet',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Deals you bookmark will appear here',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.2),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchSavedDeals(),
                  color: const Color(0xFF22C55E),
                  backgroundColor: const Color(0xFF111111),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.savedDeals.length,
                    itemBuilder: (context, index) {
                      return _buildCampaignCard(controller.savedDeals[index]);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignCard(DealModel deal) {
    final raised = (deal.raisedAmount ?? 0).toInt();
    final goal = (deal.raisedGoal ?? 100000).toInt();
    final progress = goal > 0 ? ((deal.raisedProgress ?? 0) / 100).clamp(0.0, 1.0) : 0.0;

    final profileScore = (deal.profileCompletionScore ?? 0).clamp(0, 100);
    final Color scoreColor = profileScore >= 80
        ? const Color(0xFF00FF55)
        : profileScore >= 40
            ? const Color(0xFFFFB020)
            : const Color(0xFFFF5252);

    String fmt(int n) => n.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );

    int daysLeft = 0;
    if (deal.deadline != null) {
      final deadlineDate = DateTime.tryParse(deal.deadline!);
      if (deadlineDate != null) {
        daysLeft = deadlineDate.difference(DateTime.now()).inDays.clamp(0, 999);
      }
    }

    final Color timeColor = daysLeft <= 12
        ? const Color(0xFFFFB020)
        : daysLeft > 30
            ? const Color(0xFF00FF55)
            : const Color(0xFFFF5252);

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.CARD_DETAILS, arguments: deal.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  child: const Icon(Icons.image, color: Colors.white24, size: 28),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (deal.isVerified == true) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.verified, color: Color(0xFF22C55E), size: 16),
                            ],
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.more_horiz, color: Colors.white54, size: 20),
                        color: const Color(0xFF1C1C1E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        onSelected: (value) {
                          if (value == 'unsave') {
                            controller.toggleBookmark(deal);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'unsave',
                            child: Row(
                              children: [
                                const Icon(Icons.bookmark, color: Color(0xFF22C55E), size: 18),
                                const SizedBox(width: 12),
                                Text(
                                  'Unsave Deal',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A3B2A),
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
                  Text(
                    'AED ${fmt(raised)} / ${fmt(goal)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFF2C2C2E),
                      color: scoreColor,
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
