import 'package:get/get.dart';
import '../../../data/models/deal_model.dart';

class MydealdetailsController extends GetxController {

  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final dealData = Rxn<Map<String, dynamic>>();

  String get dealId {
    final args = Get.arguments;
    if (args is String) return args;
    if (args is DealModel) return args.id ?? '';
    return '';
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is DealModel) {
      dealData.value = args.toJson();
      isLoading.value = false;
    }
  }

  // ── Getters ───────────────────────────────────────────────
  String get startupName =>
      dealData.value?['basicInfo']?['startupName'] ??
      dealData.value?['startupName'] ??
      '—';
  String get tagline =>
      dealData.value?['basicInfo']?['tagline'] ??
      dealData.value?['tagline'] ??
      '—';
  String get category =>
      dealData.value?['basicInfo']?['category'] ??
      dealData.value?['category'] ??
      '—';
  String get stage =>
      dealData.value?['basicInfo']?['stage'] ?? dealData.value?['stage'] ?? '—';
  String get location =>
      dealData.value?['basicInfo']?['location'] ??
      dealData.value?['location'] ??
      '—';
  String get status => dealData.value?['status'] ?? '—';
  int get profileScore =>
      (dealData.value?['profileCompletionScore'] as num?)?.toInt() ?? 0;

  String get problem =>
      dealData.value?['story']?['problem'] ?? dealData.value?['problem'] ?? '—';
  String get solution =>
      dealData.value?['story']?['solution'] ??
      dealData.value?['solution'] ??
      '—';
  String get market =>
      dealData.value?['story']?['targetMarket'] ??
      dealData.value?['targetMarket'] ??
      '—';
  String get founderDetails =>
      dealData.value?['story']?['whyNow'] ??
      dealData.value?['founderDetails'] ??
      '—';

  String get businessModel =>
      dealData.value?['execution']?['businessModel'] ??
      dealData.value?['businessModel'] ??
      '—';
  String get traction =>
      dealData.value?['execution']?['traction'] ??
      dealData.value?['traction'] ??
      '—';
  String get revenue =>
      (dealData.value?['execution']?['revenue'] ??
              dealData.value?['revenue'] ??
              '0')
          .toString();
  String get goToMarket =>
      dealData.value?['execution']?['goToMarket'] ??
      dealData.value?['goToMarket'] ??
      '—';
  String get topCompetitor =>
      dealData.value?['execution']?['topCompetitor'] ??
      dealData.value?['topCompetitor'] ??
      '—';
  String get advantage =>
      dealData.value?['execution']?['advantage'] ??
      dealData.value?['advantage'] ??
      '—';

  // Metrics
  String get users =>
      (dealData.value?['funding']?['users'] ?? dealData.value?['users'] ?? '0')
          .toString();
  String get growthRate =>
      (dealData.value?['funding']?['growthRate'] ??
              dealData.value?['growthRate'] ??
              '0')
          .toString();
  String get cac =>
      dealData.value?['funding']?['CAC'] ?? dealData.value?['CAC'] ?? '—';
  String get ltv =>
      dealData.value?['funding']?['LTV'] ?? dealData.value?['LTV'] ?? '—';
  String get churn =>
      dealData.value?['funding']?['CHURN'] ?? dealData.value?['CHURN'] ?? '—';
  int get minimumInvestment =>
      (dealData.value?['funding']?['minimumInvestment'] ??
              dealData.value?['minimumInvestment'] ??
              0)
          .toInt();

  // Funding
  int get goalAmount =>
      (dealData.value?['funding']?['goalAmount'] ??
              dealData.value?['goalAmount'] ??
              0)
          .toInt();
  int get raisedAmount =>
      (dealData.value?['funding']?['raisedAmount'] ??
              dealData.value?['raisedAmount'] ??
              0)
          .toInt();
  String get currency =>
      dealData.value?['funding']?['currency'] ??
      dealData.value?['currency'] ??
      'AED';

  double get raisedProgress {
    if (goalAmount <= 0) return 0.0;
    return (raisedAmount / goalAmount).clamp(0.0, 1.0);
  }

  String get deadline =>
      dealData.value?['funding']?['deadline'] ??
      dealData.value?['deadline'] ??
      '';
  int get daysLeft {
    if (deadline.isEmpty) return 0;
    try {
      return DateTime.parse(
        deadline,
      ).difference(DateTime.now()).inDays.clamp(0, 999);
    } catch (_) {
      return 0;
    }
  }

  // Contact
  String get whatsappNumber =>
      dealData.value?['basicInfo']?['whatsappNumber'] ??
      dealData.value?['whatsappNumber'] ??
      '';
  String get startupWebsite =>
      dealData.value?['basicInfo']?['startupWebsite'] ??
      dealData.value?['startupWebsite'] ??
      '';

  String? get headerImage {
    final basic = dealData.value?['basicInfo'];
    final logo = basic?['startupLogo'] ?? dealData.value?['startupLogo'];
    if (logo != null && logo.isNotEmpty) return logo;
    final media = dealData.value?['media'];
    if (media is List && media.isNotEmpty) return media[0].toString();
    if (media is String && media.isNotEmpty) return media;
    return null;
  }

  String get team {
    var teamData =
        dealData.value?['execution']?['team'] ?? dealData.value?['team'];
    if (teamData is List && teamData.isNotEmpty) {
      final lead = teamData[0];
      if (lead is Map) return '${lead['name']} (${lead['role']})';
      return lead.toString();
    }
    return '—';
  }

  String get useOfFunds {
    var useData =
        dealData.value?['execution']?['useOfFunds'] ??
        dealData.value?['useOfFunds'];
    if (useData is List && useData.isNotEmpty) {
      final use = useData[0];
      if (use is Map) return '${use['category']}: ${use['percentage']}%';
      return use.toString();
    }
    return '—';
  }

  List<String> get tractionHighlights =>
      (dealData.value?['tractionHighlights'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
      [];

  List<String> get faq {
    final qa = dealData.value?['execution']?['qa'] ?? dealData.value?['qa'];
    if (qa is List) {
      return qa
          .map((e) => e['question']?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return [];
  }
}
