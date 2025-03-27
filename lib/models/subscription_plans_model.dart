class SubscriptionPlansModel { 
  final int id; 
  final int dietitianId; 
  final String name;
  final String description; 
  final int duration; 
  final String price; 
  final List features; 
  final String status; 
  final String createdAt;
  final String updatedAt; 

  SubscriptionPlansModel({
    required this.id,
    required this.dietitianId,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.features,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionPlansModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlansModel(
      id: json['id'] ?? 0,
      dietitianId: json['dietitian_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      price: json['price'] ?? '',
      features: json['features'] ?? [],
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  } 

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dietitian_id': dietitianId,
      'name': name,
      'description': description,
      'duration': duration,
      'price': price,
      'features': features,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

}