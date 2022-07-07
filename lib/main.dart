import 'package:ekimood/model/mood_category.dart';
import 'package:ekimood/model/mood_icon.dart';
import 'package:flutter/material.dart';
import "package:ekimood/page/calendar_page.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLists();
  runApp(const MyApp());
}

initLists() async {
  await MoodCategory.loadCategories();
  await MoodIcon.loadIcons();
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
