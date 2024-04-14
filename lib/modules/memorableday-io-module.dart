import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemorableDaysForm extends StatefulWidget {
  @override
  _MemorableDaysFormState createState() => _MemorableDaysFormState();
}

class _MemorableDaysFormState extends State<MemorableDaysForm> {
  final TextEditingController _dayController = TextEditingController();

  void _submitDay() async {
    final day = _dayController.text.trim();
    if (day.isNotEmpty) {
      await FirebaseFirestore.instance.collection('memorable_days').add({
        'day': day,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _dayController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Memorable day added successfully!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Memorable Day'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _dayController,
              decoration: InputDecoration(labelText: 'Enter a memorable day'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitDay,
              child: Text('Add Day'),
            ),
          ],
        ),
      ),
    );
  }
}