import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key,});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> { 

  final String _apiKey = AppSecrets.geminiApiKey; 

  @override
  Widget build(BuildContext context) {

  if (_apiKey.isEmpty) { 
       return Scaffold(
        backgroundColor: AppColor.white,
        appBar: CustomAppBar(title: "ChatBot"),
        body: const Center(
          child: Text(
            'API Anahtarı yapılandırılmamış.\nLütfen uygulamayı --dart-define ile çalıştırın.',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: "ChatBot"),
      body:
      
      
       LlmChatView(
        style: LlmChatViewStyle(
        
          llmMessageStyle: LlmMessageStyle(
            iconColor: AppColor.primary,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          backgroundColor: Colors.white,
          chatInputStyle: ChatInputStyle(
            backgroundColor: Colors.white,
            hintText: "Merak Ettiklerinizi Sorun",
          ),
        ),
        welcomeMessage: 'Merhaba! Size nasıl yardımcı olabilirim?',
        provider: GeminiProvider(
          model: GenerativeModel(
            model: 'gemini-1.5-flash',
            apiKey: _apiKey,
          ),
        ),
      ),
    );
  }
}
