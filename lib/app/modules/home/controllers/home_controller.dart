// ignore_for_file: empty_catches

import 'package:emotion_ai/modules/conversationGenerator-gemini-module.dart';
import 'package:emotion_ai/modules/stt.dart';
import 'package:emotion_ai/modules/voiceRecognition.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  double screenHeight = 0, screenWidth = 0;

  late TextEditingController requestFieldController;
  late ConversationGenerator conversationGenerator;
  late SpeechRecognizer speechRecognitionService;

  Rx<String> responseText = ''.obs;
  Rx<bool> screenReady = false.obs, fetchingResponse = false.obs;

  @override
  void onInit() async {
    super.onInit();

    screenHeight = Get.context!.height;
    screenWidth = Get.context!.width;

    conversationGenerator = ConversationGenerator();
    requestFieldController = TextEditingController();
    await conversationGenerator.init();
    speechRecognitionService = SpeechRecognizer();

    // conversationGenerator.speechRecognition.startListening();

    screenReady.value = true;
    await speechRecognitionService.initSpeech();
    speechRecognitionService.triggerListening();

    // conversationGenerator.speechRecognition.startListening();
    // conversationGenerator.detectSpeechContext();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    try {
      speechRecognitionService.stopListening();
    } on Exception catch (e) {}
  }
}
