import 'package:emotion_ai/app/modules/home/controllers/home_controller.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognizer extends HomeController {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _speechAvailable = false;
  String _lastWords = '';
  String _currentWords = '';
  bool isListening = false;

  Future<void> initialize() async {
    _speechAvailable = await _speechToText.initialize(
      onError: errorListener,
      onStatus: statusListener,
    );
  }

  void errorListener(SpeechRecognitionError error) {
    print(error.errorMsg.toString());
  }

  void statusListener(String status) async {
    print("status $status");
    if (status == "done" && _speechEnabled) {
      _lastWords += " $_currentWords";
      _currentWords = "";
      _speechEnabled = false;
      await startListening();
    }
  }

  Future initSpeech() async {
    _speechAvailable = await _speechToText.initialize(
        onError: errorListener, onStatus: statusListener);
  }

  Future startListening() async {
    print("=================================================");
    isListening = true;
    await stopListening();
    await Future.delayed(const Duration(milliseconds: 50));
    await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 5),
        listenOptions: SpeechListenOptions(
            cancelOnError: false,
            partialResults: true,
            listenMode: ListenMode.dictation));
    _speechEnabled = true;
    isListening = false;
  }

  Future<void> triggerListening() async {
    while (true) {
      if (!isListening) {
        await startListening();
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future stopListening() async {
    _speechEnabled = false;
    await _speechToText.stop();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    responseText.value = result.recognizedWords;
    print(responseText.value);
    update();
  }
}
