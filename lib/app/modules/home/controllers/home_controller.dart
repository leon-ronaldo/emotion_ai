// ignore_for_file: empty_catches

import 'package:emotion_ai/modules/conversationGenerator-gemini-module.dart';
import 'package:emotion_ai/modules/voiceRecognition.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  double screenHeight = 0, screenWidth = 0;

  late TextEditingController requestFieldController;
  late ConversationGenerator conversationGenerator;

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
    conversationGenerator.speechRecognition.startListening();

    screenReady.value = conversationGenerator.isReady;

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
      conversationGenerator.speechRecognition.stopListening();
    } on Exception catch (e) {}
  }
}
