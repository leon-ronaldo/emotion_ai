import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class Event {
  final DateTime date;
  final String title;
  final String? description;

  Event(this.date, this.title, {this.description});

  // Convert Event to a Map for JSON encoding
  Map<String, dynamic> toJson() => {
        'date': date.toString(),
        'title': title,
        'description': description,
      };

  // Factory constructor to create Event from a Map (for JSON decoding)
  factory Event.fromJson(Map<String, dynamic> json) => Event(
        DateTime.parse(json['date'] as String),
        json['title'] as String,
        description: json['description'] as String?,
      );
}

class EventManager {
  Event getUserEvent() {
    while (true) {
      print("Enter event title:");
      final title = stdin.readLineSync(); // No need for explicit encoding

      print("Enter event date (YYYY-MM-DD):");
      final dateString = stdin.readLineSync(); // No need for explicit encoding
      try {
        final DateTime date = DateTime.parse(dateString!);
        print("Enter optional event description:");
        final description =
            stdin.readLineSync(); // No need for explicit encoding
        return Event(date, title!, description: description);
      } on FormatException {
        print("Invalid date format. Please try again (YYYY-MM-DD).");
      }
    }
  }

  // Function to save events to SharedPreferences
  Future<void> saveEvents(List<Event> events) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedEvents = jsonEncode(events.map((e) => e.toJson()).toList());
    await prefs.setString('events', encodedEvents);
  }

  // Function to load events from SharedPreferences
  Future<List<Event>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedEvents = prefs.getString('events');
    if (encodedEvents == null) {
      return [];
    }
    try {
      final decodedEvents = jsonDecode(encodedEvents) as List;
      return decodedEvents.map((e) => Event.fromJson(e)).toList();
    } on FormatException {
      print("Error decoding stored events. Starting with an empty list.");
      return [];
    }
  }

  void showEventsByDate(DateTime date, List<Event> events) {
    final matchingEvents = events
        .where((event) =>
            event.date.year == date.year &&
            event.date.month == date.month &&
            event.date.day == date.day)
        .toList();
    print("Events on ${date.toString()}:");
    for (var event in matchingEvents) {
      print("- ${event.title}");
      if (event.description != null) {
        print("  Description: ${event.description}");
      }
    }
  }
}

Future<void> main() async {
  final events = <Event>[]; // Initialize events list

  EventManager eventManager = EventManager();

  // Load events from SharedPreferences
  final loadedEvents = await eventManager.loadEvents();

  events.addAll(loadedEvents);

  // Function to get user input for a new event

  // Get user input for a new event with error handling for invalid date
  final newEvent = eventManager.getUserEvent();
  events.add(newEvent);

  // Save events back to SharedPreferences
  await eventManager.saveEvents(events);
}
