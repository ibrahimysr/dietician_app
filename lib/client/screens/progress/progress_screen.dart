import 'package:dietician_app/client/viewmodel/progress_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgressViewmodel(),
      child: Scaffold(
        appBar: AppBar(title: Text('İlerlemeler')),
        body: Consumer<ProgressViewmodel>(
  builder: (context, viewmodel, child) {
    if (viewmodel.isProgressLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (viewmodel.isProgressErrorMessage != null) {
      print("mesaj basılıyor..");
      return Center(child: Text(viewmodel.isProgressErrorMessage??"-"));
    }
    
    if (viewmodel.allProgress.isEmpty) {
      return Center(child: Text("Henüz ilerleme kaydı bulunmuyor."));
    }
    
    print("Listeleme yapılıyor: ${viewmodel.allProgress.length} kayıt");
    return ListView.builder(
      itemCount: viewmodel.allProgress.length,
      itemBuilder: (context, index) {
        final progress = viewmodel.allProgress[index];
        return ListTile(
          title: Text('${progress.date} - ${progress.weight} kg'),
          subtitle: Text('Bel: ${progress.waist}, Kalça: ${progress.hip}'),
        );
      },
    );
  },
)

      ),
    );
  }
}