import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlatformBadge(),
                  const SizedBox(height: 20),
                  _buildIntroNote(),
                  const SizedBox(height: 24),
                  _buildSection('1. Introduction', _introText),
                  _buildSection('2. Information We Collect', _collectText),
                  _buildSection('3. How We Use Your Information', _useText),
                  _buildSection('4. Data Sharing and Disclosure', _sharingText),
                  _buildSection('5. Third-Party Services', _thirdPartyText),
                  _buildSection('6. Data Security', _securityText),
                  _buildSection('7. Data Retention', _retentionText),
                  _buildSection('8. Your Rights', _rightsText),
                  _buildSection('9. Children\'s Privacy', _childrenText),
                  _buildSection('10. International Data Transfers', _internationalText),
                  _buildSection('11. Changes to This Policy', _changesText),
                  const SizedBox(height: 8),
                  _buildContactCard(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.4)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_outlined, color: Color(0xFF22C55E), size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Privacy',
                    style: TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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

  Widget _buildPlatformBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F2D19).withValues(alpha: 0.9),
            const Color(0xFF07140B).withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.privacy_tip_outlined,
                  color: Color(0xFF22C55E),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BoostFundr',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined, color: Color(0xFF9CA3AF), size: 13),
                SizedBox(width: 6),
                Text(
                  'Last Updated: May 2025',
                  style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.lock_outline, color: Color(0xFF22C55E), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'BoostFundr respects your privacy and is committed to protecting your personal data. By using the Platform, you agree to this Privacy Policy.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<_PolicyItem> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1E1E1E)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => _buildItem(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(_PolicyItem item) {
    switch (item.type) {
      case _ItemType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            item.text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        );
      case _ItemType.bullet:
        return Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.text,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      case _ItemType.subheading:
        return Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 6),
          child: Text(
            item.text,
            style: const TextStyle(
              color: Color(0xFF22C55E),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case _ItemType.noSell:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Color(0xFF22C55E), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.text,
                    style: const TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F2D19).withValues(alpha: 0.9),
            const Color(0xFF07140B).withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.contact_support_outlined,
                  color: Color(0xFF22C55E),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Contact Us',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'To exercise your rights or for privacy-related questions:',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
          ),
          const SizedBox(height: 12),
          _buildContactRow('📧', 'Email', 'boostfundr@gmail.com'),
          const SizedBox(height: 8),
          _buildContactRow('🌐', 'Website', 'www.boostfundr.com'),
        ],
      ),
    );
  }

  Widget _buildContactRow(String emoji, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF22C55E),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Content Data ────────────────────────────────────────────────────────────

enum _ItemType { paragraph, bullet, subheading, noSell }

class _PolicyItem {
  final _ItemType type;
  final String text;
  const _PolicyItem(this.type, this.text);
}

final _introText = [
  const _PolicyItem(_ItemType.paragraph,
      'BoostFundr ("we", "our", "us") respects your privacy and is committed to protecting your personal data.'),
  const _PolicyItem(_ItemType.paragraph,
      'This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services ("Platform").'),
  const _PolicyItem(_ItemType.paragraph,
      'By using the Platform, you agree to this Privacy Policy.'),
];

final _collectText = [
  const _PolicyItem(_ItemType.paragraph,
      'We may collect the following types of information:'),
  const _PolicyItem(_ItemType.subheading, 'a. Personal Information'),
  const _PolicyItem(_ItemType.bullet, 'Name'),
  const _PolicyItem(_ItemType.bullet, 'Email address'),
  const _PolicyItem(_ItemType.bullet, 'Profile details'),
  const _PolicyItem(_ItemType.bullet, 'Account credentials'),
  const _PolicyItem(_ItemType.subheading, 'b. Usage Data'),
  const _PolicyItem(_ItemType.bullet, 'App interactions'),
  const _PolicyItem(_ItemType.bullet, 'Device information (device type, OS version)'),
  const _PolicyItem(_ItemType.bullet, 'Log data (IP address, session activity)'),
  const _PolicyItem(_ItemType.subheading, 'c. User-Provided Content'),
  const _PolicyItem(_ItemType.bullet, 'Startup profiles'),
  const _PolicyItem(_ItemType.bullet, 'Messages between users'),
  const _PolicyItem(_ItemType.bullet, 'Uploaded information and documents'),
];

final _useText = [
  const _PolicyItem(_ItemType.paragraph, 'We use your data to:'),
  const _PolicyItem(_ItemType.bullet, 'Provide and operate the Platform'),
  const _PolicyItem(_ItemType.bullet, 'Create and manage user accounts'),
  const _PolicyItem(_ItemType.bullet, 'Enable communication between users'),
  const _PolicyItem(_ItemType.bullet, 'Improve app performance and user experience'),
  const _PolicyItem(_ItemType.bullet, 'Send important updates and notifications'),
  const _PolicyItem(_ItemType.bullet, 'Ensure security and prevent misuse'),
];

final _sharingText = [
  const _PolicyItem(_ItemType.noSell, 'We do NOT sell your personal data.'),
  const _PolicyItem(_ItemType.paragraph, 'We may share data with:'),
  const _PolicyItem(_ItemType.bullet,
      'Service providers (e.g., hosting, analytics, payment processors)'),
  const _PolicyItem(_ItemType.bullet, 'Legal authorities if required by law'),
  const _PolicyItem(_ItemType.bullet,
      'Other users, only as part of platform functionality (e.g., profile visibility)'),
];

final _thirdPartyText = [
  const _PolicyItem(_ItemType.paragraph,
      'Our Platform may use third-party services such as:'),
  const _PolicyItem(_ItemType.bullet, 'Firebase (analytics, authentication)'),
  const _PolicyItem(_ItemType.bullet,
      'Payment providers (e.g., Stripe or similar)'),
  const _PolicyItem(_ItemType.paragraph,
      'These services have their own privacy policies. We are not responsible for their practices.'),
];

final _securityText = [
  const _PolicyItem(_ItemType.paragraph,
      'We implement reasonable technical and organizational measures to protect your data.'),
  const _PolicyItem(_ItemType.paragraph,
      'However, no system is completely secure, and we cannot guarantee absolute security.'),
];

final _retentionText = [
  const _PolicyItem(_ItemType.paragraph,
      'We retain your data only as long as necessary to:'),
  const _PolicyItem(_ItemType.bullet, 'Provide services'),
  const _PolicyItem(_ItemType.bullet, 'Comply with legal obligations'),
  const _PolicyItem(_ItemType.bullet, 'Resolve disputes'),
  const _PolicyItem(_ItemType.paragraph,
      'You may request deletion of your account and data at any time.'),
];

final _rightsText = [
  const _PolicyItem(_ItemType.paragraph,
      'Depending on your location, you may have the right to:'),
  const _PolicyItem(_ItemType.bullet, 'Access your data'),
  const _PolicyItem(_ItemType.bullet, 'Correct inaccurate information'),
  const _PolicyItem(_ItemType.bullet, 'Request deletion'),
  const _PolicyItem(_ItemType.bullet, 'Withdraw consent'),
  const _PolicyItem(_ItemType.paragraph,
      'To exercise these rights, contact us at the email below.'),
];

final _childrenText = [
  const _PolicyItem(_ItemType.paragraph,
      'BoostFundr is not intended for users under the age of 18.'),
  const _PolicyItem(_ItemType.paragraph,
      'We do not knowingly collect data from children.'),
];

final _internationalText = [
  const _PolicyItem(_ItemType.paragraph,
      'Your data may be processed in different countries where our service providers operate.'),
  const _PolicyItem(_ItemType.paragraph,
      'By using the Platform, you consent to such transfers.'),
];

final _changesText = [
  const _PolicyItem(_ItemType.paragraph,
      'We may update this Privacy Policy from time to time.'),
  const _PolicyItem(_ItemType.paragraph,
      'Changes will be posted within the app and/or website.'),
  const _PolicyItem(_ItemType.paragraph,
      'Continued use of the Platform means you accept the updated policy.'),
];
