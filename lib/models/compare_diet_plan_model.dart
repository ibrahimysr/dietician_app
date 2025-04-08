

T? _parseNum<T extends num>(dynamic value) {
  if (value == null) return null;
  if (value is T) return value;
  if (value is String) {
    if (T == double) return double.tryParse(value) as T?;
    if (T == int) return int.tryParse(value) as T?;
  }
  if (value is num) {
     if (T == double) return value.toDouble() as T?;
     if (T == int) return value.toInt() as T?;
  }
  return null;
}

double? _parseDouble(dynamic value) {
   if (value == null) return null;
   if (value is double) return value;
   if (value is int) return value.toDouble();
   if (value is String) return double.tryParse(value);
   return null;
}


class DietComparisonResponse {
  final bool success;
  final String message;
  final DietComparisonData? data;

  DietComparisonResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory DietComparisonResponse.fromJson(Map<String, dynamic> json) {
    return DietComparisonResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? DietComparisonData.fromJson(json['data']) : null,
    );
  }
}

class DietComparisonData {
  final String date;
  final int dayNumber;
  final Map<String, MealComparison> meals;
  final ComparisonTotals dailyTotals;

  DietComparisonData({
    required this.date,
    required this.dayNumber,
    required this.meals,
    required this.dailyTotals,
  });

  factory DietComparisonData.fromJson(Map<String, dynamic> json) {
    Map<String, MealComparison> parsedMeals = {};
    if (json['meals'] != null && json['meals'] is Map) {
      (json['meals'] as Map<String, dynamic>).forEach((key, value) {
        if (value != null && value is Map<String, dynamic>) {
          parsedMeals[key] = MealComparison.fromJson(value);
        }
      });
    }

    return DietComparisonData(
      date: json['date'] ?? '',
      dayNumber: json['day_number'] ?? 0,
      meals: parsedMeals,
      dailyTotals: ComparisonTotals.fromJson(json['daily_totals'] ?? {}),
    );
  }
}

class MealComparison {
  final ComparisonDetails dietPlan;
  final ComparisonDetails foodLogs;
  final DifferenceDetails difference;

  MealComparison({
    required this.dietPlan,
    required this.foodLogs,
    required this.difference,
  });

  factory MealComparison.fromJson(Map<String, dynamic> json) {
    return MealComparison(
      dietPlan: ComparisonDetails.fromJson(json['diet_plan'] ?? {}),
      foodLogs: ComparisonDetails.fromJson(json['food_logs'] ?? {}),
      difference: DifferenceDetails.fromJson(json['difference'] ?? {}),
    );
  }
}

class ComparisonTotals {
  final ComparisonDetails dietPlan;
  final ComparisonDetails foodLogs;
  final DifferenceDetails difference;

   ComparisonTotals({
    required this.dietPlan,
    required this.foodLogs,
    required this.difference,
  });

   factory ComparisonTotals.fromJson(Map<String, dynamic> json) {
    return ComparisonTotals(
      dietPlan: ComparisonDetails.fromJson(json['diet_plan'] ?? {}),
      foodLogs: ComparisonDetails.fromJson(json['food_logs'] ?? {}),
      difference: DifferenceDetails.fromJson(json['difference'] ?? {}),
    );
  }
}


class ComparisonDetails {
  final int calories;
  final double protein;
  final double fat;
  final double carbs;
  final List<ComparisonItem> items;

  ComparisonDetails({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.items,
  });

  factory ComparisonDetails.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List?;
    List<ComparisonItem> parsedItems = itemsList != null
        ? itemsList.map((i) => ComparisonItem.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return ComparisonDetails(
      calories: _parseNum<int>(json['calories']) ?? 0,
      protein: _parseDouble(json['protein']) ?? 0.0,
      fat: _parseDouble(json['fat']) ?? 0.0,
      carbs: _parseDouble(json['carbs']) ?? 0.0,
      items: parsedItems,
    );
  }
}

class ComparisonItem {
  final String description; 
  final String? quantity;   
  final int calories;
  final double protein;
  final double fat;
  final double carbs;

  ComparisonItem({
    required this.description,
    this.quantity,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  factory ComparisonItem.fromJson(Map<String, dynamic> json) {
    return ComparisonItem(
      description: json['description'] ?? json['food_description'] ?? 'N/A',
      quantity: json['quantity']?.toString(),
      calories: _parseNum<int>(json['calories']) ?? 0,
      protein: _parseDouble(json['protein']) ?? 0.0,
      fat: _parseDouble(json['fat']) ?? 0.0,
      carbs: _parseDouble(json['carbs']) ?? 0.0,
    );
  }
}

class DifferenceDetails {
  final double calories; 
  final double protein;
  final double fat;
  final double carbs;

  DifferenceDetails({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  factory DifferenceDetails.fromJson(Map<String, dynamic> json) {
    return DifferenceDetails(
      calories: _parseDouble(json['calories']) ?? 0.0,
      protein: _parseDouble(json['protein']) ?? 0.0,
      fat: _parseDouble(json['fat']) ?? 0.0,
      carbs: _parseDouble(json['carbs']) ?? 0.0,
    );
  }
}