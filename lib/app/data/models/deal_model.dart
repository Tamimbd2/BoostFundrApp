class DealModel {
  String? id;
  String? startupName;
  String? shortPitch;
  String? category;
  String? stage;
  dynamic media;
  String? status;
  String? createdAt;

  DealModel({
    this.id,
    this.startupName,
    this.shortPitch,
    this.category,
    this.stage,
    this.media,
    this.status,
    this.createdAt,
  });

  DealModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    startupName = json['startupName'];
    shortPitch = json['shortPitch'];
    category = json['category'];
    stage = json['stage'];
    media = json['media'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['startupName'] = startupName;
    data['shortPitch'] = shortPitch;
    data['category'] = category;
    data['stage'] = stage;
    data['media'] = media;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }

  String? get imageUrl {
    if (media == null) return null;
    if (media is String) return media;
    if (media is List && media.isNotEmpty) return media[0];
    return null;
  }
}
