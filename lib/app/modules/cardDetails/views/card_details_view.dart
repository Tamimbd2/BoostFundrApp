import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/card_details_controller.dart';

class CardDetailsView extends GetView<CardDetailsController> {
  const CardDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF00FF88);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00FF88),
              strokeWidth: 2,
            ),
          );
        }
        if (controller.hasError.value || controller.dealData.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Failed to load deal',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text('ID: ${controller.dealId}',
                          style: const TextStyle(color: Colors.amber, fontSize: 12, fontFamily: 'monospace')),
                        const SizedBox(height: 4),
                        Text('Error: ${controller.errorMessage.value}',
                          style: const TextStyle(color: Colors.redAccent, fontSize: 11)),
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: controller.fetchDealDetail,
                    child: const Text('Retry', style: TextStyle(color: Color(0xFF00FF88))),
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
                    _buildInfoSection('Problem', Icons.warning_amber_outlined, controller.problem),
                    const SizedBox(height: 14),
                    _buildInfoSection('Solution', Icons.lightbulb_outline, controller.solution),
                    const SizedBox(height: 20),
                    if (controller.tractionHighlights.isNotEmpty) ...[
                      _buildSectionTitle('Traction Highlights'),
                      const SizedBox(height: 10),
                      _buildTractionChips(neonGreen),
                      const SizedBox(height: 20),
                    ],
                    if (controller.faq.isNotEmpty) ...[
                      _buildSectionTitle('FAQ'),
                      const SizedBox(height: 10),
                      _buildFaqList(),
                      const SizedBox(height: 20),
                    ],
                    _buildDeadlineRow(neonGreen),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── Sliver App Bar with hero image ───────────────────────
  Widget _buildSliverAppBar(Color neonGreen) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: Colors.black,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white12),
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Obx(() => Text(
          controller.startupName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )),
        background: Obx(() {
          final img = controller.media.isNotEmpty ? controller.media.first : null;
          return Stack(
            fit: StackFit.expand,
            children: [
              if (img != null)
                Image.network(img, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imagePlaceholder(neonGreen))
              else
                _imagePlaceholder(neonGreen),
              // gradient overlay
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _imagePlaceholder(Color neonGreen) => Container(
    color: const Color(0xFF0B0F14),
    child: Icon(Icons.water_drop_outlined, color: neonGreen, size: 60),
  );

  // ── Status row ───────────────────────────────────────────
  Widget _buildStatusRow(Color neonGreen) {
    return Obx(() {
      final status = controller.status;
      final isApproved = status == 'approved';
      final statusColor = isApproved ? neonGreen
          : status == 'draft' ? const Color(0xFFFBBF24)
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
            const Icon(Icons.verified, color: Color(0xFF60A5FA), size: 18),
          ],
        ],
      );
    });
  }

  Widget _chip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.5), width: 1),
    ),
    child: Text(label,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
  );

  // ── Tagline ──────────────────────────────────────────────
  Widget _buildTagline() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.tagline.isNotEmpty ? '"${controller.tagline}"' : controller.shortPitch,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.4,
          ),
        ),
        if (controller.tagline.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            controller.shortPitch,
            style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13, height: 1.5),
          ),
        ],
        if (controller.location.isNotEmpty && controller.location != '—') ...[
          const SizedBox(height: 10),
          Row(children: [
            Icon(Icons.location_on_outlined, color: Colors.white.withOpacity(0.4), size: 14),
            const SizedBox(width: 4),
            Text(controller.location,
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
          ]),
        ],
      ],
    ));
  }

  // ── Funding card ─────────────────────────────────────────
  Widget _buildFundingCard(Color neonGreen) {
    return Obx(() {
      final raised = controller.raisedAmount;
      final goal   = controller.goalAmount;
      final ratio  = controller.raisedProgress;
      final pct    = (ratio * 100).toInt();
      final cur    = controller.currency;

      String fmt(int n) => n.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

      return _glassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Raised Funding', Icons.trending_up_rounded, neonGreen),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('$cur ${fmt(raised)}',
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text('of $cur ${fmt(goal)} goal',
                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: neonGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: neonGreen, width: 1.5),
                  ),
                  child: Text('$pct%',
                    style: const TextStyle(color: Color(0xFF00FF88), fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(children: [
                Container(height: 6, color: const Color(0xFF1C2333)),
                FractionallySizedBox(
                  widthFactor: ratio,
                  child: Container(
                    height: 6,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF00FF88), Color(0xFF00C853)]),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      );
    });
  }

  // ── Profile score card ───────────────────────────────────
  Widget _buildProfileScoreCard(Color neonGreen) {
    return Obx(() {
      final score = controller.profileScore;
      final ratio = score / 100.0;
      final Color c = score >= 80 ? neonGreen
          : score >= 50 ? const Color(0xFFFBBF24)
          : Colors.redAccent;

      return _glassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Profile Completion Score', Icons.verified_user_outlined, c),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$score / 100',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: c.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: c, width: 1.5),
                  ),
                  child: Text('$score%',
                    style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(children: [
                Container(height: 6, color: const Color(0xFF1C2333)),
                FractionallySizedBox(
                  widthFactor: ratio,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [c, c.withOpacity(0.5)]),
                      boxShadow: [BoxShadow(color: c.withOpacity(0.4), blurRadius: 8)],
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            Text(
              score >= 80 ? '✅ Great profile! Ready for investors.'
                  : score >= 50 ? '⚠️ Add more details to attract investors.'
                  : '❌ Complete your profile to get discovered.',
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
            ),
          ],
        ),
      );
    });
  }

  // ── Info section ─────────────────────────────────────────
  Widget _buildInfoSection(String title, IconData icon, String content) {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(title, icon, const Color(0xFF818CF8)),
          const SizedBox(height: 10),
          Text(content,
            style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13, height: 1.6)),
        ],
      ),
    );
  }

  // ── Traction chips ───────────────────────────────────────
  Widget _buildTractionChips(Color neonGreen) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.tractionHighlights.map((t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: neonGreen.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: neonGreen.withOpacity(0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.rocket_launch_outlined, color: neonGreen, size: 12),
          const SizedBox(width: 5),
          Text(t, style: TextStyle(color: neonGreen.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w500)),
        ]),
      )).toList(),
    );
  }

  // ── FAQ list ─────────────────────────────────────────────
  Widget _buildFaqList() {
    return Column(
      children: controller.faq.asMap().entries.map((e) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFF818CF8).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('${e.key + 1}',
                  style: const TextStyle(color: Color(0xFF818CF8), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(e.value,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13))),
          ],
        ),
      )).toList(),
    );
  }

  // ── Deadline row ─────────────────────────────────────────
  Widget _buildDeadlineRow(Color neonGreen) {
    return Obx(() {
      final days = controller.daysLeft;
      final Color c = days < 7 ? Colors.redAccent
          : days < 30 ? const Color(0xFFFBBF24) : neonGreen;
      return _glassCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Icon(Icons.timer_outlined, color: c, size: 18),
              const SizedBox(width: 8),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Deadline', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
                const SizedBox(height: 2),
                Text(controller.deadlineFormatted,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              ]),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: c.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: c, width: 1.5),
              ),
              child: Text('$days days left',
                style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    });
  }

  // ── Shared helpers ───────────────────────────────────────
  Widget _glassCard({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0D1117), Color(0xFF111827)],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.06)),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4)),
      ],
    ),
    child: child,
  );

  Widget _sectionLabel(String label, IconData icon, Color color) => Row(
    children: [
      Icon(icon, color: color, size: 15),
      const SizedBox(width: 6),
      Text(label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
    ],
  );

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  );
}
