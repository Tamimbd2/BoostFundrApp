import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/termsdetails_controller.dart';

class TermsdetailsView extends GetView<TermsdetailsController> {
  const TermsdetailsView({super.key});

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
                  _buildWarningBanner(),
                  const SizedBox(height: 24),
                  _buildSection('1. Introduction', _introText),
                  _buildSection('2. Nature of the Service', _natureText),
                  _buildNoticeBox(_noticeItems),
                  const SizedBox(height: 16),
                  _buildSection('3. Eligibility', _eligibilityText),
                  _buildSection('4. User Accounts', _accountsText),
                  _buildSection('5. User Roles', _rolesText),
                  _buildWarningNote('BoostFundr does not guarantee investment outcomes or verify financial performance.'),
                  const SizedBox(height: 16),
                  _buildSection('6. No Financial Advice', _financialAdviceText),
                  _buildSection('7. Risk Disclosure', _riskText),
                  _buildSection('8. Payments and Fees', _paymentsText),
                  _buildWarningNote('BoostFundr does not store or control user funds.'),
                  const SizedBox(height: 16),
                  _buildSection('9. Third-Party Services', _thirdPartyText),
                  _buildSection('10. User Content', _userContentText),
                  _buildSection('11. Prohibited Activities', _prohibitedText),
                  _buildSection('12. Intellectual Property', _ipText),
                  _buildSection('13. Limitation of Liability', _liabilityText),
                  _buildSection('14. Indemnification', _indemnificationText),
                  _buildSection('15. Suspension and Termination', _terminationText),
                  _buildSection('16. Governing Law', _governingLawText),
                  _buildSection('17. Changes to Terms', _changesText),
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
                'Terms & Conditions',
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
                  Icon(Icons.description_outlined, color: Color(0xFF22C55E), size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Legal',
                    style: TextStyle(color: Color(0xFF22C55E), fontSize: 12, fontWeight: FontWeight.w600),
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
                child: const Icon(Icons.rocket_launch_rounded, color: Color(0xFF22C55E), size: 22),
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
                    'Platform Terms & Conditions',
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

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBBF24).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Important Notice',
                  style: TextStyle(
                    color: Color(0xFFFBBF24),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'By accessing or using the Platform, you agree to these Terms & Conditions. If you do not agree, you must discontinue use immediately.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<_TermItem> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
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
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
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
              children: items.map((item) => _buildTermItem(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermItem(_TermItem item) {
    switch (item.type) {
      case _ItemType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            item.text,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14, height: 1.6),
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
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14, height: 1.5),
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
    }
  }

  Widget _buildNoticeBox(List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFBBF24).withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('⚠️', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Text(
                  'BoostFundr Important Notice:',
                  style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Icon(Icons.close, color: Color(0xFFEF4444), size: 14),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 4),
            Text(
              'All investment discussions and transactions occur independently outside the Platform.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningNote(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFBBF24).withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
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
                child: const Icon(Icons.contact_support_outlined, color: Color(0xFF22C55E), size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                '18. Contact Information',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'For questions or support:',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
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

enum _ItemType { paragraph, bullet, subheading }

class _TermItem {
  final _ItemType type;
  final String text;
  const _TermItem(this.type, this.text);
}

final _introText = [
  const _TermItem(_ItemType.paragraph,
      'Welcome to BoostFundr ("Platform", "we", "our", "us").'),
  const _TermItem(_ItemType.paragraph,
      'BoostFundr is a technology platform designed to connect startup founders and investors for discovery and communication purposes.'),
  const _TermItem(_ItemType.paragraph,
      'By accessing or using the Platform, you agree to these Terms & Conditions ("Terms"). If you do not agree, you must discontinue use immediately.'),
];

final _natureText = [
  const _TermItem(_ItemType.paragraph, 'BoostFundr operates solely as:'),
  const _TermItem(_ItemType.bullet, 'A technology platform'),
  const _TermItem(_ItemType.bullet, 'A discovery and networking service'),
  const _TermItem(_ItemType.bullet, 'A communication facilitator between users'),
];

final _noticeItems = [
  'Does NOT hold, receive, or manage funds',
  'Does NOT execute or process investments',
  'Does NOT provide financial, legal, or tax advice',
  'Does NOT act as a broker, dealer, or financial intermediary',
];

final _eligibilityText = [
  const _TermItem(_ItemType.paragraph, 'To use BoostFundr, you must:'),
  const _TermItem(_ItemType.bullet, 'Be at least 18 years old'),
  const _TermItem(_ItemType.bullet, 'Have legal capacity to enter into binding agreements'),
  const _TermItem(_ItemType.bullet, 'Comply with all applicable laws and regulations'),
  const _TermItem(_ItemType.paragraph,
      'We reserve the right to restrict or terminate access at our discretion.'),
];

final _accountsText = [
  const _TermItem(_ItemType.paragraph, 'When creating an account, you agree to:'),
  const _TermItem(_ItemType.bullet, 'Provide accurate and up-to-date information'),
  const _TermItem(_ItemType.bullet, 'Maintain confidentiality of your login credentials'),
  const _TermItem(_ItemType.bullet, 'Accept responsibility for all activities under your account'),
  const _TermItem(_ItemType.paragraph,
      'We may suspend or terminate accounts that violate these Terms.'),
];

final _rolesText = [
  const _TermItem(_ItemType.subheading, 'Investors'),
  const _TermItem(_ItemType.bullet, 'Explore startup listings'),
  const _TermItem(_ItemType.bullet, 'Request access to startup information'),
  const _TermItem(_ItemType.bullet, 'Communicate with founders'),
  const _TermItem(_ItemType.subheading, 'Founders'),
  const _TermItem(_ItemType.bullet, 'Create and manage startup profiles'),
  const _TermItem(_ItemType.bullet, 'Share business information'),
  const _TermItem(_ItemType.bullet, 'Communicate with investors'),
];

final _financialAdviceText = [
  const _TermItem(_ItemType.paragraph, 'All information provided on the Platform is:'),
  const _TermItem(_ItemType.bullet, 'For general informational purposes only'),
  const _TermItem(_ItemType.bullet, 'Not financial, legal, or tax advice'),
  const _TermItem(_ItemType.paragraph,
      'Users are solely responsible for conducting their own due diligence before making any decisions.'),
];

final _riskText = [
  const _TermItem(_ItemType.paragraph, 'Startup investments involve significant risks, including:'),
  const _TermItem(_ItemType.bullet, 'Loss of capital'),
  const _TermItem(_ItemType.bullet, 'Limited liquidity'),
  const _TermItem(_ItemType.bullet, 'Uncertain returns'),
  const _TermItem(_ItemType.paragraph,
      'By using the Platform, you acknowledge and accept these risks.'),
];

final _paymentsText = [
  const _TermItem(_ItemType.paragraph, 'BoostFundr may charge fees, including:'),
  const _TermItem(_ItemType.bullet, 'Subscription fees'),
  const _TermItem(_ItemType.bullet, 'Listing fees'),
  const _TermItem(_ItemType.bullet, 'Service-related charges'),
  const _TermItem(_ItemType.paragraph,
      'Payments are processed through third-party providers (such as Stripe or similar services).'),
];

final _thirdPartyText = [
  const _TermItem(_ItemType.paragraph,
      'The Platform may integrate or reference third-party services. We are not responsible for:'),
  const _TermItem(_ItemType.bullet, 'Third-party services'),
  const _TermItem(_ItemType.bullet, 'Payment processors'),
  const _TermItem(_ItemType.bullet, 'External platforms or links'),
  const _TermItem(_ItemType.paragraph,
      'Use of such services is subject to their own terms and policies.'),
];

final _userContentText = [
  const _TermItem(_ItemType.paragraph,
      'Users are responsible for all content they provide, including:'),
  const _TermItem(_ItemType.bullet, 'Business information'),
  const _TermItem(_ItemType.bullet, 'Financial data'),
  const _TermItem(_ItemType.bullet, 'Messages and communications'),
  const _TermItem(_ItemType.paragraph,
      'By submitting content, you grant BoostFundr a non-exclusive, worldwide license to use, display, and distribute such content within the Platform.'),
];

final _prohibitedText = [
  const _TermItem(_ItemType.paragraph, 'Users must NOT:'),
  const _TermItem(_ItemType.bullet, 'Provide false or misleading information'),
  const _TermItem(_ItemType.bullet, 'Engage in fraud, scams, or deceptive practices'),
  const _TermItem(_ItemType.bullet, 'Violate any applicable laws or regulations'),
  const _TermItem(_ItemType.bullet, 'Attempt unauthorized access to the Platform'),
  const _TermItem(_ItemType.paragraph,
      'Violations may result in account suspension, termination, and possible legal action.'),
];

final _ipText = [
  const _TermItem(_ItemType.paragraph, 'All Platform content, including branding, design, and software, is owned by BoostFundr.'),
  const _TermItem(_ItemType.paragraph,
      'You may not copy, modify, distribute, or reverse engineer any part of the Platform without written permission.'),
];

final _liabilityText = [
  const _TermItem(_ItemType.paragraph,
      'To the maximum extent permitted by law, BoostFundr is not responsible for:'),
  const _TermItem(_ItemType.bullet, 'Investment outcomes or financial losses'),
  const _TermItem(_ItemType.bullet, 'User disputes'),
  const _TermItem(_ItemType.bullet, 'Business performance or failures'),
  const _TermItem(_ItemType.bullet, 'Actions of third parties'),
  const _TermItem(_ItemType.paragraph, 'Use of the Platform is at your own risk.'),
];

final _indemnificationText = [
  const _TermItem(_ItemType.paragraph,
      'You agree to indemnify and hold BoostFundr harmless from any claims, damages, or expenses arising from:'),
  const _TermItem(_ItemType.bullet, 'Your use of the Platform'),
  const _TermItem(_ItemType.bullet, 'Violation of these Terms'),
  const _TermItem(_ItemType.bullet, 'Infringement of any rights of others'),
];

final _terminationText = [
  const _TermItem(_ItemType.paragraph, 'We may:'),
  const _TermItem(_ItemType.bullet, 'Suspend or terminate accounts'),
  const _TermItem(_ItemType.bullet, 'Remove content'),
  const _TermItem(_ItemType.bullet, 'Restrict access'),
  const _TermItem(_ItemType.paragraph,
      'At any time, with or without notice, if Terms are violated or for operational reasons.'),
];

final _governingLawText = [
  const _TermItem(_ItemType.paragraph,
      'These Terms are governed by the laws of the United Arab Emirates.'),
  const _TermItem(_ItemType.paragraph,
      'Any disputes shall be subject to the jurisdiction of UAE courts.'),
];

final _changesText = [
  const _TermItem(_ItemType.paragraph, 'We may update these Terms from time to time.'),
  const _TermItem(_ItemType.paragraph,
      'Continued use of the Platform after changes indicates acceptance of the updated Terms.'),
];
