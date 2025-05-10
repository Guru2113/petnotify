// main.dart
import 'package:flutter/material.dart';
import 'package:petnotify/notify.dart';
// import 'package:petapp/notify.dart';
import 'screens/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  // NotificationService().initialize();
  NotiService().initNotification();
  runApp(PetCareApp());
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Care Reminder',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomeScreen(),
    );
  }
}