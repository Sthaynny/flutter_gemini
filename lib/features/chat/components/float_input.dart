import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini_ai/shared/style/colors/color.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatInput extends StatelessWidget {
  const FloatInput({
    super.key,
    required this.textEditingController,
    this.file,
    required this.isLoading,
    required this.setFile,
    required this.onSubmitted,
  });

  final TextEditingController textEditingController;
  final File? file;
  final bool isLoading;
  final ValueSetter<File?> setFile;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(200),
      ),
      child: Row(
        children: [
          if (file != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: isLoading
                      ? null
                      : () {
                          setFile(null);
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
              icon: Icon(
                Icons.image_outlined,
                color: primaryColor,
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        setFile(File(result.files.single.path!));
                      } else {
                        // User canceled the picker
                      }
                    },
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: textEditingController,
                enabled: !isLoading,
                onFieldSubmitted: (_) {
                  onSubmitted();
                },
                cursorColor: primaryColor,
                style: GoogleFonts.nunito(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Escreva sua mensagem...',
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: primaryColor,
            ),
            onPressed: onSubmitted,
          ),
        ],
      ),
    );
  }
}
