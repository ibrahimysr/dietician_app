class ProgressResponse {
  bool? success;
  String? message;
  List<Progress>? data;

  ProgressResponse({this.success, this.message, this.data});

  ProgressResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Progress>[];
      json['data'].forEach((v) {
        data!.add(Progress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Progress {
  int? id;
  int? clientId;
  String? date;
  String? weight;
  String? waist;
  String? arm;
  String? chest;
  String? hip;
  String? bodyFatPercentage;
  String? notes;
  String? photoUrl;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Progress(
      {this.id,
      this.clientId,
      this.date,
      this.weight,
      this.waist,
      this.arm,
      this.chest,
      this.hip,
      this.bodyFatPercentage,
      this.notes,
      this.photoUrl,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
    });

  Progress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    date = json['date'];
    weight = json['weight'];
    waist = json['waist'];
    arm = json['arm'];
    chest = json['chest'];
    hip = json['hip'];
    bodyFatPercentage = json['body_fat_percentage'];
    notes = json['notes'];
    photoUrl = json['photo_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['client_id'] = clientId;
    data['date'] = date;
    data['weight'] = weight;
    data['waist'] = waist;
    data['arm'] = arm;
    data['chest'] = chest;
    data['hip'] = hip;
    data['body_fat_percentage'] = bodyFatPercentage;
    data['notes'] = notes;
    data['photo_url'] = photoUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    
    return data;
  }
}
