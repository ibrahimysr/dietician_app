import 'package:dietician_app/core/utils/parsing.dart';

class GoalListResponse {
  final bool success;
  final String message;
  final List<Goal> data;

  GoalListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GoalListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<Goal> goalList = list != null
        ? list.map((i) => Goal.fromJson(i as Map<String, dynamic>)).toList()
        : [];
    return GoalListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: goalList,
    );
  }
}

class GoalResponse {
  final bool success;
  final String message;
  final Goal? data; 

  GoalResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory GoalResponse.fromJson(Map<String, dynamic> json) {
    return GoalResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? Goal.fromJson(json['data']) : null,
    );
  }
}


class Goal {
  final int id;
  final int clientId;
  final int? dietitianId;
  final String title;
  final String? description; 
  final double? targetValue;
  final double? currentValue;
  final String? unit;
  final String category;
  final DateTime? startDate;
  final DateTime? targetDate;
  final String status;
  final String? priority;
  final double? progressPercentage; 
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final Map<String, dynamic>? client;
  final Map<String, dynamic>? dietitian;

  Goal({
    required this.id,
    required this.clientId,
    this.dietitianId,
    required this.title,
    this.description,
    this.targetValue,
    this.currentValue,
    this.unit,
    required this.category,
    this.startDate,
    this.targetDate,
    required this.status,
    this.priority,
    this.progressPercentage,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.client,
    this.dietitian,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: parseInt(json['id']) ?? 0,
      clientId: parseInt(json['client_id']) ?? 0,
      dietitianId: parseInt(json['dietitian_id']),
      title: json['title'] ?? 'Başlıksız Hedef',
      description: json['description'],
      targetValue: parseDouble(json['target_value']),
      currentValue: parseDouble(json['current_value']),
      unit: json['unit'],
      category: json['category'] ?? 'unknown',
      startDate: parseDateTime(json['start_date']),
      targetDate: parseDateTime(json['target_date']),
      status: json['status'] ?? 'unknown',
      priority: json['priority'],
      progressPercentage: parseDouble(json['progress_percentage']),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      client: json['client'] is Map<String, dynamic> ? json['client'] : null,
      dietitian: json['dietitian'] is Map<String, dynamic> ? json['dietitian'] : null,
    );
  }

double get calculatedProgress {
  // ... (API yüzdesi kontrolü aynı) ...

  if (targetValue == null || currentValue == null) return 0.0;

  // Hedefin azaltma mı artırma mı olduğunu anlamaya çalış
  // Kesin yol: Kategoriye bakmak ('weight', 'measurement' genellikle azaltmadır)
  // Veya target < initialValue (initial yoksa zor)
  // Şimdilik basit varsayım: Eğer target < current ise azaltma olabilir
   bool isLikelyReduction = targetValue! < currentValue!;

   if (isLikelyReduction) {
      // Azaltma: Hedefe ne kadar yaklaşıldı?
      // Eğer current <= target ise %100 (1.0)
      if (currentValue! <= targetValue!) return 1.0;
      // Başlangıç değeri olmadan yüzdesel hesap zor.
      // Tersine bir mantık: Hedef değere ne kadar kaldı? (1.0 - YaklaşmaOranı)
      // Ama yaklaşma oranını bilmiyoruz.
      // Belki sadece 0.0 veya 1.0 dönebiliriz.
       return 0.0; // Veya 0.5 gibi sabit bir değer? Kafa karıştırıcı.
   } else {
      // Artırma: Mevcut / Hedef
      if (targetValue == 0) return currentValue! >= 0 ? 1.0 : 0.0; // Hedef 0 ise
      return (currentValue! / targetValue!).clamp(0.0, 1.0);
   }
}
}