import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/card_details_controller.dart';
import '../../../routes/app_pages.dart';

class CardDetailsView extends GetView<CardDetailsController> {
  const CardDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF22C55E);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final hasError = controller.hasError.value;
        final data = controller.dealData.value;

        if (isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF00FF88),
                  strokeWidth: 2,
                ),
                const SizedBox(height: 16),
                Text(
                  'loading'.tr,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          );
        }

        if (hasError || data == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'failed'.tr,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'ID: ${controller.dealId}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Error: ${controller.errorMessage.value}',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.fetchDealDetail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neonGreen.withValues(alpha: 0.1),
                      foregroundColor: neonGreen,
                      side: const BorderSide(color: neonGreen),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(neonGreen),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildStatusRow(neonGreen),
                    const SizedBox(height: 16),
                    _buildTagline(),
                    const SizedBox(height: 20),
                    _buildFundingCard(neonGreen),
                    const SizedBox(height: 20),
                    _buildProfileScoreCard(neonGreen),
                    const SizedBox(height: 20),

                    _buildInfoSection(
                      'Problem',
                      Icons.warning_amber_outlined,
                      controller.problem,
                    ),
                    const SizedBox(height: 14),
                    _buildInfoSection(
                      'Solution',
                      Icons.lightbulb_outline,
                      controller.solution,
                    ),
                    const SizedBox(height: 24),

                    _buildInfoSection(
                      'Problem',
                      Icons.warning_amber_outlined,
                      controller.problem,
                    ),
                    const SizedBox(height: 14),
                    _buildInfoSection(
                      'Solution',
                      Icons.lightbulb_outline,
                      controller.solution,
                    ),
                    const SizedBox(height: 24),

                    _buildLockedSection(
                      fieldName: 'businessModel',
                      child: _buildInfoSection(
                        'business_model'.tr,
                        Icons.business_center_outlined,
                        controller.businessModel,
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildLockedSection(
                      fieldName: 'market',
                      child: Column(
                        children: [
                          _buildInfoSection(
                            'market'.tr,
                            Icons.pie_chart_outline,
                            controller.market,
                          ),
                          const SizedBox(height: 14),
                          _buildInfoSection(
                            'Geography',
                            Icons.public,
                            controller.geography,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildLockedSection(
                      fieldName: 'team',
                      child: Column(
                        children: [
                          _buildInfoSection(
                            'Founder Details',
                            Icons.person_outline,
                            controller.founderDetails,
                          ),
                          const SizedBox(height: 14),
                          _buildInfoSection(
                            'Team Info',
                            Icons.groups_outlined,
                            controller.team,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildLockedSection(
                      fieldName: 'traction',
                      child: _buildInfoSection(
                        'Traction Details',
                        Icons.trending_up,
                        controller.traction,
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildLockedSection(
                      fieldName: 'useOfFunds',
                      child: _buildInfoSection(
                        'Use of Funds',
                        Icons.account_balance_wallet_outlined,
                        controller.useOfFunds,
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (controller.tractionHighlights.isNotEmpty) ...[
                      _buildSectionTitle('Traction Highlights'),
                      const SizedBox(height: 10),
                      _buildLockedSection(
                        fieldName: 'tractionHighlights',
                        child: _buildTractionChips(neonGreen),
                      ),
                      const SizedBox(height: 24),
                    ],

                    _buildSectionTitle('Private Documents'),
                    const SizedBox(height: 10),
                    _buildLockedSection(
                      fieldName: 'privateDocuments',
                      child: _buildPrivateDocumentsSection(),
                    ),
                    const SizedBox(height: 24),

                    if (controller.faq.isNotEmpty) ...[
                      _buildSectionTitle('FAQ'),
                      const SizedBox(height: 10),
                      _buildFaqList(),
                      const SizedBox(height: 24),
                    ],
                    _buildDeadlineRow(neonGreen),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── Sliver App Bar ──────────────────────────────────────
  Widget _buildSliverAppBar(Color neonGreen) {
    final img = controller.media.isNotEmpty ? controller.media.first : null;
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          controller.startupName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (img != null)
              Image.network(
                img,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _imagePlaceholder(neonGreen),
              )
            else
              _imagePlaceholder(neonGreen),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder(Color neonGreen) => Container(
    color: const Color(0xFF0B0F14),
    child: Icon(
      Icons.rocket_launch_outlined,
      color: neonGreen.withValues(alpha: 0.2),
      size: 48,
    ),
  );

  Widget _buildStatusRow(Color neonGreen) {
    final status = controller.status;
    final statusColor = status == 'approved'
        ? neonGreen
        : status == 'draft'
        ? const Color(0xFFFBBF24)
        : Colors.redAccent;

    return Row(
      children: [
        _chip(controller.category, const Color(0xFF1ABC9C)),
        const SizedBox(width: 8),
        _chip(controller.stage, const Color(0xFF818CF8)),
        const SizedBox(width: 8),
        _chip(status.toUpperCase(), statusColor),
        if (controller.isVerified) ...[
          const SizedBox(width: 8),
          const Icon(Icons.verified, color: Color(0xFF22C55E), size: 18),
        ],
      ],
    );
  }

  Widget _chip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Text(
      label,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildTagline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.tagline.isNotEmpty
              ? '"${controller.tagline}"'
              : controller.shortPitch,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        ),
        if (controller.tagline.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            controller.shortPitch,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
        ],
        if (controller.location.isNotEmpty && controller.location != '—') ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.white.withValues(alpha: 0.3),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                controller.location,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFundingCard(Color neonGreen) {
    final raised = controller.raisedAmount;
    final goal = controller.goalAmount;
    final ratio = controller.raisedProgress;
    final cur = controller.currency;
    String fmt(int n) => n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );

    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Funding Progress', Icons.trending_up, neonGreen),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$cur ${fmt(raised)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'of $cur ${fmt(goal)}',
                    style: TextStyle(color: Colors.white30, fontSize: 12),
                  ),
                ],
              ),
              Text(
                '${(ratio * 100).toInt()}%',
                style: TextStyle(
                  color: neonGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: ratio,
            backgroundColor: Colors.white10,
            color: neonGreen,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileScoreCard(Color neonGreen) {
    final score = controller.profileScore;
    final color = score >= 80
        ? neonGreen
        : score >= 50
        ? Colors.orange
        : Colors.red;

    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Trust Score', Icons.verified_user_outlined, color),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '$score',
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                ' / 100',
                style: TextStyle(color: Colors.white30, fontSize: 14),
              ),
              const Spacer(),
              Icon(
                Icons.shield_outlined,
                color: color.withValues(alpha: 0.5),
                size: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, String content) {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(title, icon, const Color(0xFF818CF8)),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTractionChips(Color neonGreen) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.tractionHighlights.map((t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: neonGreen.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: neonGreen.withValues(alpha: 0.2)),
        ),
        child: Text(
          t,
          style: TextStyle(
            color: neonGreen.withValues(alpha: 0.8),
            fontSize: 11,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildFaqList() {
    return Column(
      children: controller.faq.map((f) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.help_outline,
              color: Colors.white24,
              size: 16,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                f,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildDeadlineRow(Color neonGreen) {
    final days = controller.daysLeft;
    final color = days < 7 ? Colors.redAccent : neonGreen;
    return _glassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Campaign Ends',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
          Text(
            '$days Days Left',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0D1117),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
    ),
    child: child,
  );

  Widget _sectionLabel(String label, IconData icon, Color color) => Row(
    children: [
      Icon(icon, color: color, size: 14),
      const SizedBox(width: 6),
      Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ],
  );

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _buildLockedSection({
    required String fieldName,
    required Widget child,
  }) {
    return Obx(() {
      final isLocked = controller.isFieldLocked(fieldName);
      if (!isLocked) return child;
      
      final currentPlan = controller.userAccessLevel.toLowerCase();
      final target = controller.getTargetLevelForField(fieldName);
      
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: child,
            ),
            Container(color: Colors.black.withValues(alpha: 0.5)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_person_outlined,
                    color: Color(0xFF00FF88),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${'unlock_with'.tr} $target',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (currentPlan == 'free') ...[
                    // Show both Pro and Elite for free users
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed(Routes.SUBSCRIPTIONS),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('upgrade_to_pro'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Get.toNamed(Routes.SUBSCRIPTIONS),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF22C55E)),
                          foregroundColor: const Color(0xFF22C55E),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('upgrade_to_elite'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ] else if (currentPlan == 'pro') ...[
                    // Pro users only need to upgrade to Elite
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed(Routes.SUBSCRIPTIONS),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('upgrade_to_elite'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPrivateDocumentsSection() => _glassCard(
    child: const Center(
      child: Text(
        'Confidential documents locked',
        style: TextStyle(color: Colors.white30, fontSize: 12),
      ),
    ),
  );
}
