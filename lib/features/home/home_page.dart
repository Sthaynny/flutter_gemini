import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gemini_ai/features/chat/chat.dart';
import 'package:flutter_gemini_ai/features/text/text.dart';

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
    return ValueListenableBuilder(
        valueListenable: selectedNotifier,
        builder: (__, selected, _) {
          return NavigationView(
            appBar: const NavigationAppBar(
              title: Text('GEMINI'),
              leading: Icon(FluentIcons.access_logo),
            ),
            pane: NavigationPane(
              onChanged: (index) {
                selectedNotifier.value = index;
              },
              selected: selected,
              displayMode: PaneDisplayMode.compact,
              items: [
                PaneItem(
                  icon: const Icon(FluentIcons.text_rotation),
                  title: const Text('text'),
                  body: const TextPage(),
                  onTap: () {
                    selectedNotifier.value = 0;
                  },
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.image_crosshair),
                  title: const Text('Chat'),
                  body: const ChatPage(),
                  onTap: () {
                    selectedNotifier.value = 1;
                  },
                ),
              ],
            ),
          );
        });
  }
}
