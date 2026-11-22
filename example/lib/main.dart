import 'dart:ui' as ui;

import 'package:community_flutter_text_recognition/community_flutter_text_recognition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MaterialApp(home: TextRecognitionPage()));

class TextRecognitionPage extends StatefulWidget {
  const TextRecognitionPage({super.key});

  @override
  State<TextRecognitionPage> createState() => _TextRecognitionPageState();
}

class _TextRecognitionPageState extends State<TextRecognitionPage> {
  final TextEditingController _input = TextEditingController(text: 'Hello from Flutter\nOn-device OCR');
  Uint8List? _image;
  String _result = '';

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  /// Draws [text] as black on white into a PNG: a self-contained stand-in for a camera photo.
  Future<Uint8List> _render(String text) async {
    final painter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(color: Colors.black, fontSize: 48)),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 1000);
    final recorder = ui.PictureRecorder();
    final width = painter.width + 80, height = painter.height + 80;
    final canvas = Canvas(recorder)..drawRect(Rect.fromLTWH(0, 0, width, height), Paint()..color = Colors.white);
    painter.paint(canvas, const Offset(40, 40));
    final image = await recorder.endRecording().toImage(width.ceil(), height.ceil());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<void> _recognize() async {
    if (!await CommunityTextRecognition.isAvailable()) {
      setState(() => _result = 'Text recognition is not available on this device.');
      return;
    }
    final png = await _render(_input.text);
    setState(() {
      _image = png;
      _result = 'Recognizing...';
    });
    try {
      final text = await CommunityTextRecognition.recognize(png);
      setState(() => _result = text.isEmpty ? '(no text found)' : text);
    } on PlatformException catch (e) {
      setState(() => _result = 'Failed: ${e.code} ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    return Scaffold(
      appBar: AppBar(title: const Text('Text recognition')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(controller: _input, maxLines: 3, decoration: const InputDecoration(labelText: 'Text to draw')),
          const SizedBox(height: 8),
          FilledButton(onPressed: _recognize, child: const Text('Draw and recognize')),
          if (image != null) Padding(padding: const EdgeInsets.all(8), child: Image.memory(image)),
          SelectableText(_result),
        ],
      ),
    );
  }
}
