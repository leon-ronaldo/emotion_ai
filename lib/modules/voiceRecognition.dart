import 'dart:async';

import 'package:emotion_ai/modules/conversationGenerator-gemini-module.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechRecognition {
  late SpeechToText speechRecognitionEngine;
  late ConversationGenerator conversationGenerator;

  bool speechEnabled = false;
  bool speechAvailable = false;
  bool isReady = false;

  String lastWords = '';

  Rx<String> result = ''.obs;

  SpeechRecognition() {
    speechRecognitionEngine = SpeechToText();
    conversationGenerator = ConversationGenerator();
  }

  void errorListener(SpeechRecognitionError error) {
    print(error.errorMsg.toString());
  }

  void statusListener(String status) async {
    print("status $status");
    if (status == "done" && speechEnabled) {
      lastWords += " ${result.value}";
      result.value = "";
      speechEnabled = false;
      await startListening();
    }
  }

  Future initSpeech() async {
    speechAvailable = await speechRecognitionEngine.initialize(
        onError: errorListener, onStatus: statusListener);
    isReady = true;
  }

  void onSpeechResult(SpeechRecognitionResult recognitionResult) {
    print(recognitionResult.recognizedWords);
    conversationGenerator.detectSpeechContext();
    result.value = 'user${recognitionResult.recognizedWords}';
  }

  Future startListening() async {
    await stopListening();
    await Future.delayed(const Duration(milliseconds: 50));
    await speechRecognitionEngine.listen(
      onResult: onSpeechResult,
      listenOptions: SpeechListenOptions(listenMode: ListenMode.dictation),
    );
    speechEnabled = true;
  }

  Future stopListening() async {
    speechEnabled = false;
    await speechRecognitionEngine.stop();
  }
}
