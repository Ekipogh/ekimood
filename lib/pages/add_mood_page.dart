import 'package:flutter/material.dart';

class AddMoodPage extends StatefulWidget {
  const AddMoodPage({Key? key, required this.selectedDay}) : super(key: key);
  final DateTime selectedDay;

  @override
  State<AddMoodPage> createState() => _AddMoodPageState();
}

class _AddMoodPageState extends State<AddMoodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(widget.selectedDay.toIso8601String()),
        ));
  }
}
