import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../model/mood.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({Key? key, required this.date}) : super(key: key);
  final DateTime date;

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  final DateFormat format = DateFormat.yMMMd();
  Mood? mood;
  final rating = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("mood_page"),
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder<Mood?>(
          future: _getMood(widget.date),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              mood = snapshot.data as Mood;
            } else {
              mood = Mood(date: widget.date, rating: rating.toInt());
            }
            double displayRating = mood!.rating.toDouble() + 1;
            return Form(
              key: const Key("mood_form"),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(format.format(widget.date)),
                    RatingBar.builder(
                      initialRating: displayRating,
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
                        mood?.rating = value.toInt() - 1;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          mood!.save();
                          Navigator.pop(context);
                        },
                        child: const Text("Save"))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<Mood?> _getMood(DateTime date) async {
    return await Mood.findByDate(date);
  }
}
