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
        data!.add(new Progress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['date'] = this.date;
    data['weight'] = this.weight;
    data['waist'] = this.waist;
    data['arm'] = this.arm;
    data['chest'] = this.chest;
    data['hip'] = this.hip;
    data['body_fat_percentage'] = this.bodyFatPercentage;
    data['notes'] = this.notes;
    data['photo_url'] = this.photoUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    
    return data;
  }
}
