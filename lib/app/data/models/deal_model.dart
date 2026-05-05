class DealModel {
  String? id;
  String? startupName;
  String? startupLogo;
  String? shortPitch;
  String? category;
  String? stage;
  dynamic media;
  String? status;
  String? createdAt;
  String? deadline;
  int? profileCompletionScore;
  String? founderId;

  // Raised funding data
  double? raisedAmount;
  double? raisedGoal;
  double? raisedProgress;
  String? raisedCurrency;
  bool? isBookmarked;
  bool? isVerified;

  DealModel({
    this.id,
    this.startupName,
    this.startupLogo,
    this.shortPitch,
    this.category,
    this.stage,
    this.media,
    this.status,
    this.createdAt,
    this.deadline,
    this.profileCompletionScore,
    this.raisedAmount,
    this.raisedGoal,
    this.raisedProgress,
    this.raisedCurrency,
    this.problem,
    this.solution,
    this.businessModel,
    this.targetMarket,
    this.whyNow,
    this.traction,
    this.goToMarket,
    this.topCompetitor,
    this.advantage,
    this.team,
    this.useOfFunds,
    this.qa,
    this.users,
    this.growthRate,
    this.CAC,
    this.LTV,
    this.CHURN,
    this.whatsappNumber,
    this.tagline,
    this.location,
    this.revenue,
    this.currentStep,
    this.startupWebsite,
    this.isVerified,
  });

  // Story
  String? problem;
  String? solution;
  String? businessModel;
  String? targetMarket;
  String? whyNow;

  // Execution
  String? traction;
  String? goToMarket;
  String? topCompetitor;
  String? advantage;
  List<dynamic>? team;
  List<dynamic>? useOfFunds;
  List<dynamic>? qa;

  // SaaS / Growth
  int? users;
  int? growthRate;
  String? CAC;
  String? LTV;
  String? CHURN;

  // Contact
  String? whatsappNumber;
  String? startupWebsite;
  String? tagline;
  String? location;

  // Additional fields
  dynamic revenue;
  int? currentStep;

  DealModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];

    // Parse nested structures if present
    final basic = json['basicInfo'] ?? {};
    final story = json['story'] ?? {};
    final funding = json['funding'] ?? {};
    final execution = json['execution'] ?? {};

    startupName = basic['startupName'] ?? json['startupName'];
    startupLogo = basic['startupLogo'] ?? json['startupLogo'];
    tagline = basic['tagline'] ?? json['tagline'];
    category = basic['category'] ?? json['category'];
    stage = basic['stage'] ?? json['stage'];
    location = basic['location'] ?? json['location'];

    shortPitch = story['shortPitch'] ?? json['shortPitch'];
    problem = story['problem'] ?? json['problem'];
    solution = story['solution'] ?? json['solution'];
    targetMarket = story['targetMarket'] ?? json['targetMarket'];
    whyNow = story['whyNow'] ?? json['whyNow'];

    traction = execution['traction'] ?? json['traction'];
    businessModel = execution['businessModel'] ?? json['businessModel'];
    goToMarket = execution['goToMarket'] ?? json['goToMarket'];
    topCompetitor = execution['topCompetitor'] ?? json['topCompetitor'];
    advantage = execution['advantage'] ?? json['advantage'];
    team = execution['team'] ?? json['team'];
    useOfFunds = execution['useOfFunds'] ?? json['useOfFunds'];
    qa = execution['qa'] ?? json['qa'];
    revenue = execution['revenue'] ?? json['revenue'];

    users = (funding['users'] as num?)?.toInt() ?? (json['users'] as num?)?.toInt();
    growthRate = (funding['growthRate'] as num?)?.toInt() ?? (json['growthRate'] as num?)?.toInt();
    CAC = (funding['CAC'] ?? json['CAC'])?.toString();
    LTV = (funding['LTV'] ?? json['LTV'])?.toString();
    CHURN = (funding['CHURN'] ?? json['CHURN'])?.toString();

    whatsappNumber = basic['whatsappNumber'] ?? json['whatsappNumber'];
    startupWebsite = basic['startupWebsite'] ?? json['startupWebsite'];

    status = json['status'];
    createdAt = json['createdAt'];
    deadline = funding['deadline'] ?? json['deadline'];
    profileCompletionScore = (json['profileCompletionScore'] as num?)?.toInt();
    currentStep = (json['currentStep'] as num?)?.toInt();
    founderId = json['founderId'];

    // Verification
    final badge = json['verificationBadge'];
    if (badge != null && badge is Map) {
      isVerified = badge['isVerified'] == true;
    } else {
      isVerified = json['isVerified'] == true;
    }

    // Map funding data
    raisedAmount = (funding['raisedAmount'] as num?)?.toDouble() ?? (json['raisedAmount'] as num?)?.toDouble();
    raisedGoal = (funding['goalAmount'] as num?)?.toDouble() ?? (json['goalAmount'] as num?)?.toDouble();

    if (json['raised'] != null) {
      final raised = json['raised'];
      raisedAmount = (raised['amount'] ?? raisedAmount ?? 0).toDouble();
      raisedGoal = (raised['goal'] ?? raisedGoal ?? 0).toDouble();
      raisedProgress = (raised['progress'] ?? 0).toDouble();
      raisedCurrency = raised['currency'] ?? 'AED';
    }

    if (raisedProgress == null || raisedProgress == 0) {
      if (raisedGoal != null && raisedGoal! > 0) {
        raisedProgress = ((raisedAmount ?? 0) / raisedGoal!) * 100;
      }
    }

    isBookmarked = json['isBookmarked'] ?? false;
    media = json['media'] ?? basic['startupLogo'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'startupName': startupName,
      'startupLogo': startupLogo,
      'shortPitch': shortPitch,
      'category': category,
      'stage': stage,
      'media': media,
      'status': status,
      'createdAt': createdAt,
      'deadline': deadline,
      'problem': problem,
      'solution': solution,
      'businessModel': businessModel,
      'targetMarket': targetMarket,
      'whyNow': whyNow,
      'traction': traction,
      'goToMarket': goToMarket,
      'topCompetitor': topCompetitor,
      'advantage': advantage,
      'team': team,
      'useOfFunds': useOfFunds,
      'qa': qa,
      'users': users,
      'growthRate': growthRate,
      'CAC': CAC,
      'LTV': LTV,
      'CHURN': CHURN,
      'revenue': revenue,
      'currentStep': currentStep,
      'goalAmount': raisedGoal,
      'raisedAmount': raisedAmount,
      'raisedProgress': raisedProgress,
      'raisedCurrency': raisedCurrency,
      'whatsappNumber': whatsappNumber,
      'startupWebsite': startupWebsite,
      'location': location,
      'tagline': tagline,
      'profileCompletionScore': profileCompletionScore,
      'isVerified': isVerified,
    };
  }

  String? get imageUrl {
    if (startupLogo != null && startupLogo!.isNotEmpty) return startupLogo;
    if (media == null) return null;
    if (media is String) return media as String;
    if (media is List && (media as List).isNotEmpty) return (media as List)[0] as String?;
    return null;
  }
}
