import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _tokenKey = 'auth_token';
  static const String _idKey = 'auth_id';
  static const String _dietitianIdKey = 'dietitian_id';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  } 
  

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

   static Future<void> saveId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_idKey, id);
  
  }
   static Future<int?> getId() async { 
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_idKey);
   } 

   static Future<void> clearid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idKey);
  } 

  static Future<void> saveClientId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_idKey, id);
  
  }
   static Future<int?> getClientId() async { 
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_idKey);
   } 

   static Future<void> clearClientid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idKey); 
   }
    static Future<void> saveDietitianId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dietitianIdKey, id);
  
  }
   static Future<int?> getDietitianId() async { 
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dietitianIdKey);
   } 

   static Future<void> clearDietitianid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dietitianIdKey);
  }
}