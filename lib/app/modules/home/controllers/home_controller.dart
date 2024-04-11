import 'package:emotion_ai/modules/geminiInteraction-geminiAPI-module.dart';
import 'package:emotion_ai/modules/textToSpeech-cloudTextToSpeech-module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  double screenHeight = 0, screenWidth = 0;

  late GeminiInteraction geminiAPI;
  late TextToSpeechEngine speechEngine;
  late TextEditingController requestFieldController;

  Rx<String> responseText = ''.obs;
  Rx<bool> screenReady = false.obs, fetchingResponse = false.obs;

  @override
  void onInit() {
    super.onInit();

    screenHeight = Get.context!.height;
    screenWidth = Get.context!.width;

    geminiAPI = GeminiInteraction();
    speechEngine = TextToSpeechEngine();
    requestFieldController = TextEditingController();

    screenReady.value = geminiAPI.geminiIsReady && speechEngine.speechToTextIsReady;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
