// client/components/diet_plan/details_meal_item.dart

import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:flutter/material.dart';

// Yeni model import ediliyor

// Alt bileşen ve yardımcı fonksiyonlar
import 'package:dietician_app/client/components/diet_plan/details_macro_info.dart'; // Bu bileşenin var olduğunu varsayıyoruz
import 'package:dietician_app/client/core/utils/formatters.dart'; // getMealTypeName burada varsayılıyor

// Tema
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';


class DetailsMealItem extends StatelessWidget {
  // Parametre tipi ClientMeal olarak değiştirildi
  final ClientMeal meal;

  const DetailsMealItem({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    // Öğün adını formatlayan fonksiyon (getMealTypeName'in var olduğunu varsayıyoruz)
    String mealTypeName;
    try {
      // getMealTypeName fonksiyonunu çağır
      mealTypeName = getMealTypeName(meal.mealType);
    } catch (e) {
      // Fonksiyon yoksa veya hata verirse mealType'ı olduğu gibi kullan
      print("getMealTypeName fonksiyonu bulunamadı veya hata verdi: $e");
      mealTypeName = meal.mealType; // Varsayılan olarak mealType'ı kullan
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Öğün Tipi Başlığı
          Text(
            mealTypeName, // Formatlanmış öğün adını kullan
            style: AppTextStyles.body1Medium.copyWith(color: AppColor.secondary), // Stil güncellendi
          ),
          const SizedBox(height: 6),

          // Öğün Açıklaması
          Text(
            meal.description.isNotEmpty ? meal.description : "Açıklama yok", // Boş kontrolü
            style: AppTextStyles.body1Regular.copyWith(color: AppColor.secondary), // Renk ayarlandı
          ),
          const SizedBox(height: 10), // Aralık artırıldı

          // Makro Bilgileri
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alanı eşit dağıt
            children: [
              // DetailsMacroInfo bileşeninin String label ve String value aldığını varsayıyoruz
              DetailsMacroInfo(label: "Kalori", value: "${meal.calories} kcal"),
              DetailsMacroInfo(label: "Protein", value: "${meal.protein}g"), // Etiket "P" yerine "Protein"
              DetailsMacroInfo(label: "Yağ", value: "${meal.fat}g"),         // Etiket "Y" yerine "Yağ"
              DetailsMacroInfo(label: "Karbonhidrat", value: "${meal.carbs}g"), // Etiket "K" yerine "Karbonhidrat"
            ],
          ),

          // Ayırıcı Çizgi (isteğe bağlı)
          // Son öğeden sonra çizgi olmaması için kontrol eklenebilir veya kaldırılabilir.
          // Padding yerine Container içine alıp sadece alt kenara border vermek daha iyi olabilir.
          // Padding(
          //   padding: const EdgeInsets.only(top: 15.0), // Çizgi için üst boşluk
          //   child: Divider(color: AppColor.greyLight.withOpacity(0.6), height: 1, thickness: 1),
          // ),
        ],
      ),
    );
  }
}