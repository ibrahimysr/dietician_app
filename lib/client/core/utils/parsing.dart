
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