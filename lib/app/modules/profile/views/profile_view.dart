import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: 'Profile'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Profile Card
                  _buildProfileCard(),
                  const SizedBox(height: 24),

                  // Primary Menu
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF1E1E1E)),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(Icons.campaign_outlined, 'My Deal', onTap: () => Get.toNamed(Routes.MY_CAMPAIGN)),
                        _buildDivider(),
                        _buildMenuItem(Icons.bookmark_outline, 'Save Deal', onTap: () => Get.toNamed(Routes.SAVE_CAMPAIGN)),
                        _buildDivider(),
                        _buildMenuItem(Icons.account_balance_wallet_outlined, 'Wallet', onTap: () => Get.toNamed(Routes.WALLET)),
                        _buildDivider(),
                        _buildMenuItem(Icons.account_balance_outlined, 'Bank Details', onTap: () => Get.toNamed(Routes.BANK_DETAILS)),
                        _buildDivider(),
                        _buildMenuItem(Icons.verified_outlined, 'Verification', onTap: () => Get.toNamed(Routes.VERIFICATIONS)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Settings Menu
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF1E1E1E)),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(Icons.settings_outlined, 'Settings', onTap: () => Get.toNamed(Routes.SETTING)),
                        _buildDivider(),
                        _buildMenuItem(Icons.send_outlined, 'Contact Us', onTap: () => Get.toNamed(Routes.CONTACT_U_S)),
                        _buildDivider(),
                        _buildMenuItem(Icons.shield_outlined, 'Privacy Policy', onTap: () => Get.toNamed(Routes.PRIVACY_POLICY)),
                        _buildDivider(),
                        _buildMenuItem(Icons.info_outline, 'Platform Guidelines', onTap: () => Get.toNamed(Routes.PLATFORM_GUIDLINES)),
                        _buildDivider(),
                        _buildMenuItem(
                          Icons.logout, 
                          'Logout', 
                          color: Colors.redAccent,
                          onTap: () => controller.logout(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F2D19).withOpacity(0.8),
            const Color(0xFF07140B).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF22C55E), width: 1.5),
            ),
            child: Obx(() => CircleAvatar(
              radius: 34,
              backgroundColor: const Color(0xFF1A1A1A),
              backgroundImage: controller.profileImage.value.isNotEmpty 
                ? NetworkImage(controller.profileImage.value) 
                : null,
              child: controller.profileImage.value.isEmpty 
                ? const Icon(Icons.person, color: Color(0xFF22C55E), size: 40)
                : null,
            )),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Row(
                  children: [
                    Text(
                      controller.userName.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (controller.isVerified.value)
                      const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.verified,
                          color: Color(0xFF22C55E), // Theme green
                          size: 18,
                        ),
                      ),
                  ],
                )),
                const SizedBox(height: 4),
                Obx(() => Text(
                  controller.userEmail.value,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                )),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final result = await Get.toNamed(Routes.EDIT_PROFILE);
                    if (result == true) {
                      controller.fetchFounderProfile();
                    }
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Color? color, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.white, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: color ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.3), size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFF1E1E1E),
      indent: 56,
      endIndent: 20,
    );
  }
}
