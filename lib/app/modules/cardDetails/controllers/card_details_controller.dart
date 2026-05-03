import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CardDetailsController extends GetxController {
  final _storage = GetStorage();

  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final dealData = Rxn<Map<String, dynamic>>();

  String get dealId => Get.arguments as String? ?? '';

  @override
  void onInit() {
    super.onInit();
    _loadUserPlan();
    fetchDealDetail();
  }

  Future<void> fetchDealDetail() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final id = dealId;
      final token = _storage.read('token');

      // Debugging
      debugPrint('[CardDetails] Fetching ID: $id');
      debugPrint('[CardDetails] Token present: ${token != null}');

      if (id.isEmpty) {
        hasError.value = true;
        errorMessage.value = 'No deal ID provided';
        return;
      }

      final uri = Uri.parse(
        'https://boost-funder.onrender.com/api/v1/deals/feed/$id',
      );

      final response = await http
          .get(
            uri,
            headers: {
              if (token != null) 'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('[CardDetails] Response Status: ${response.statusCode}');
      debugPrint('[CardDetails] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['data'] != null) {
          dealData.value = Map<String, dynamic>.from(json['data']);
          
          // Dynamically update access level from API response if provided
          final apiAccessLevel = json['accessLevel'] ?? json['data']['accessLevel'];
          if (apiAccessLevel != null) {
            userPlan.value = apiAccessLevel.toString();
            debugPrint('[CardDetails] Access level updated from API: ${userPlan.value}');
          }
        } else {
          hasError.value = true;
          errorMessage.value = 'Data field is null in response';
        }
      } else {
        hasError.value = true;
        final errorJson = jsonDecode(response.body);
        errorMessage.value =
            errorJson['message'] ?? 'Error ${response.statusCode}';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Connection Error: $e';
      debugPrint('[CardDetails] Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Field helpers ─────────────────────────────────────────
  String get startupName {
    final data = dealData.value;
    if (data == null) return '—';
    return data['basicInfo']?['startupName'] ?? data['startupName'] ?? '—';
  }

  String get shortPitch => dealData.value?['shortPitch'] ?? '—';

  String get category {
    final data = dealData.value;
    if (data == null) return '—';
    return data['basicInfo']?['category'] ?? data['category'] ?? '—';
  }

  String get stage {
    final data = dealData.value;
    if (data == null) return '—';
    return data['basicInfo']?['stage'] ?? data['stage'] ?? '—';
  }

  String get status => dealData.value?['status'] ?? '—';

  String get location {
    final data = dealData.value;
    if (data == null) return '—';
    return data['basicInfo']?['location'] ?? data['location'] ?? '—';
  }

  String get problem {
    final data = dealData.value;
    if (data == null) return '—';
    return data['story']?['problem'] ?? data['problem'] ?? '—';
  }

  String get solution {
    final data = dealData.value;
    if (data == null) return '—';
    return data['story']?['solution'] ?? data['solution'] ?? '—';
  }

  String get tagline => dealData.value?['tagline'] ?? '—';
  String get currency => dealData.value?['currency'] ?? 'AED';

  int get goalAmount {
    final data = dealData.value;
    if (data == null) return 0;
    if (data['funding'] != null && data['funding']['goalAmount'] != null) {
      return (data['funding']['goalAmount'] as num).toInt();
    }
    if (data['raised'] != null && data['raised']['goal'] != null) {
      return (data['raised']['goal'] as num).toInt();
    }
    return (data['goalAmount'] as num?)?.toInt() ?? 0;
  }

  int get raisedAmount {
    final data = dealData.value;
    if (data == null) return 0;
    if (data['funding'] != null && data['funding']['raisedAmount'] != null) {
      return (data['funding']['raisedAmount'] as num).toInt();
    }
    if (data['raised'] != null && data['raised']['amount'] != null) {
      return (data['raised']['amount'] as num).toInt();
    }
    return (data['raisedAmount'] as num?)?.toInt() ?? 0;
  }

  double get raisedProgress {
    final data = dealData.value;
    if (data == null) return 0.0;
    if (data['funding'] != null && data['funding']['progress'] != null) {
      return (data['funding']['progress'] as num).toDouble() / 100.0;
    }
    if (data['raised'] != null && data['raised']['progress'] != null) {
      return (data['raised']['progress'] as num).toDouble() / 100.0;
    }
    // Fallback to manual calculation if progress field is missing
    final goal = goalAmount;
    if (goal <= 0) return 0.0;
    return (raisedAmount / goal).clamp(0.0, 1.0);
  }

  int get profileScore =>
      (dealData.value?['profileCompletionScore'] as num?)?.toInt() ?? 0;

  String get deadline {
    final data = dealData.value;
    if (data == null) return '';
    return data['funding']?['deadline'] ?? data['deadline'] ?? '';
  }

  bool get isVerified =>
      dealData.value?['verificationBadge']?['isVerified'] == true;

  List<String> get media {
    final data = dealData.value;
    if (data == null) return [];
    List<String> urls = [];
    if (data['basicInfo']?['startupLogo'] != null) {
      urls.add(data['basicInfo']['startupLogo'].toString());
    }
    if (data['media'] != null && data['media'] is List) {
      urls.addAll((data['media'] as List).map((e) => e.toString()));
    }
    return urls;
  }

  List<String> get tractionHighlights =>
      (dealData.value?['tractionHighlights'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
      [];

  List<String> get faq {
    final data = dealData.value;
    if (data == null) return [];
    if (data['execution']?['qa'] != null && data['execution']['qa'] is List) {
      return (data['execution']['qa'] as List)
          .map((e) => e['question']?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return (data['faq'] as List?)?.map((e) => e.toString()).toList() ?? [];
  }

  String get deadlineFormatted {
    if (deadline.isEmpty) return '—';
    try {
      final dt = DateTime.parse(deadline);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return '—';
    }
  }

  int get daysLeft {
    if (deadline.isEmpty) return 0;
    try {
      final dt = DateTime.parse(deadline);
      return dt.difference(DateTime.now()).inDays.clamp(0, 9999);
    } catch (_) {
      return 0;
    }
  }

  // ── Access Control ───────────────────────────────────────
  final userPlan = 'free'.obs;

  String get userAccessLevel => userPlan.value;

  void _loadUserPlan() {
    final user = _storage.read('user');
    debugPrint('[CardDetails] User data from storage: $user');
    userPlan.value = user?['accessLevel'] ?? user?['plan'] ?? 'free';
  }

  bool isFieldLocked(String fieldName) {
    // Normalize level for comparison
    final level = userAccessLevel.toLowerCase();
    
    // 🔥 Founder always has full access to their deals
    final user = _storage.read('user');
    if (user != null && user['role'] == 'founder') {
      return false;
    }
    
    if (level == 'elite') return false;

    final proFields = [
      'businessModel',
      'market',
      'geography',
      'founderDetails',
      'team',
      'traction',
      'useOfFunds'
    ];
    final eliteFields = ['tractionHighlights', 'privateDocuments'];

    if (level == 'pro') {
      // Pro users only have eliteFields locked
      return eliteFields.contains(fieldName);
    }
    
    // For free users or any other level, both pro and elite fields are locked
    return proFields.contains(fieldName) || eliteFields.contains(fieldName);
  }

  String getTargetLevelForField(String fieldName) {
    final proFields = [
      'businessModel',
      'market',
      'geography',
      'founderDetails',
      'team',
      'traction',
      'useOfFunds'
    ];
    if (proFields.contains(fieldName)) return 'Pro';
    return 'Elite';
  }

  // ── Additional Fields ─────────────────────────────────────
  String get businessModel => dealData.value?['businessModel'] ?? '—';
  String get market {
    final data = dealData.value;
    if (data == null) return '—';
    return data['story']?['targetMarket'] ?? data['market'] ?? '—';
  }

  String get geography => dealData.value?['geography'] ?? '—';
  String get founderDetails => dealData.value?['founderDetails'] ?? '—';
  String get team => dealData.value?['team'] ?? '—';
  String get traction => dealData.value?['traction'] ?? '—';
  String get useOfFunds => dealData.value?['useOfFunds'] ?? '—';
  List<dynamic> get privateDocuments =>
      dealData.value?['privateDocuments'] as List? ?? [];
}
