import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/models/Client.dart';
import 'package:dietician_app/services/auth/client_service.dart';

import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
 

  const ProfileScreen({super.key,});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<ClientResponse> _clientFuture;
  final ClientService _clientService = ClientService();

  @override
  void initState() {
    super.initState();
    _clientFuture = _fetchClientData();
  }

  Future<ClientResponse> _fetchClientData() async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      throw Exception("Token bulunamadı, lütfen giriş yapın.");
    }
    final int? clientId = await AuthStorage.getId();
    print(clientId);
    if (clientId == null&& clientId == 0) {
      throw Exception("Kullanıcı ID bulunamadı.");
    }
    

    return await _clientService.getClient(userId: clientId!, token: token);
  }
 

 
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: AppColor.white,
      body: FutureBuilder<ClientResponse>(future: _clientFuture, builder:(context, snapshot) {
         
         if(snapshot.connectionState == ConnectionState.waiting){
           return Center(child: CircularProgressIndicator(),);
         }else if(snapshot.hasError){
           return Center(child: Text("Hata: ${snapshot.error}"),);
         }else if(snapshot.hasData){ 
          final cliendata= snapshot.data!.data; 
          return SafeArea(
            child: Column( 
              children: [ 
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container( 
                    decoration: BoxDecoration( 
                      color: AppColor.grey , 
                      borderRadius: BorderRadius.circular(10), 
                  
                    ), 
                    width: double.infinity, 
                    child: Padding(
                      padding: context.paddingNormal,
                      child: Column( 
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [ 
                          Text("Profil",style: AppTextStyles.heading3,), 
                          SizedBox(height: context.getDynamicHeight(2),), 
                          Row( 
                            children: [ 
                              CircleAvatar( 
                                radius: 30, 
                                backgroundColor: AppColor.white, 
                                child: Icon(Icons.person,color: AppColor.primary,size: 30,),
                              ), 
                              SizedBox(width: context.getDynamicWidth(2),), 
                              Column( 
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [ 
                                  Text(cliendata.user!.name,style: AppTextStyles.heading3,), 
                                  Text(cliendata.user!.email,style: AppTextStyles.heading4,),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ), 
            
              ],
            ),
          ); 
      }
      return Center(child: Text("Bir hata oluştu"),);
      }, 
      
      )
    ); 
}}