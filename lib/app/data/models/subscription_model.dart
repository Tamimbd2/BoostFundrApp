class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final int duration;
  final List<String> features;
  final bool isActive;
  final double successFee;
  final String approvalTime;
  final String description;
  final String badge;
  final String subtitle;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
    required this.isActive,
    required this.successFee,
    required this.approvalTime,
    required this.description,
    required this.badge,
    required this.subtitle,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    double parsedPrice = 0.0;
    final priceRaw = json['price'] ?? json['amount'] ?? json['packagePrice'] ?? 0;
    if (priceRaw is num) {
      parsedPrice = priceRaw.toDouble();
    } else if (priceRaw is String) {
      parsedPrice = double.tryParse(priceRaw) ?? 0.0;
    }

    int parsedDuration = 0;
    final durRaw = json['duration'] ?? json['validity'] ?? json['validityDays'] ?? json['durationInDays'] ?? 0;
    if (durRaw is num) {
      parsedDuration = durRaw.toInt();
    } else if (durRaw is String) {
      parsedDuration = int.tryParse(durRaw) ?? 0;
    }

    List<String> parsedFeatures = [];
    final featRaw = json['features'] ?? json['benefits'] ?? json['packageFeatures'] ?? json['description'];
    if (featRaw is List) {
      parsedFeatures = featRaw.map((e) => e.toString()).toList();
    } else if (featRaw is String && json['description'] == null) {
      parsedFeatures = [featRaw];
    }

    final nameStr = (json['name'] ?? json['title'] ?? json['packageName'] ?? '').toString();
    final nameLower = nameStr.toLowerCase();

    double parsedSuccessFee = 0.0;
    final feeRaw = json['successFee'] ?? json['percentageFee'] ?? json['feePercentage'] ?? json['fee'] ?? json['percentage'] ?? parsedPrice;
    if (feeRaw is num) {
      parsedSuccessFee = feeRaw.toDouble();
    } else if (feeRaw is String) {
      parsedSuccessFee = double.tryParse(feeRaw) ?? parsedPrice;
    }

    String badge = (json['badge'] ?? json['tag'] ?? json['label'] ?? '').toString();
    String subtitle = (json['subtitle'] ?? json['sub'] ?? json['listingType'] ?? '').toString();
    String description = (json['desc'] ?? json['summary'] ?? json['shortDescription'] ?? json['description'] ?? '').toString();
    String approvalTime = (json['approvalTime'] ?? json['approval'] ?? json['turnaroundTime'] ?? '').toString();

    if (nameLower.contains('vc') || nameLower.contains('elite') || nameLower.contains('dashboard') || parsedSuccessFee >= 3) {
      if (badge.isEmpty) badge = 'VC ELITE';
      if (subtitle.isEmpty) subtitle = 'VC ELITE LISTING';
      if (description.isEmpty || description == nameStr) description = 'Top tier package for institutional exposure and analytics.';
      if (approvalTime.isEmpty) approvalTime = '12 hours';
      parsedSuccessFee = 3;
    } else if (nameLower.contains('front') || nameLower.contains('premium') || parsedSuccessFee == 2) {
      if (badge.isEmpty) badge = 'FRONT PAGE';
      if (subtitle.isEmpty) subtitle = 'PREMIUM LISTING';
      if (description.isEmpty || description == nameStr) description = 'Featured placement with matched investor promotion.';
      if (approvalTime.isEmpty) approvalTime = '48 hours';
      parsedSuccessFee = 2;
    } else if (nameLower.contains('feed') || nameLower.contains('investor') || parsedSuccessFee == 1) {
      if (badge.isEmpty) badge = 'INVESTOR FEED';
      if (subtitle.isEmpty) subtitle = 'STANDARD LISTING';
      if (description.isEmpty || description == nameStr) description = 'Listed in the investor feed with broad visibility.';
      if (approvalTime.isEmpty) approvalTime = '72 hours';
      parsedSuccessFee = 1;
    } else {
      if (badge.isEmpty) badge = 'FREE';
      if (subtitle.isEmpty) subtitle = 'FOUNDER PROFILE';
      if (description.isEmpty || description == nameStr) description = 'Basic startup listing for founders starting their journey.';
      parsedSuccessFee = 0;
    }

    if (parsedFeatures.isEmpty) {
      if (parsedSuccessFee == 0) {
        parsedFeatures = [
          'Basic startup listing',
          'Limited visibility',
          'Founder dashboard access',
          'Basic investor visibility',
        ];
      } else if (parsedSuccessFee == 1) {
        parsedFeatures = [
          'Listed in investor feed',
          'Visible to all investors',
          'Startup profile page',
          'Funding goal display',
          'Founder dashboard access',
        ];
      } else if (parsedSuccessFee == 2) {
        parsedFeatures = [
          'Everything in Investor Feed',
          'Featured on homepage',
          'Suggested to matched investors',
          'Highlighted deal badge',
          'Social media promotion',
        ];
      } else if (parsedSuccessFee == 3) {
        parsedFeatures = [
          'Everything in Front Page',
          'Visible in VC dashboard',
          'Institutional investor access',
          'VC Ready badge',
          'Document vault',
        ];
      }
    }

    return SubscriptionPlan(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: nameStr,
      price: parsedPrice,
      duration: parsedDuration,
      features: parsedFeatures,
      isActive: json['isActive'] ?? json['status'] == 'active' ?? true,
      successFee: parsedSuccessFee,
      approvalTime: approvalTime,
      description: description,
      badge: badge,
      subtitle: subtitle,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'price': price,
      'duration': duration,
      'features': features,
      'isActive': isActive,
      'successFee': successFee,
      'approvalTime': approvalTime,
      'description': description,
      'badge': badge,
      'subtitle': subtitle,
    };
  }
}
