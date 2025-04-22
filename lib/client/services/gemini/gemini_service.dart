import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dietician_app/client/core/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {

  final String _apiKey = AppSecrets.geminiApiKey; 

  Future<Map<String, dynamic>> estimateCaloriesFromPhoto(File image) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: _apiKey,
      );

      final prompt = TextPart(
        'Bu fotoğraftaki yiyeceği Türkçe olarak tanımla ve tahmini kalori miktarını hesapla. '
        'Ayrıca protein, yağ ve karbonhidrat bilgilerini de ver. '
        'Yanıtı SADECE aşağıdaki JSON formatında döndür, başka hiçbir metin veya açıklama ekleme: '
        '{"food_name": "", "calories": 0, "protein": 0, "fat": 0, "carbs": 0}',
      );
      final imagePart = DataPart('image/jpeg', await image.readAsBytes());

      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      print('Gemini Raw Response: ${response.text}');

      final jsonMatch = RegExp(r'\{[\s\S]*?\}').firstMatch(response.text.toString());
      if (jsonMatch == null) {
        throw Exception('Yanıtta geçerli JSON bulunamadı');
      }
      final jsonString = jsonMatch.group(0)!;

      log('Extracted JSON: $jsonString'); 

      final jsonResponse = jsonDecode(jsonString) as Map<String, dynamic>;

      return {
        'food_name': jsonResponse['food_name']?.toString() ?? 'Bilinmeyen Yiyecek',
        'calories': jsonResponse['kalori'] ?? jsonResponse['calories'] ?? 0,
        'protein': jsonResponse['protein']?.toDouble() ?? 0.0,
        'fat': jsonResponse['yağ'] ?? jsonResponse['fat']?.toDouble() ?? 0.0,
        'carbs': jsonResponse['karbonhidrat'] ?? jsonResponse['carbs']?.toDouble() ?? 0.0,
      };
    } catch (e) {
      log('Gemini Hata: $e');
      throw Exception('Yiyecek analizi başarısız: $e');
    }
  }
}