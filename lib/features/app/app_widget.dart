import 'package:flutter/material.dart';
import 'package:flutter_gemini_ai/features/chat/chat_screen.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dino IA',
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}
