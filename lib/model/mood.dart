import 'package:equatable/equatable.dart';

class Mood extends Equatable {
  const Mood({required this.id, required this.date, required this.rating});

  final int id;
  final DateTime date;
  final int rating;

  //
  // DayData.fromJson(Map<String, dynamic> map)
  //     : id = (map['id'] as num).toInt(),
  //       date = DateTime.parse(map["date"] as String),
  //       rating = (map['rating'] as num).toInt();
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     "id": id, "date": date.toString(), "rating": rating
  //   };
  // }

  @override
  List<Object?> get props => [id, date, rating];
}
