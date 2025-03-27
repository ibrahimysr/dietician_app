class Progress {
  final int id;
  final int clientId;
  final String date;
  final String weight;
  final String waist;
  final String arm;
  final String chest;
  final String hip;
  final String bodyFatPercentage;
  final String notes;
  final String photoUrl;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Progress({
    required this.id,
    required this.clientId,
    required this.date,
    required this.weight,
    required this.waist,
    required this.arm,
    required this.chest,
    required this.hip,
    required this.bodyFatPercentage,
    required this.notes,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      date: json['date'] ?? '',
      weight: json['weight'] ?? '',
      waist: json['waist'] ?? '',
      arm: json['arm'] ?? '',
      chest: json['chest'] ?? '',
      hip: json['hip'] ?? '',
      bodyFatPercentage: json['body_fat_percentage'] ?? '',
      notes: json['notes'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'date': date,
      'weight': weight,
      'waist': waist,
      'arm': arm,
      'chest': chest,
      'hip': hip,
      'body_fat_percentage': bodyFatPercentage,
      'notes': notes,
      'photo_url': photoUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}