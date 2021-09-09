import 'package:artnext/enums/EventTypeEnum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

export 'event.dart';

/// Represents an Event object, based on Firebase document
class Event {
  /// Technical ID of firestore document
  late final String id;

  /// Event title
  final String title;

  /// Event type
  final EventTypeEnum type;

  /// Event details
  final String details;

  /// Event city
  final String city;

  /// Event address
  final String address;

  /// Event geopoint (lat/lon)
  final GeoPoint geopoint;

  /// Event organizer (users collection reference)
  final String organizer;

  /// Event image
  final String image;

  /// Event start date
  final Timestamp startDate;

  /// Event end date
  final Timestamp endDate;

  /// Event end date
  List listAttendees;

  /// Default constructor
  Event(
      {this.id = "-1",
      required this.title,
      required this.details,
      required this.type,
      required this.city,
      required this.image,
      required this.startDate,
      required this.endDate,
      required this.address,
      required this.geopoint,
      required this.organizer,
      required this.listAttendees});

  /// Creates an event from json data
  Event.fromJson(json)
      : this(
            id: json.id,
            title: (json.data()['title'] != null
                ? json.data()['title']
                : "<emptyTitle>") as String,
            details: (json.data()['details'] != null
                ? json.data()['details']
                : "<emptyTitle>") as String,
            type: (json.data()['type'] != null
                ? getEventTypeEnum(json.data()['type'])
                : EventTypeEnum.UNDEFINED),
            city: (json.data()['city'] != null
                ? json.data()['city']
                : "<emptyCity>") as String,
            image: (json.data()['image'] != null
                ? json.data()['image']
                : "<emptyImage>") as String,
            startDate: (json.data()['startDate'] != null
                ? json.data()['startDate']
                : Timestamp.now()) as Timestamp,
            endDate: (json.data()['endDate'] != null
                ? json.data()['endDate']
                : Timestamp.now()) as Timestamp,
            address: (json.data()['address'] != null
                ? json.data()['address']
                : "<emptyAddress>") as String,
            geopoint: (json.data()['geopoint'] != null ? json.data()['geopoint'] : new GeoPoint(0, 0)) as GeoPoint,
            organizer: (json.data()['organizer'] != null ? json.data()['organizer'] : null) as String,
            listAttendees: (json.data()['listAttendees'] != null ? List.from(json.data()['listAttendees'].toSet()) : null) as List);

  /// Translate a Event object to JSON
  Map<String, Object?> toJson() {
    return {
      //'id': id,
      'title': title,
      'type': getEventTypeText(type),
      'details': details,
      'city': city,
      'address': address,
      'geopoint': geopoint,
      'organizer': organizer,
      'image': image,
      'startDate': startDate,
      'endDate': endDate,
      'listAttendees': listAttendees
    };
  }

  /// Remove an attendee from an event and sync it with Firebase
  removeAttendee(String attendeeUid) async {
    listAttendees.remove(attendeeUid);
    await FirebaseFirestore.instance
        .collection("events")
        .doc(id)
        .update(toJson());
  }

  /// Add an attendee to an event and sync it with Firebase
  addAttendee(String attendeeUid) async {
    listAttendees.add(attendeeUid);
    await FirebaseFirestore.instance
        .collection("events")
        .doc(id)
        .update(toJson());
  }

  /// Returns a readable Event object
  String toString() {
    return "Event{"
            "id:" +
        id +
        ", " +
        "title:" +
        title +
        ", " +
        "details:" +
        details +
        ", " +
        "city:" +
        city +
        ", " +
        "image:" +
        image +
        ", " +
        "startDate:" +
        startDate.toDate().toString() +
        "}";
  }
}
