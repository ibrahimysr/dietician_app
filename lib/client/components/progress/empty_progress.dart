import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/screens/progress/add_progress_screen.dart';
import 'package:flutter/material.dart';

class EmptyProgressView extends StatelessWidget {
  const EmptyProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_data.png',
            height: 150,
            width: 150,
          ),
          const SizedBox(height: 20),
          Text(
            "Henüz ilerleme kaydı bulunmuyor",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "İlerlemenizi takip etmek için yeni bir kayıt ekleyin",
            style: TextStyle(
              fontSize: 14,
              color: AppColor.black.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddProgressScreen()),
              );
            },
            icon: Icon(Icons.add, color: AppColor.white),
            label: Text("İlerleme Ekle", style: TextStyle(color: AppColor.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}