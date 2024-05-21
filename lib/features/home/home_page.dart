import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gemini_ai/features/chat/chat.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier selectedNotifier = ValueNotifier(0);

  @override
  void dispose() {
    selectedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const ChatPage();
  }
}
