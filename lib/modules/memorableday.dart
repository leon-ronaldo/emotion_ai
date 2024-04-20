import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memorable Events',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemorableEventsPage(),
    );
  }
}

class MemorableEventsPage extends StatefulWidget {
  @override
  _MemorableEventsPageState createState() => _MemorableEventsPageState();
}

class _MemorableEventsPageState extends State<MemorableEventsPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();

  List<String> events = [];
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    String storedEvents = await secureStorage.read(key: 'events') ??'';
    if (storedEvents != null && storedEvents.isNotEmpty) {
      setState(() {
        events = storedEvents.split(',');
      });
    }
  }

  Future<void> _saveEvent() async {
    String eventName = _eventNameController.text.trim();
    String eventDescription = _eventDescriptionController.text.trim();

    if (eventName.isNotEmpty && eventDescription.isNotEmpty) {
      events.add('$eventName - $eventDescription');
      await secureStorage.write(key: 'events', value: events.join(','));
      setState(() {
        _eventNameController.clear();
        _eventDescriptionController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memorable Events'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: 'Event Name',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _eventDescriptionController,
              decoration: InputDecoration(
                labelText: 'Event Description',
              ),
            ),
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: _saveEvent,
              child: Text('Save Event'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Memorable Events:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(events[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
