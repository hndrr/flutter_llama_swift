import 'package:flutter/services.dart';

class LlamaSwiftBridge {
  static const _channel = MethodChannel('llama_swift_channel');

  // モデルを読み込む
  static Future<void> loadModel(String modelPath) async {
    try {
      await _channel.invokeMethod('loadModel', {'modelPath': modelPath});
    } catch (e) {
      throw 'Failed to load model: $e';
    }
  }

  // プロンプトを送信して応答を取得する
  static Future<String> sendPrompt(String prompt) async {
    try {
      final result =
          await _channel.invokeMethod('sendPrompt', {'prompt': prompt});
      return result as String;
    } catch (e) {
      throw 'Failed to process prompt: $e';
    }
  }
}
