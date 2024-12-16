import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'platform_channels/llama_swift_bridge.dart';

class AssetUtils {
  static Future<String> copyAssetToTemporaryDirectory(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(data.buffer.asUint8List());
    return file.path;
  }
}

class LlamaApp extends StatefulWidget {
  const LlamaApp({super.key});

  @override
  LlamaAppState createState() => LlamaAppState();
}

class LlamaAppState extends State<LlamaApp> {
  final TextEditingController _promptController = TextEditingController();
  String _response = "";

  Future<void> _loadModel() async {
    try {
      final modelPath = await AssetUtils.copyAssetToTemporaryDirectory(
          "assets/models/gemma-2-baku-2b-it-Q4_K_M.gguf");
      await LlamaSwiftBridge.loadModel(modelPath);
      debugPrint("Model loaded successfully: $modelPath");
    } catch (e) {
      debugPrint("Error loading model: $e");
    }
  }

  Future<void> _sendPrompt() async {
    try {
      final response =
          await LlamaSwiftBridge.sendPrompt(_promptController.text);
      setState(() {
        _response = response;
      });
    } catch (e) {
      debugPrint("Error processing prompt: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Llama Model Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _loadModel,
              child: Text("Load Model"),
            ),
            TextField(
              controller: _promptController,
              decoration: InputDecoration(labelText: "Enter Prompt"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendPrompt,
              child: Text("Send Prompt"),
            ),
            SizedBox(height: 16),
            Text(
              "Response:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_response),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: LlamaApp()));
}
