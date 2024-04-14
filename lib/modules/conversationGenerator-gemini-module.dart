//AIzaSyAMDyXg-cVrlBC4O5vYswWsSEpFvCS3oRc

// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:emotion_ai/modules/geminiInteraction-geminiAPI-module.dart';
import 'package:emotion_ai/modules/textToSpeech-cloudTextToSpeech-module.dart';
import 'package:emotion_ai/modules/voiceRecognition.dart';

class ConversationGenerator {
  late GeminiInteraction geminiAPI;
  late TextToSpeechEngine speechEngine;
  late SpeechRecognition speechRecognition;

  bool isReady = false;

  List<String> wakeKey = ['ardour', 'ardor'];

  Future init() async {
    geminiAPI = GeminiInteraction();
    speechEngine = TextToSpeechEngine();
    speechRecognition = SpeechRecognition();
    await speechRecognition.initSpeech();

    isReady = geminiAPI.geminiIsReady &&
        speechEngine.speechToTextIsReady &&
        speechRecognition.isReady;
  }

  Map<String, Map> moodsAndActions = {
    'happy': {
      'prompt': (userDialogue) {
        return "user is happy right now, they said '$userDialogue'. generate one dialogue to speak to the user regarding this.";
      }
    },
    'angry': {
      'prompt': (userDialogue) {
        return "user is angry right now, they said '$userDialogue'. generate one dialogue to calm down the user regarding this situation, remember dont be annoying.";
      }
    },
    'sad': {
      'prompt': (userDialogue) {
        return "user is sad right now, they said '$userDialogue'. generate one dialogue to motivate the user";
      }
    },
    'excited': {
      'prompt': (userDialogue) {
        return "user is excited right now, they said '$userDialogue'. generate one dialogue to celebrate with the user";
      }
    },
    'surprised': {
      'prompt': (userDialogue) {
        return "user is surprised right now. generate one dialogue to ask the user what it is about, pretend to be their friend";
      }
    },
    'neutral': {
      'prompt': (userAction) {
        return "user is currently $userAction. generate one dialogue to ask the user how is the day, dont be annoying";
      }
    }
  };

  Map<String, Map> actions = {
    'salutation': {
      'prompt': (userGreeting) {
        return "user has said $userGreeting, generate a dialogue to greet them back";
      },
      'responding': {
        'prompt': (userQuestion) {
          return "user had asked you about $userQuestion, generate a dialogue to reply them back, be friendly";
        }
      },
      'answering': {
        'prompt': (userRequest) {
          return "user had asked a question about $userRequest, generate a dialogue to answer them back, be informative";
        }
      },
    },
  };

  Future detectSpeechContext() async {
    while (true) {
      if (speechRecognition.result.value.split(' ').contains('ardour') ||
          speechRecognition.result.value.split(' ').contains('ardor')) {
        speechRecognition.stopListening();
        speechRecognition.result.value = "";
        speechRecognition.startListening();
        speechEngine.speak(await geminiAPI.getResponse(
            await actions['answering']!['prompt'](speechRecognition.result)));
      }
    }
  }
}
