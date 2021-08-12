
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

export 'event.dart';

@immutable
class Event {
  Event({
    this.id = "-1",
    required this.title,
    required this.details,
    required this.city,
    required this.image,
    required this.startDate
  });

  Event.fromJson(json)
      : this(
      id: json.id,
      title: (json.data()['title'] != null
          ? json.data()['title']
          : "<emptyTitle>") as String,
      details: (json.data()['details'] != null
          ? json.data()['details']
          : "<emptyTitle>") as String,
      city: (json.data()['city'] != null
          ? json.data()['city']
          : "<emptyCity>") as String,
      image: (json.data()['image'] != null
          ? json.data()['image']
          : "<emptyImage>") as String,
      startDate: (json.data()['startDate'] != null
    ? json.data()['startDate']
      : "<startDate>") as Timestamp
  );

  late final String id;
  final String title;
  final String details;
  final String city;
  final String image;
  final Timestamp startDate;

  Map<String, Object?> toJson() {
    return {
      //'id': id,
      'title': title,
      'details': details,
      'city': city,
      'image': image,
      'startDate': startDate
    };
  }

  @override
  String toString() {
    // TODO: implement toString

    return "Event{"
        "id:" + id + ", " +
        "title:" + title + ", " +
        "details:" + details + ", " +
        "city:" + city + ", " +
        "image:" + image + ", " +
        "startDate:" + startDate.toDate().toString() + "}";
  }
}