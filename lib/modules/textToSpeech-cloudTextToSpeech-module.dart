import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechEngine {
  late FlutterTts flutterTts;
  bool speechToTextIsReady = false;

  TextToSpeechEngine() {
    flutterTts = FlutterTts();
    speechToTextIsReady = true;
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(2);
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.speak(text);
  }
}
