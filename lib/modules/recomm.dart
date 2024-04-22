import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  List<String> recommendations = [];
  TextEditingController _preferenceController = TextEditingController();

  @override
  void dispose() {
    _preferenceController.dispose();
    super.dispose();
  }

  Future<void> fetchRecommendations(String userPreference) async {
    // Replace 'YOUR_API_ENDPOINT' with the actual endpoint of your recommendation API
    final String apiUrl = 'YOUR_API_ENDPOINT?preference=$userPreference';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final responseData = json.decode(response.body);
      setState(() {
        recommendations = List<String>.from(responseData['recommendations']);
      });
    } catch (error) {
      print('Error fetching recommendations: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personalized Recommendations'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _preferenceController,
              decoration: InputDecoration(
                labelText: 'Enter Your Preference',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String userPreference = _preferenceController.text.trim();
              if (userPreference.isNotEmpty) {
                fetchRecommendations(userPreference);
              }
            },
            child: Text('Get Recommendations'),
          ),
          Expanded(
            child: recommendations.isEmpty
                ? Center(
                    child: Text('No recommendations yet.'),
                  )
                : ListView.builder(
                    itemCount: recommendations.length,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        title: Text(recommendations[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RecommendationScreen(),
  ));
}
