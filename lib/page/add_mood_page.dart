import 'package:ekimood/model/mood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class AddMoodPage extends StatefulWidget {
  const AddMoodPage({Key? key, required this.selectedDay}) : super(key: key);
  final DateTime selectedDay;

  @override
  State<AddMoodPage> createState() => _AddMoodPageState();
}

class _AddMoodPageState extends State<AddMoodPage> {
  final DateFormat dateFormat = DateFormat.yMMMd();
  double rating = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: const Key("add_mood_page"),
        appBar: AppBar(),
        body: Form(
          key: const Key("add_mood_form"),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dateFormat.format(widget.selectedDay)),
                  RatingBar.builder(
                    initialRating: rating,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return const Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: Colors.red,
                          );
                        case 1:
                          return const Icon(
                            Icons.sentiment_dissatisfied,
                            color: Colors.orange,
                          );
                        case 2:
                          return const Icon(
                            Icons.sentiment_neutral,
                            color: Colors.yellow,
                          );
                        case 3:
                          return const Icon(
                            Icons.sentiment_satisfied,
                            color: Colors.lightGreen,
                          );
                        case 4:
                          return const Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                          );
                      }
                      return const Icon(Icons.question_mark);
                    },
                    onRatingUpdate: (double value) {
                      value -= 1;
                      rating = value;
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Mood(date: widget.selectedDay, rating: rating.toInt())
                            .save();
                        Navigator.pop(context);
                      },
                      child: const Text("Save"))
                ],
              ),
            ),
          ),
        ));
  }
}
