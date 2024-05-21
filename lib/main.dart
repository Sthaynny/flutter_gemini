import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_gemini_ai/features/app/app_widget.dart';

void main() async {
  Gemini.init(apiKey: const String.fromEnvironment('API_KEY'));
  runApp(const AppWidget());
}
