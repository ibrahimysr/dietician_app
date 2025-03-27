class DietPlan {
  final int id;
  final int clientId;
  final int dietitianId;
  final String title;
  final String startDate;
  final String endDate;
  final int dailyCalories;
  final String notes;
  final String status;
  final bool isOngoing;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  DietPlan({
    required this.id,
    required this.clientId,
    required this.dietitianId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.dailyCalories,
    required this.notes,
    required this.status,
    required this.isOngoing,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory DietPlan.fromJson(Map<String, dynamic> json) {
    return DietPlan(
      id: json['id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      dietitianId: json['dietitian_id'] ?? 0,
      title: json['title'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      dailyCalories: json['daily_calories'] ?? 0,
      notes: json['notes'] ?? '',
      status: json['status'] ?? '',
      isOngoing: json['is_ongoing'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'dietitian_id': dietitianId,
      'title': title,
      'start_date': startDate,
      'end_date': endDate,
      'daily_calories': dailyCalories,
      'notes': notes,
      'status': status,
      'is_ongoing': isOngoing,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}