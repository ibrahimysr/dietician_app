import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

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
          IconButton(
            icon: Icon(Icons.notifications_none, color: AppColor.primary,),
            onPressed: () {},
          ),
        ],
        backgroundColor: AppColor.white, 
        title: Text("Ana Sayfa",style: AppTextStyles.heading3,), 
        centerTitle: true,
      ), 
      body: Column( 
        children: [ 
          
        ],
      ),
    );
  }
}