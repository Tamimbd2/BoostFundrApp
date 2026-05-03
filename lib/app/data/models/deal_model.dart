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
  });

  DealModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    startupName = json['startupName'];
    startupLogo = json['startupLogo'];
    shortPitch = json['shortPitch'];
    category = json['category'];
    stage = json['stage'];
    media = json['media'];
    status = json['status'];
    createdAt = json['createdAt'];
    deadline = json['deadline'];
    profileCompletionScore = (json['profileCompletionScore'] as num?)?.toInt();
    founderId = json['founderId'];

    // Map top-level raised fields if present (new API structure)
    if (json['raisedAmount'] != null) {
      raisedAmount = (json['raisedAmount'] as num).toDouble();
    }
    if (json['goalAmount'] != null) {
      raisedGoal = (json['goalAmount'] as num).toDouble();
    }

    // Parse nested 'raised' object (fallback for other endpoints)
    if (json['raised'] != null) {
      final raised = json['raised'];
      raisedAmount = (raised['amount'] ?? raisedAmount ?? 0).toDouble();
      raisedGoal = (raised['goal'] ?? raisedGoal ?? 0).toDouble();
      raisedProgress = (raised['progress'] ?? 0).toDouble();
      raisedCurrency = raised['currency'] ?? 'AED';
    }

    // Calculate progress if not provided
    if (raisedProgress == null || raisedProgress == 0) {
      if (raisedGoal != null && raisedGoal! > 0) {
        raisedProgress = ((raisedAmount ?? 0) / raisedGoal!) * 100;
      }
    }
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
    };
  }

  String? get imageUrl {
    if (startupLogo != null && startupLogo!.isNotEmpty) return startupLogo;
    if (media == null) return null;
    if (media is String) return media as String;
    if (media is List && (media as List).isNotEmpty)
      return (media as List)[0] as String?;
    return null;
  }
}
