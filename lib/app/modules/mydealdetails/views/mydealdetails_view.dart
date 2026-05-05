import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/mydealdetails_controller.dart';

class MydealdetailsView extends GetView<MydealdetailsController> {
  const MydealdetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF22C55E);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final data = controller.dealData.value;

        if (isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFF00FF88),
                  strokeWidth: 2,
                ),
                SizedBox(height: 16),
                Text(
                  'Loading your deal...',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          );
        }

        if (data == null) {
          return const Center(
            child: Text(
              'No deal data found',
              style: TextStyle(color: Colors.white70),
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
                    _buildMetricsGrid(neonGreen),
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
                    const SizedBox(height: 14),
                    _buildInfoSection(
                      'Business Model',
                      Icons.business_center_outlined,
                      controller.businessModel,
                    ),
                    const SizedBox(height: 24),

                    _buildInfoSection(
                      'Market',
                      Icons.pie_chart_outline,
                      controller.market,
                    ),
                    const SizedBox(height: 14),
                    _buildInfoSection(
                      'Geography',
                      Icons.public,
                      controller.location,
                    ),
                    const SizedBox(height: 24),

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
                    const SizedBox(height: 24),

                    _buildInfoSection(
                      'Traction Details',
                      Icons.trending_up,
                      controller.traction,
                    ),
                    const SizedBox(height: 14),
                    _buildInfoSection(
                      'Market Strategy',
                      Icons.map_outlined,
                      controller.goToMarket,
                    ),
                    const SizedBox(height: 14),
                    _buildInfoSection(
                      'Competitor & Advantage',
                      Icons.military_tech_outlined,
                      'Top Competitor: ${controller.topCompetitor}\nAdvantage: ${controller.advantage}',
                    ),
                    const SizedBox(height: 24),

                    _buildInfoSection(
                      'Use of Funds',
                      Icons.account_balance_wallet_outlined,
                      controller.useOfFunds,
                    ),
                    const SizedBox(height: 24),

                    if (controller.tractionHighlights.isNotEmpty) ...[
                      _buildSectionTitle('Traction Highlights'),
                      const SizedBox(height: 10),
                      _buildTractionChips(neonGreen),
                      const SizedBox(height: 24),
                    ],

                    if (controller.faq.isNotEmpty) ...[
                      _buildSectionTitle('FAQ'),
                      const SizedBox(height: 10),
                      _buildFaqList(),
                      const SizedBox(height: 24),
                    ],

                    _buildSectionTitle('Connect & Learn More'),
                    const SizedBox(height: 10),
                    _buildContactButtons(neonGreen),
                    const SizedBox(height: 24),

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

  Widget _buildSliverAppBar(Color neonGreen) {
    final img = controller.headerImage;
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
          '"${controller.tagline}"',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(ratio * 100).toInt()}%',
                    style: TextStyle(
                      color: neonGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (controller.minimumInvestment > 0)
                    Text(
                      'Min. $cur ${fmt(controller.minimumInvestment)}',
                      style: const TextStyle(
                        color: Colors.white30,
                        fontSize: 10,
                      ),
                    ),
                ],
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

  Widget _buildMetricsGrid(Color neonGreen) {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(
            'Metrics & Growth',
            Icons.analytics_outlined,
            neonGreen,
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _metricItem('Users', controller.users, Icons.people_outline),
              _metricItem(
                'Growth',
                '${controller.growthRate}%',
                Icons.show_chart,
              ),
              _metricItem(
                'Revenue',
                controller.revenue,
                Icons.monetization_on_outlined,
              ),
              _metricItem('CAC', controller.cac, Icons.person_add_alt),
              _metricItem('LTV', controller.ltv, Icons.payments_outlined),
              _metricItem('Churn', controller.churn, Icons.autorenew),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white30, size: 14),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 9),
            textAlign: TextAlign.center,
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
      children: controller.tractionHighlights
          .map(
            (t) => Container(
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
            ),
          )
          .toList(),
    );
  }

  Widget _buildFaqList() {
    return Column(
      children: controller.faq
          .map(
            (f) => Container(
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
            ),
          )
          .toList(),
    );
  }

  Widget _buildContactButtons(Color neonGreen) {
    return Column(
      children: [
        if (controller.startupWebsite.isNotEmpty)
          _actionButton('Visit Website', Icons.language, neonGreen, () async {
            final url = Uri.parse(controller.startupWebsite.startsWith('http') 
                ? controller.startupWebsite 
                : 'https://${controller.startupWebsite}');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          }),
        if (controller.startupWebsite.isNotEmpty &&
            controller.whatsappNumber.isNotEmpty)
          const SizedBox(height: 12),
        if (controller.whatsappNumber.isNotEmpty)
          _actionButton(
            'WhatsApp Founder',
            Icons.chat_bubble_outline,
            const Color(0xFF25D366),
            () async {
              final phone = controller.whatsappNumber.replaceAll(RegExp(r'\D'), '');
              final url = Uri.parse('https://wa.me/$phone');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
      ],
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withValues(alpha: 0.5)),
          ),
        ),
      ),
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
}
