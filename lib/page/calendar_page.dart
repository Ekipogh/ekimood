import 'package:ekimood/model/mood.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';
import 'mood_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _selectedDay = DateTime.now();

  final List<Icon> _icons = [
    const Icon(
      Icons.sentiment_very_dissatisfied,
      color: Colors.red,
    ),
    const Icon(
      Icons.sentiment_dissatisfied,
      color: Colors.orange,
    ),
    const Icon(
      Icons.sentiment_neutral,
      color: Colors.yellow,
    ),
    const Icon(
      Icons.sentiment_satisfied,
      color: Colors.lightGreen,
    ),
    const Icon(Icons.sentiment_very_satisfied, color: Colors.green)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TableCalendar(
                key: const Key("calendar"),
                firstDay: kFirstDay,
                lastDay: kLastDay,
                calendarFormat: _calendarFormat,
                calendarBuilders:
                    CalendarBuilders(todayBuilder: (context, day, focusedDay) {
                  return FutureBuilder(
                    future: Mood.findByDate(day),
                    builder: (context, snapshot) =>
                        calendarIcon(day.day, snapshot.data as Mood?),
                  );
                }, defaultBuilder: (context, day, focusedDay) {
                  return FutureBuilder(
                      future: Mood.findByDate(day),
                      builder: (context, snapshot) =>
                          calendarIcon(day.day, snapshot.data as Mood?));
                }, selectedBuilder: (context, selectedDay, focusedDay) {
                  return FutureBuilder(
                      future: Mood.findByDate(selectedDay),
                      builder: (context, snapshot) => calendarIcon(
                          selectedDay.day, snapshot.data as Mood?, true));
                }),
                onDaySelected: (selectedDay, focusedDay) {
                  // if (!isSameDay(_selectedDay, selectedDay)) {
                  //   // Call `setState()` when updating the selected day
                  //   setState(() {
                  //     _selectedDay = selectedDay;
                  //   });
                  // }
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MoodPage(date: selectedDay)))
                      .then((value) => setState(() {}));
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                enabledDayPredicate: (day) {
                  return !day.isAfter(DateTime.now());
                },
                selectedDayPredicate: (day) {
                  // Use `selectedDayPredicate` to determine which day is currently selected.
                  // If this returns true, then `day` will be marked as selected.

                  // Using `isSameDay` is recommended to disregard
                  // the time-part of compared DateTime objects.
                  return isSameDay(_selectedDay, day);
                },
                focusedDay: _selectedDay,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget calendarIcon(int day, Mood? mood, [bool selected = false]) {
    Text dayText;
    if (selected) {
      dayText = Text(
        day.toString(),
        style: const TextStyle(color: Colors.lightBlue),
      );
    } else {
      dayText = Text(day.toString());
    }
    if (mood != null) {
      return Column(
        children: [dayText, _icons[mood.rating]],
      );
    }
    return Column(
      children: [
        dayText,
        const Icon(
          Icons.circle,
          color: Colors.grey,
        )
      ],
    );
  }
}
