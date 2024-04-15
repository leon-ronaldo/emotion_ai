import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiInteraction {
  bool geminiIsReady = false;

  GeminiInteraction() {
    /*final apiKey =
        Platform.environment['AIzaSyAy6l8CZxcOGZRqLaB1iVwL4aPZiLg8PKc'];
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);*/
    geminiIsReady = true;
  }

  Future<String> getResponse(requestText) async {
    final prompt = {
      "contents": [
        {
          "parts": [
            {"text": requestText}
          ]
        }
      ]
    };

    final body = jsonEncode(prompt);

    final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAy6l8CZxcOGZRqLaB1iVwL4aPZiLg8PKc'),
        headers: {'Content-Type': 'application/json'},
        body: body);


    final decodedResponse = jsonDecode(response.body.toString());
    final text = decodedResponse['candidates'][0]['content']['parts'][0]['text'];
    return text;
  }
}
