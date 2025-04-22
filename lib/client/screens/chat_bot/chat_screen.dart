import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: "ChatBot"),
      body: LlmChatView(
        style: LlmChatViewStyle(
          addButtonStyle: ActionButtonStyle(
            iconColor: AppColor.primary,
          ),
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
            apiKey: 'Apikey',
          ),
        ),
      ),
    );
  }
}
