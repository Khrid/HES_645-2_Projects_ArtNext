
import 'package:flutter/foundation.dart';

export 'event.dart';

@immutable
class Event {
  Event({
    required this.id, //
    required this.title,
    required this.city
  });

  Event.fromJson(json)
      : this(
      id: json.id,
      title: (json.data()['title'] != null
          ? json.data()['title']
          : "<emptyTitle>") as String,
      city: (json.data()['city'] != null
          ? json.data()['city']
          : "<emptyCity>") as String
  );

  final String id;
  final String title;
  final String city;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'city': city
    };
  }

  @override
  String toString() {
    // TODO: implement toString

    return "Event{"
        "id:" + id + ", " +
    "title:" + title + ", " +
    "city:" + city + "}";
  }

}