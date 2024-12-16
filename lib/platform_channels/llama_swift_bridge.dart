import 'package:flutter/services.dart';

class LlamaSwiftBridge {
  static const _channel = MethodChannel('llama_swift_channel');

  static Future<String> runLlamaSwift(String prompt) async {
    try {
      final result =
          await _channel.invokeMethod('runLlamaSwift', {'prompt': prompt});
      return result as String;
    } catch (e) {
      return 'Error: $e';
    }
  }
}
