import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/generated/asset.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar( 
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColor.primary,),
          onPressed: () {},
        ), 
        actions: [
         Lottie.asset(AppAssets.loginAnimation)
        ],
        backgroundColor: AppColor.white, 
        title: Text("Ana Sayfa",style: AppTextStyles.heading3,), 
        centerTitle: true,
      ), 
      body: Padding(
        padding: context.paddingNormal,
        child: Column( 
         mainAxisAlignment:MainAxisAlignment.start ,
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            Text("Hoşgeldin İbrahim 👋",style: AppTextStyles.heading3,),  
        SizedBox(height: context.getDynamicHeight(2),),
            Container(
              decoration: BoxDecoration( 
                borderRadius: BorderRadius.circular(10),
                color: AppColor.grey
              ),
              child: TextFormField( 
                decoration: InputDecoration( 
                  hintText: "Ara",
                  prefixIcon: Icon(Icons.search,color: AppColor.primary,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                    
                  ),
                ),
              ),
            )
        
          ],
        ),
      ),
    );
  }
}