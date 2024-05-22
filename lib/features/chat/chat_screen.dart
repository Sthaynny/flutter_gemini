import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini_ai/shared/animations/animations_enum.dart';
import 'package:flutter_gemini_ai/shared/style/color.dart';
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
  var question = '';
  var answer = '';
  var isLoading = false;
  final txtController = TextEditingController();
  final ScrollController _controller = ScrollController();
  File? file;

  late final GenerativeModel gemini;
  late final ChatSession _chat;
  @override
  void initState() {
    super.initState();
    gemini = GenerativeModel(
      model: 'gemini-1.5-pro-latest',
      apiKey: const String.fromEnvironment('API_KEY'),
    );
    _chat = gemini.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DINO IA',
          style: GoogleFonts.caveat(fontSize: 16),
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: _chat.history.length,
                controller: _controller,
                itemBuilder: (_, index) {
                  final content = _chat.history.toList()[index];
                  final isUser = content.role == 'user';
                  var text = content.parts
                      .whereType<TextPart>()
                      .map<String>((e) => e.text)
                      .join('');
                  return Container(
                    color: isUser ? Colors.green : Colors.blue,
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      leading: isUser
                          ? null
                          : Lottie.asset(
                              AnimationEnum.dino.path,
                              height: 100,
                            ),
                      trailing: !isUser
                          ? null
                          : Lottie.asset(
                              AnimationEnum.person.path,
                              height: 100,
                            ),
                      title: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.purple,
                        ),
                        child: SingleChildScrollView(
                          child: MarkdownBody(
                            data: text,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          )),
          if (isLoading)
            Lottie.asset(
              AnimationEnum.loading.path,
              width: 100,
            ),
          Row(
            children: [
              if (file != null)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: isLoading
                          ? null
                          : () {
                              setState(() {
                                file = null;
                              });
                            },
                    ),
                    Image.file(
                      file!,
                      height: 50,
                      width: 50,
                    )
                  ],
                )
              else
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: isLoading
                      ? null
                      : () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();

                          if (result != null) {
                            setState(() {
                              file = File(result.files.single.path!);
                            });
                          } else {
                            // User canceled the picker
                          }
                        },
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: txtController,
                    enabled: !isLoading,
                    onFieldSubmitted: (text) async {
                      final message = text;
                      try {
                        setState(() {
                          isLoading = true;
                          txtController.clear();
                        });

                        if (file != null) {
                          final imageBytes = await file!.readAsBytes();
                          final content = Content.multi([
                            TextPart(message),
                            DataPart('image/${file!.path.split('.').last}',
                                imageBytes),
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
                        setState(() {
                          txtController.clear();
                          isLoading = false;
                          file = null;
                          _scrollDown();
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
}
