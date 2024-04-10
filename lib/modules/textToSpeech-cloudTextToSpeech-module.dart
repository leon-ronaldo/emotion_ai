import 'package:flutter_tts/flutter_tts.dart';

void main() {
  TextToSpeech object = TextToSpeech();
  object.speak('hello world');
}

class TextToSpeech {
  FlutterTts flutterTts = FlutterTts();

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(2);
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.speak(text);
  }
}
