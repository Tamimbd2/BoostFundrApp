import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/deal_model.dart';

class CardDetailsController extends GetxController {
  final _storage = GetStorage();

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
    _loadUserPlan();

    final args = Get.arguments;
    if (args is DealModel) {
      // Pre-populate with existing data
      dealData.value = args.toJson();
      // Also manually map some fields that toJson might miss if we want full fidelity
      // but DealModel should be enough for initial view.
      isLoading.value = false;
    }

    fetchDealDetail();
  }

  Future<void> fetchDealDetail() async {
    try {
      // If we already have data from arguments, don't show full screen loader
      if (dealData.value == null) {
        isLoading.value = true;
      }
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
          debugPrint(
            '[CardDetails] Data keys: ${dealData.value?.keys.toList()}',
          );
          if (dealData.value?['execution'] != null) {
            debugPrint(
              '[CardDetails] Execution keys: ${(dealData.value?['execution'] as Map).keys.toList()}',
            );
          }
          if (dealData.value?['funding'] != null) {
            debugPrint(
              '[CardDetails] Funding keys: ${(dealData.value?['funding'] as Map).keys.toList()}',
            );
          }

          // Dynamically update access level from API response if provided
          // Check various possible keys: accessLevel, plan, userPlan, etc.
          final apiAccessLevel = json['accessLevel'] ?? 
                                json['data']?['accessLevel'] ?? 
                                json['plan'] ?? 
                                json['data']?['plan'] ??
                                json['data']?['user']?['plan'] ??
                                json['data']?['user']?['accessLevel'];

          if (apiAccessLevel != null) {
            userPlan.value = apiAccessLevel.toString();
            debugPrint(
              '[CardDetails] Access level updated from API: ${userPlan.value}',
            );
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

  String get shortPitch {
    final data = dealData.value;
    if (data == null) return '—';
    return data['story']?['shortPitch'] ?? data['shortPitch'] ?? '—';
  }

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

  String get tagline {
    final data = dealData.value;
    if (data == null) return '—';
    return data['basicInfo']?['tagline'] ?? data['tagline'] ?? '—';
  }

  String get currency =>
      dealData.value?['funding']?['currency'] ??
      dealData.value?['currency'] ??
      'AED';

  int get goalAmount {
    final data = dealData.value;
    if (data == null) return 0;
    final funding = data['funding'];
    if (funding != null && funding['goalAmount'] != null) {
      return (funding['goalAmount'] as num).toInt();
    }
    if (data['raised'] != null && data['raised']['goal'] != null) {
      return (data['raised']['goal'] as num).toInt();
    }
    return (data['goalAmount'] as num?)?.toInt() ??
        (data['raisedGoal'] as num?)?.toInt() ??
        0;
  }

  int get raisedAmount {
    final data = dealData.value;
    if (data == null) return 0;
    final funding = data['funding'];
    if (funding != null && funding['raisedAmount'] != null) {
      return (funding['raisedAmount'] as num).toInt();
    }
    if (data['raised'] != null && data['raised']['amount'] != null) {
      return (data['raised']['amount'] as num).toInt();
    }
    return (data['raisedAmount'] as num?)?.toInt() ?? 0;
  }

  double get raisedProgress {
    final data = dealData.value;
    if (data == null) return 0.0;
    final funding = data['funding'];
    if (funding != null && funding['progress'] != null) {
      return (funding['progress'] as num).toDouble() / 100.0;
    }
    if (data['raised'] != null && data['raised']['progress'] != null) {
      return (data['raised']['progress'] as num).toDouble() / 100.0;
    }
    // Fallback to manual calculation
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

  bool get isVerified {
    final data = dealData.value;
    if (data == null) return false;
    
    // Check nested object first
    final badge = data['verificationBadge'];
    if (badge != null && badge is Map) {
      if (badge['isVerified'] == true) return true;
    }
    
    // Check top level fallback
    return data['isVerified'] == true;
  }

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

  List<Map<String, String>> get faqList {
    final data = dealData.value;
    if (data == null) return [];
    if (data['execution']?['qa'] != null && data['execution']['qa'] is List) {
      return (data['execution']['qa'] as List)
          .map((e) {
            if (e is Map) {
              return {
                'question': e['question']?.toString() ?? '',
                'answer': e['answer']?.toString() ?? '',
              };
            }
            return <String, String>{};
          })
          .where((m) => m['question'] != null && m['question']!.isNotEmpty)
          .toList();
    }
    if (data['faq'] != null && data['faq'] is List) {
      return (data['faq'] as List).map((e) {
        if (e is Map) {
          return {
            'question': e['question']?.toString() ?? '',
            'answer': e['answer']?.toString() ?? '',
          };
        }
        return {
          'question': e.toString(),
          'answer': '',
        };
      }).where((m) => m['question']!.isNotEmpty).toList();
    }
    return [];
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
    // Check both accessLevel and plan in the stored user object
    userPlan.value = user?['accessLevel'] ?? user?['plan'] ?? 'free';
  }

  bool isFieldLocked(String fieldName) {
    // 👑 ELITE PLAN: Never lock anything
    final level = userAccessLevel.toLowerCase();
    if (level == 'elite') return false;

    // 🔥 Founder always has full access to their deals
    final user = _storage.read('user');
    if (user != null && user['role'] == 'founder') {
      return false;
    }

    // 🚀 Check for explicit "permissions" object from API
    final data = dealData.value;
    if (data != null && data['permissions'] != null) {
      final permissions = data['permissions'] as Map;
      
      switch (fieldName) {
        case 'businessModel':
        case 'traction':
        case 'useOfFunds':
        case 'team':
          if (permissions['execution'] == true) return false;
          break;
        case 'market':
        case 'founderDetails':
        case 'problem':
        case 'solution':
          if (permissions['story'] == true) return false;
          break;
        case 'goalAmount':
        case 'raisedAmount':
        case 'deadline':
          if (permissions['funding'] == true) return false;
          break;
        case 'privateDocuments':
          if (permissions['documents'] == true) return false;
          break;
        case 'startupName':
        case 'location':
        case 'category':
          if (permissions['basic'] == true) return false;
          break;
      }
    }

    // 🚀 FALLBACK: If the data is actually present in the response, don't lock it
    // if (data != null) {
    //   // Note: We might want to keep some fields locked even if data exists
    //   // depending on strictness. But per user request: "elite thakle all open"
    // }

    final proFields = [
      'businessModel',
      'market',
      'geography',
      'founderDetails',
      'team',
      'traction',
      'useOfFunds',
    ];
    final eliteFields = ['tractionHighlights', 'privateDocuments'];

    if (level == 'pro') {
      // Pro users can see proFields, but not eliteFields
      return eliteFields.contains(fieldName);
    }

    // Free users: Lock everything that is Pro or Elite
    return proFields.contains(fieldName) || eliteFields.contains(fieldName);
  }

  String getTargetLevelForField(String fieldName) {
    final eliteFields = ['tractionHighlights', 'privateDocuments'];
    if (eliteFields.contains(fieldName)) return 'Elite';
    return 'Pro';
  }

  // ── Additional Fields ─────────────────────────────────────
  String get businessModel =>
      dealData.value?['execution']?['businessModel'] ??
      dealData.value?['businessModel'] ??
      '—';
  String get market {
    final data = dealData.value;
    if (data == null) return '—';
    return data['story']?['targetMarket'] ??
        data['targetMarket'] ??
        data['market'] ??
        '—';
  }

  String get geography =>
      dealData.value?['basicInfo']?['location'] ??
      dealData.value?['geography'] ??
      '—';
  String get founderDetails =>
      dealData.value?['story']?['whyNow'] ??
      dealData.value?['founderDetails'] ??
      '—';
  String get team {
    final data = dealData.value;
    if (data == null) return '—';
    final execution = data['execution'];
    if (execution != null &&
        execution['team'] is List &&
        (execution['team'] as List).isNotEmpty) {
      final lead = (execution['team'] as List)[0];
      return '${lead['name']} (${lead['role']})';
    }
    return data['team']?.toString() ?? '—';
  }

  String get traction =>
      dealData.value?['execution']?['traction'] ??
      dealData.value?['traction'] ??
      '—';
  String get useOfFunds {
    final data = dealData.value;
    if (data == null) return '—';
    final execution = data['execution'];
    if (execution != null &&
        execution['useOfFunds'] is List &&
        (execution['useOfFunds'] as List).isNotEmpty) {
      final use = (execution['useOfFunds'] as List)[0];
      return '${use['category']}: ${use['percentage']}%';
    }
    return data['useOfFunds']?.toString() ?? '—';
  }

  List<dynamic> get privateDocuments => dealData.value?['documents'] != null
      ? (dealData.value?['documents'] as Map).values.toList()
      : [];
}
