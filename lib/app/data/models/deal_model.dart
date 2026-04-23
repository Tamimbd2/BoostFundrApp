class DealModel {
  String? id;
  String? startupName;
  String? shortPitch;
  String? category;
  String? stage;
  dynamic media;
  String? status;
  String? createdAt;
  int? profileCompletionScore;
  String? founderId;

  // Raised funding data from nested 'raised' object in API
  double? raisedAmount;
  double? raisedGoal;
  double? raisedProgress;
  String? raisedCurrency;

  DealModel({
    this.id,
    this.startupName,
    this.shortPitch,
    this.category,
    this.stage,
    this.media,
    this.status,
    this.createdAt,
    this.profileCompletionScore,
    this.raisedAmount,
    this.raisedGoal,
    this.raisedProgress,
    this.raisedCurrency,
  });

  DealModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    startupName = json['startupName'];
    shortPitch = json['shortPitch'];
    category = json['category'];
    stage = json['stage'];
    media = json['media'];
    status = json['status'];
    createdAt = json['createdAt'];
    profileCompletionScore = (json['profileCompletionScore'] as num?)?.toInt();
    founderId = json['founderId'];

    // Parse nested 'raised' object
    if (json['raised'] != null) {
      final raised = json['raised'];
      raisedAmount = (raised['amount'] ?? 0).toDouble();
      raisedGoal = (raised['goal'] ?? 0).toDouble();
      raisedProgress = (raised['progress'] ?? 0).toDouble();
      raisedCurrency = raised['currency'] ?? 'AED';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'startupName': startupName,
      'shortPitch': shortPitch,
      'category': category,
      'stage': stage,
      'media': media,
      'status': status,
      'createdAt': createdAt,
    };
  }

  String? get imageUrl {
    if (media == null) return null;
    if (media is String) return media as String;
    if (media is List && (media as List).isNotEmpty)
      return (media as List)[0] as String?;
    return null;
  }
}
