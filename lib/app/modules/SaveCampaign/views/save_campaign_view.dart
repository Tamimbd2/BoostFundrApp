import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                          color: Colors.white.withValues(alpha: 0.1),
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No saved deals yet',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Deals you bookmark will appear here',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.2),
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
    final progress = goal > 0
        ? ((deal.raisedProgress ?? 0) / 100).clamp(0.0, 1.0)
        : 0.0;

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
      daysLeft = 0;
    } else if (deal.deadline == null) {
      daysLeft = 12 + ((deal.id ?? '').hashCode.abs() % 10);
    }

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.CARD_DETAILS, arguments: deal.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1C1C1C), Color(0xFF161A16), Color(0xFF0F1A12)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF22C55E).withValues(alpha: 0.18),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF22C55E).withValues(alpha: 0.06),
              blurRadius: 16,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
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
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E2A1E), Color(0xFF0F1A0F)],
                        ),
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
                const SizedBox(width: 12),

                // Right Side: Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Menu Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              deal.startupName ?? 'Unnamed',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white.withValues(alpha: 0.5),
                              size: 18,
                            ),
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
                                        color: Colors.white.withValues(alpha: 0.9),
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

                      // Category with Dot
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF22C55E),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            deal.category ?? 'Startup',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Stats Row
                      Row(
                        children: [
                          // Raised
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Raised',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'AED ${fmt(raised)}',
                                    style: const TextStyle(
                                      color: Color(0xFF22C55E),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Divider
                          Container(
                            height: 18,
                            width: 1,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          const SizedBox(width: 8),
                          // Goal
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Goal',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'AED ${fmt(goal)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Days Left Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF22C55E).withValues(alpha: 0.15),
                                  const Color(0xFF16A34A).withValues(alpha: 0.08),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/logo/icons/ic_calendar.svg',
                                  width: 10,
                                  height: 10,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF22C55E),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$daysLeft Days Left',
                                  style: const TextStyle(
                                    color: Color(0xFF22C55E),
                                    fontSize: 9,
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
            const SizedBox(height: 10),

            // Gradient Progress Bar
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        // Background track
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        // Gradient fill
                        FractionallySizedBox(
                          widthFactor: progress.clamp(0.0, 1.0),
                          child: Container(
                            height: 4,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF16A34A),
                                  Color(0xFF22C55E),
                                  Color(0xFF4ADE80),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Color(0xFF22C55E),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
