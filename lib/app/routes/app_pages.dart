import 'package:get/get.dart';

import '../modules/BankDetails/bindings/bank_details_binding.dart';
import '../modules/BankDetails/views/bank_details_view.dart';
import '../modules/ContactUS/bindings/contact_u_s_binding.dart';
import '../modules/ContactUS/views/contact_u_s_view.dart';
import '../modules/Currency/bindings/currency_binding.dart';
import '../modules/Currency/views/currency_view.dart';
import '../modules/InterestedInvestor/bindings/interested_investor_binding.dart';
import '../modules/InterestedInvestor/views/interested_investor_view.dart';
import '../modules/MyCampaign/bindings/my_campaign_binding.dart';
import '../modules/MyCampaign/views/my_campaign_view.dart';
import '../modules/PlatformGuidlines/bindings/platform_guidlines_binding.dart';
import '../modules/PlatformGuidlines/views/platform_guidlines_view.dart';
import '../modules/PrivacyPolicy/bindings/privacy_policy_binding.dart';
import '../modules/PrivacyPolicy/views/privacy_policy_view.dart';
import '../modules/SaveCampaign/bindings/save_campaign_binding.dart';
import '../modules/SaveCampaign/views/save_campaign_view.dart';
import '../modules/Setting/bindings/setting_binding.dart';
import '../modules/Setting/views/setting_view.dart';
import '../modules/UploadedDocument/bindings/uploaded_document_binding.dart';
import '../modules/UploadedDocument/views/uploaded_document_view.dart';
import '../modules/Verifications/bindings/verifications_binding.dart';
import '../modules/Verifications/views/verifications_view.dart';
import '../modules/Wallet/bindings/wallet_binding.dart';
import '../modules/Wallet/views/wallet_view.dart';
import '../modules/cardDetails/bindings/card_details_binding.dart';
import '../modules/cardDetails/views/card_details_view.dart';
import '../modules/create_campaign/bindings/create_campaign_binding.dart';
import '../modules/create_campaign/views/create_campaign_view.dart';
import '../modules/editProfile/bindings/edit_profile_binding.dart';
import '../modules/editProfile/views/edit_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/mydealdetails/bindings/mydealdetails_binding.dart';
import '../modules/mydealdetails/views/mydealdetails_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register_role/bindings/register_role_binding.dart';
import '../modules/register_role/views/register_role_view.dart';
import '../modules/selectLanguage/bindings/select_language_binding.dart';
import '../modules/selectLanguage/views/select_language_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/subscriptions/bindings/subscriptions_binding.dart';
import '../modules/subscriptions/views/subscriptions_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_LANGUAGE,
      page: () => const SelectLanguageView(),
      binding: SelectLanguageBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_ROLE,
      page: () => const RegisterRoleView(),
      binding: RegisterRoleBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_CAMPAIGN,
      page: () => const CreateCampaignView(),
      binding: CreateCampaignBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.MY_CAMPAIGN,
      page: () => const MyCampaignView(),
      binding: MyCampaignBinding(),
    ),
    GetPage(
      name: _Paths.INTERESTED_INVESTOR,
      page: () => const InterestedInvestorView(),
      binding: InterestedInvestorBinding(),
    ),
    GetPage(
      name: _Paths.SAVE_CAMPAIGN,
      page: () => const SaveCampaignView(),
      binding: SaveCampaignBinding(),
    ),
    GetPage(
      name: _Paths.UPLOADED_DOCUMENT,
      page: () => const UploadedDocumentView(),
      binding: UploadedDocumentBinding(),
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: _Paths.BANK_DETAILS,
      page: () => const BankDetailsView(),
      binding: BankDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CURRENCY,
      page: () => const CurrencyView(),
      binding: CurrencyBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT_U_S,
      page: () => const ContactUSView(),
      binding: ContactUSBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: _Paths.PLATFORM_GUIDLINES,
      page: () => const PlatformGuidlinesView(),
      binding: PlatformGuidlinesBinding(),
    ),
    GetPage(
      name: _Paths.CARD_DETAILS,
      page: () => const CardDetailsView(),
      binding: CardDetailsBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTIONS,
      page: () => const SubscriptionsView(),
      binding: SubscriptionsBinding(),
    ),
    GetPage(
      name: _Paths.VERIFICATIONS,
      page: () => const VerificationsView(),
      binding: VerificationsBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.MYDEALDETAILS,
      page: () => const MydealdetailsView(),
      binding: MydealdetailsBinding(),
    ),
  ];
}
