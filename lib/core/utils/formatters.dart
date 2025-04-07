import 'package:flutter/material.dart';

IconData getMealTypeIcon(String mealType) {
  switch (mealType.toLowerCase()) {
    case 'breakfast':
      return Icons.free_breakfast_outlined;
    case 'lunch':
      return Icons.lunch_dining_outlined;
    case 'dinner':
      return Icons.dinner_dining_outlined;
    case 'snack':
      return Icons.fastfood_outlined;
    default:
      return Icons.restaurant_menu_outlined;
  }
}

String getMealTypeName(String mealType) {
  switch (mealType.toLowerCase()) {
    case 'breakfast':
      return 'Kahvaltı';
    case 'lunch':
      return 'Öğle Yemeği';
    case 'dinner':
      return 'Akşam Yemeği';
    case 'snack':
      return 'Ara Öğün';
    default:
      return mealType.isNotEmpty
          ? mealType[0].toUpperCase() + mealType.substring(1)
          : 'Bilinmeyen Öğün';
  }
}

int getMealTypeOrder(String mealType) {
  switch (mealType.toLowerCase()) {
    case 'breakfast':
      return 1;
    case 'snack':
      return 2;
    case 'lunch':
      return 3;
    case 'dinner':
      return 5;
    default:
      return 99;
  }
} 

 String? formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Belirtilmemiş';
    try {
      if (dateString.contains('T')) {
        dateString = dateString.split('T')[0];
      }
      final dateTime = DateTime.parse(dateString);
      return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";
    } catch (e) {
      return dateString;
    }
  }


 IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'meyve':
        return Icons.apple;
      case 'sebze':
        return Icons.local_florist;
      case 'tahıl':
        return Icons.grain;
      case 'et':
      case 'tavuk':
      case 'balık':
        return Icons.set_meal;
      case 'süt ürünleri':
        return Icons.local_drink;
      case 'kuruyemiş':
        return Icons.scatter_plot;
      case 'i̇çecek':
        return Icons.local_cafe;
      case 'atıştırmalık':
        return Icons.fastfood;
      case 'salata':
        return Icons.restaurant;
      default:
        return Icons.food_bank;
    }
  }
