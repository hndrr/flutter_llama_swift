import 'package:flutter/material.dart';
import 'screens/llama_ui.dart'; // llama_ui.dart をインポート

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LlamaUI(), // llama_ui.dart の画面を指定
    );
  }
}
