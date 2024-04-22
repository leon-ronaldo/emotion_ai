import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Usage Tracker',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await UsageStats.requestPermission();
    UsageStats.grantUsagePermission();
    setupNotifications();
  }

  void setupNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> onSelectNotification(String payload) async {
    // Handle notification tap
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Usage Tracker'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Function to check app usage time and display notification
            checkAppUsageTime();
          },
          child: Text('Check App Usage Time'),
        ),
      ),
    );
  }
}
void checkAppUsageTime() async {
  // Retrieve usage stats for the last 24 hours
  DateTime endTime = DateTime.now();
  DateTime startTime = endTime.subtract(Duration(hours: 24));

  // Specify the package name of the app you want to monitor
  String packageName = 'com.example.app';

  // Retrieve usage stats for the specified app
  List<UsageInfo> usageStats = await UsageStats.queryUsageStatsForPackage(
    startTime,
    endTime,
    packageName,
  );

  // Calculate total usage time
  Duration totalUsageTime = Duration.zero;
  for (UsageInfo usageInfo in usageStats) {
    totalUsageTime += usageInfo.usage;
  }

  // Define a threshold for usage time (e.g., 2 hours)
  Duration threshold = Duration(hours: 2);

  // Display a notification if usage time exceeds the threshold
  if (totalUsageTime >= threshold) {
    displayNotification();
  }
}
void displayNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'channel_id',
    'Channel Name',
    'Channel Description',
    importance: Importance.max,
    priority: Priority.high,
  );
  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'App Usage Alert',
    'You have spent too much time on the specified app.',
    platformChannelSpecifics,
    payload: 'notification',
  );
}

