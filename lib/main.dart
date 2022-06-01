import 'package:flutter/material.dart';
import "package:ekimood/page/calendar_page.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ektrils' Mood",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const CalendarPage(title: "Ektrils' mood journal ;P"),
    );
  }
}
