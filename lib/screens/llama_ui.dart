import 'package:flutter/material.dart';
import '../platform_channels/llama_swift_bridge.dart'; // チャネルコードをインポート

class LlamaUI extends StatefulWidget {
  const LlamaUI({super.key});

  @override
  LlamaUIState createState() => LlamaUIState();
}

class LlamaUIState extends State<LlamaUI> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';

  Future<void> _runLlama() async {
    final prompt = _controller.text;
    final result = await LlamaSwiftBridge.runLlamaSwift(prompt); // チャネル呼び出し
    setState(() {
      _response = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Llama Swift UI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter Prompt'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _runLlama,
              child: const Text('Run Llama'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Response:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
