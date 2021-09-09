import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an User object, based on Firebase document
class MyUser {
  /// Technical ID of firestore document
  late final String uid;

  /// User firstname
  String firstname;

  /// User lastname
  String lastname;

  /// Is the user a premium user ?
  bool isPremium;

  /// Is the user a service provider ?
  bool isServiceProvider;

  /// Profile picture
  String image;

  /// Event that the user is attending to
  late List attendingTo = [];

  /// User email
  String? email;

  /// Default constructor
  MyUser(
      {this.firstname = "",
      this.lastname = "",
      this.isPremium = false,
      this.isServiceProvider = false,
      this.image = "",
      this.email});

  /// Returns a readable MyUser object
  String toString() {
    return "MyUser{uid:" +
        uid +
        ",firstname:" +
        firstname +
        ",lastname:" +
        lastname +
        ",isPremium:" +
        isPremium.toString() +
        ",isServiceProvider:" +
        isServiceProvider.toString() +
        ",image:" +
        image +
        ",attendingTo:" +
        attendingTo.toString() +
        "}";
  }

  /// Translate a MyUser object to JSON
  Map<String, Object?> toJson() {
    return {
      //'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'image': image,
      'isPremium': isPremium,
      'isServiceProvider': isServiceProvider,
      'attendingTo': attendingTo,
    };
  }

  /// Retrieves the user info from Firebase document
  Future<void> populateUserInfoFromFirestore() async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (snap.exists) {
      lastname =
          (snap.data()!["lastname"] != null ? snap.data()!["lastname"] : "");
      firstname =
          (snap.data()!["firstname"] != null ? snap.data()!["firstname"] : "");
      isPremium = (snap.data()!["isPremium"] != null
          ? snap.data()!["isPremium"]
          : false);
      isServiceProvider = (snap.data()!["isServiceProvider"] != null
          ? snap.data()!["isServiceProvider"]
          : false);
      image = (snap.data()!["image"] != null ? snap.data()!["image"] : "");
      attendingTo = (snap.data()!['attendingTo'] != null
          ? List.from(snap.data()!['attendingTo'].toSet())
          : []);
    }
  }

  /// Save the user info to Firebase
  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance.collection("users").doc(uid).set(toJson());
  }

  /// Remove the event from the attendency list and sync it with Firebase
  removeAttendingTo(String eventId) async {
    attendingTo.remove(eventId);
    //await FirebaseFirestore.instance.collection("users").doc(uid).update(toJson());
    saveToFirestore();
  }

  /// Add the event from the attendency list and sync it with Firebase
  addAttendingTo(String eventId) async {
    attendingTo.add(eventId);
    //await FirebaseFirestore.instance.collection("users").doc(uid).update(toJson());
    saveToFirestore();
  }

  /// Set an user UID
  void setUid(String uid) {
    this.uid = uid;
  }

  /// Set an user email
  void setEmail(String email) {
    this.email = email;
  }
}
