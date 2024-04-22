import 'dart:async';

import 'package:emotion_ai/modules/conversationGenerator-gemini-module.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:async' show Future;
import 'dart:isolate';

class SpeechRecognition {
  late SpeechToText speechRecognitionEngine;
  late ConversationGenerator conversationGenerator;

  Isolate? recognitionIsolate;
  Isolate? keywordIsolate;
  ReceivePort? recognitionReceivePort;
  ReceivePort? keywordReceivePort;

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

  void onSpeechResult(SpeechRecognitionResult recognitionResult) async {
    print(recognitionResult.recognizedWords);
    result.value = 'user : ${recognitionResult.recognizedWords}';
    await conversationGenerator
        .detectSpeechContext(recognitionResult.recognizedWords);
  }

  Future startListening() async {
    await stopListening();
    await Future.delayed(const Duration(seconds: 2));
    await speechRecognitionEngine.listen(
      onResult: onSpeechResult,
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 5),
      listenOptions: SpeechListenOptions(sampleRate: 16000),
    );
    speechEnabled = true;
  }

  Future startListeningForQuestion() async {
    String result = "";
    await speechRecognitionEngine.listen(
      onResult: (recognitionResult) =>
          result = recognitionResult.recognizedWords,
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 5),
      listenOptions: SpeechListenOptions(sampleRate: 16000),
    );
    return result;
  }

  Future stopListening() async {
    speechEnabled = false;
    await speechRecognitionEngine.stop();
  }
}
