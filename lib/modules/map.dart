import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocation Demo',
      home: GeolocationDemo(),
    );
  }
}

class GeolocationDemo extends StatefulWidget {
  @override
  _GeolocationDemoState createState() => _GeolocationDemoState();
}

class _GeolocationDemoState extends State<GeolocationDemo> {
  TextEditingController _controller = TextEditingController();
  String _result = '';

  Future<void> _detectLocation() async {
    String apiKey = 'YOUR_API_KEY';
    String address = _controller.text;

    if (apiKey.isEmpty) {
      setState(() {
        _result = 'API key is missing!';
      });
      return;
    }

    if (address.isEmpty) {
      setState(() {
        _result = 'Please enter an address!';
      });
      return;
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];

      if (results.isNotEmpty) {
        final location = results[0]['geometry']['location'];
        final latitude = location['lat'];
        final longitude = location['lng'];
        setState(() {
          _result = 'Latitude: $latitude\nLongitude: $longitude';
        });
      } else
        setState(() {
          _result = 'Location not found!';
        });
      }
    } else {
      setState(() {
        _result = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocation Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter an address'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _detectLocation,
              child: Text('Detect Location'),
            ),
            SizedBox(height: 20.0),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
