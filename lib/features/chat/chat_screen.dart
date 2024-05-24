import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gemini_ai/features/chat/components/float_input.dart';
import 'package:flutter_gemini_ai/shared/animations/animations_enum.dart';
import 'package:flutter_gemini_ai/shared/style/colors/color.dart';
import 'package:flutter_gemini_ai/shared/style/images/images_enum.dart';
import 'package:flutter_gemini_ai/shared/utils/constants/constants.dart';
import 'package:flutter_gemini_ai/shared/utils/roles/roles.dart';
import 'package:flutter_gemini_ai/shared/utils/strings/strings.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ValueNotifier<(bool, File?)> dataNotifier =
      ValueNotifier((false, null));
  final txtController = TextEditingController();
  final ScrollController _controller = ScrollController();
  File? file;

  late final GenerativeModel gemini;

  late final ChatSession _chat;
  @override
  void initState() {
    super.initState();
    gemini = GenerativeModel(
      model: modelGeminiConst,
      apiKey: const String.fromEnvironment('API_KEY'),
    );
    _chat = gemini.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(ImagesEnum.robotMini.path),
        title: Text(
          dinoIaString,
          style: GoogleFonts.nunito(
            fontSize: 20,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder(
                valueListenable: dataNotifier,
                builder: (_, __, ___) {
                  return ListView.builder(
                      itemCount: _chat.history.length,
                      controller: _controller,
                      itemBuilder: (_, index) {
                        final content = _chat.history.toList()[index];
                        final isUser = content.role == userRole;
                        var text = content.parts
                            .whereType<TextPart>()
                            .map<String>((e) => e.text)
                            .join('');
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            titleAlignment: ListTileTitleAlignment.bottom,
                            leading: isUser
                                ? null
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child:
                                        Image.asset(ImagesEnum.robotMini.path)),
                            title: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(10),
                                  topRight: isUser
                                      ? Radius.zero
                                      : const Radius.circular(10),
                                  bottomLeft: isUser
                                      ? const Radius.circular(10)
                                      : Radius.zero,
                                  bottomRight: const Radius.circular(10),
                                ),
                                color: isUser
                                    ? primaryColor.withOpacity(0.5)
                                    : Colors.grey.shade400,
                              ),
                              child: SingleChildScrollView(
                                child: MarkdownBody(
                                  data: text,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }),
          )),
          ValueListenableBuilder(
              valueListenable: dataNotifier,
              builder: (_, data, __) {
                if (!data.$1) {
                  return const SizedBox();
                }
                return Lottie.asset(
                  AnimationEnum.loading.path,
                  height: 150,
                );
              }),
          const SizedBox(
            height: 100,
          )
        ],
      ),
      floatingActionButton: ValueListenableBuilder(
          valueListenable: dataNotifier,
          builder: (_, data, __) {
            return FloatInput(
              textEditingController: txtController,
              isLoading: data.$1,
              setFile: (File? value) {
                dataNotifier.value = (false, value);
              },
              onSubmitted: sendIA,
            );
          }),
    );
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  void sendIA() async {
    final message = txtController.text;
    try {
      dataNotifier.value = (true, file);
      txtController.clear();

      if (file != null) {
        final imageBytes = await file!.readAsBytes();
        final content = Content.multi([
          TextPart(message),
          DataPart('image/${file!.path.split('.').last}', imageBytes),
        ]);

        final response = await _chat.sendMessage(content);

        log(response.toString());
      } else {
        var response = await _chat.sendMessage(
          Content.text(message),
        );
        var text = response.text;

        log(text.toString());
      }
    } finally {
      txtController.clear();
      file = null;
      dataNotifier.value = (false, file);
      _scrollDown();
    }
  }
}
