import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verifications_controller.dart';
import '../../../widgets/custom_app_bar.dart';
import 'postverification.dart';

class VerificationsView extends GetView<VerificationsController> {
  const VerificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const CustomAppBar(title: 'Verification Status'),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF22C55E)),
                );
              }
              
              if (controller.isVerified.value) {
                return _buildVerifiedFullScreen();
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchStatus(),
                color: const Color(0xFF22C55E),
                backgroundColor: const Color(0xFF111111),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusHeader(controller.overallStatus.value),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Required Verifications'),
                      const SizedBox(height: 16),
                      _buildVerificationCard(
                        icon: Icons.person_outline,
                        title: 'Identity Verification',
                        subtitle: 'National ID, Passport or Driver\'s License',
                        status: controller.identityStatus.value,
                        statusColor: _getStatusColor(controller.identityStatus.value),
                      ),
                      const SizedBox(height: 16),
                      _buildVerificationCard(
                        icon: Icons.business_outlined,
                        title: 'Business Verification',
                        subtitle: 'Trade License or Incorporation documents',
                        status: controller.businessStatus.value,
                        statusColor: _getStatusColor(controller.businessStatus.value),
                      ),
                      const SizedBox(height: 40),
                      if (controller.overallStatus.value == 'Not Started' || controller.overallStatus.value == 'Rejected')
                        _buildApplyButton(),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Why Verify?'),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Verification helps us keep the platform safe and ensures that you can withdraw your funds securely.',
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedFullScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.2), width: 2),
              ),
              child: const Icon(
                Icons.verified_user,
                color: Color(0xFF22C55E),
                size: 80,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'You are Verified!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Congratulations! Your founder identity has been verified. You now have full access to create campaigns and raise funds.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 200,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Back to Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => Get.to(() => const PostVerificationView()),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF22C55E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Apply for Verification',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(String status) {
    final statusColor = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withValues(alpha: 0.1),
            const Color(0xFF111111),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: statusColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Status',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E1E1E)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white54, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Verified':
        return const Color(0xFF22C55E);
      case 'Pending':
        return Colors.blue;
      case 'Rejected':
        return Colors.redAccent;
      case 'Not Started':
      default:
        return Colors.orange;
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
