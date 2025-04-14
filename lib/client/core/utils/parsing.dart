
int? parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble(); 
  if (value is String) return double.tryParse(value.replaceAll(',', '.')); 
  return null;
}

DateTime? parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) {
     try {
      
       return DateTime.parse(value).toLocal();
     } catch (e) {
       return null;
     }
  }
  return null;
} 


String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu alan zorunludur.';
    }
    return null;
  }

  String? validateRequiredNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu alan zorunludur.';
    }
    if (int.tryParse(value) == null) {
      return 'Geçerli bir sayı giriniz.';
    }
     if (int.parse(value) < 0) {
      return 'Değer 0 veya daha büyük olmalı.';
    }
    return null;
  }

  String? validateRequiredDecimal(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu alan zorunludur.';
    }
    if (double.tryParse(value.replaceAll(',', '.')) == null) {
      return 'Geçerli bir sayı giriniz (örn: 10.5).';
    }
     if (double.parse(value.replaceAll(',', '.')) < 0) {
      return 'Değer 0 veya daha büyük olmalı.';
    }
    return null;
  }

  String translateFieldName(String field) {
    switch (field) {
      case 'title':
        return 'Başlık';
      case 'description':
        return 'Açıklama';
      case 'ingredients':
        return 'Malzemeler';
      case 'instructions':
        return 'Talimatlar';
      case 'prep_time':
        return 'Hazırlık Süresi';
      case 'cook_time':
        return 'Pişirme Süresi';
      case 'servings':
        return 'Porsiyon';
      case 'calories':
        return 'Kalori';
      case 'protein':
        return 'Protein';
      case 'fat':
        return 'Yağ';
      case 'carbs':
        return 'Karbonhidrat';
      case 'is_public':
        return 'Herkese Açık';
      case 'photo':
        return 'Fotoğraf';
      case 'user_id':
        return 'Kullanıcı';
      default:
        return field;
    }
  }