import 'package:boost_fundr/export.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/deal_model.dart';
import '../../../routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildGreeting(),
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
                                  color: Colors.white.withValues(alpha: 0.4),
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
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── Header ───────────────────────────────────────────
  // ─── Top Bar ──────────────────────────────────────────
  // ─── Top Bar ──────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Logo & Title
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: child,
            ),
            child: Image.asset('assets/logo/logohome.png', height: 40),
          ),

          // Right Icons
          Row(
            children: [
              // User Avatar
              GestureDetector(
                onTap: () => Get.toNamed(Routes.PROFILE),
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
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
        ],
      ),
    );
  }

  // ─── Greeting Section ──────────────────────────────────
  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Obx(
              () => Flexible(
                child: Text(
                  '${'hi'.tr}, ${controller.userName.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('👋', style: TextStyle(fontSize: 28)),
          ],
        ),
        const SizedBox(height: 8),
        Obx(
          () => Text(
            controller.userRole.value == 'investor'
                ? 'Investor Dashboard'
                : 'Founder Dashboard',
            style: TextStyle(
              color: const Color(0xFF22C55E).withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Create Deal Button ───────────────────────────────
  Widget _buildCreateCampaignButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.CREATE_CAMPAIGN),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF0A1F14), // Very dark green/black background
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF22C55E).withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Plus Icon Container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Transform.rotate(
                  angle: 0.785398, // 45 degrees in radians
                  child: SvgPicture.asset(
                    'assets/logo/icons/ic_cross.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create New Campaign',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start a new campaign in minutes',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Right Arrow
            const Icon(Icons.chevron_right, color: Color(0xFF22C55E), size: 28),
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
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white.withValues(alpha: 0.5),
                              size: 18,
                            ),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: const Color(0xFF1C1C1C),
                            onSelected: (value) {
                              if (value == 'save') {
                                controller.toggleBookmark(deal);
                              }
                            },
                            itemBuilder: (context) => [
                              if (controller.userRole.value == 'investor')
                                PopupMenuItem(
                                  value: 'save',
                                  child: Row(
                                    children: [
                                      Icon(
                                        deal.isBookmarked ?? false
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        size: 18,
                                        color: const Color(0xFF22C55E),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        deal.isBookmarked ?? false
                                            ? 'Unsave Deal'
                                            : 'Save Deal',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
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
                                  const Color(
                                    0xFF22C55E,
                                  ).withValues(alpha: 0.15),
                                  const Color(
                                    0xFF16A34A,
                                  ).withValues(alpha: 0.08),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(
                                  0xFF22C55E,
                                ).withValues(alpha: 0.2),
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

  // ─── Bottom Navigation ────────────────────────────────
  Widget _buildBottomNav() {
    final double bottomPadding = MediaQuery.of(Get.context!).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Color(0xFF1E1E1E), width: 0.5)),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              isActive: true,
              activeSvg: 'assets/logo/icons/Icn_home_fill.svg',
              inactiveSvg: 'assets/logo/icons/Icn_home.svg',
              label: 'home'.tr,
            ),
            Obx(() {
              final isInvestor = controller.userRole.value == 'investor';
              return GestureDetector(
                onTap: () => Get.toNamed(
                  isInvestor ? Routes.SAVE_CAMPAIGN : Routes.MY_CAMPAIGN,
                ),
                child: _buildNavItem(
                  activeSvg: isInvestor
                      ? 'assets/logo/icons/ic_save.svg'
                      : 'assets/logo/icons/ic_campaign_fill.svg',
                  inactiveSvg: isInvestor
                      ? 'assets/logo/icons/ic_save.svg'
                      : 'assets/logo/icons/ic_campaign.svg',
                  label: isInvestor ? 'save_deal'.tr : 'my_deal'.tr,
                ),
              );
            }),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.SUBSCRIPTIONS),
              child: _buildNavItem(
                activeSvg: 'assets/logo/icons/ic_privacy.svg',
                inactiveSvg: 'assets/logo/icons/ic_privacy.svg',
                label: 'Subscription',
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.PROFILE),
              child: _buildNavItem(
                activeSvg: 'assets/logo/icons/ic_user_fill.svg',
                inactiveSvg: 'assets/logo/icons/ic_user.svg',
                label: 'profile'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String activeSvg,
    required String inactiveSvg,
    required String label,
    bool isActive = false,
  }) {
    final color = isActive
        ? const Color(0xFF22C55E)
        : Colors.white.withValues(alpha: 0.4);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          isActive ? activeSvg : inactiveSvg,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 10)),
      ],
    );
  }
}
