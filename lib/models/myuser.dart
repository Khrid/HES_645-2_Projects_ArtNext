import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  late final String uid;
  String firstname;
  String lastname;
  bool isPremium;
  bool isServiceProvider;
  String image;
  late List attendingTo = [];
  String? email;

  MyUser(
      {this.firstname = "",
      this.lastname = "",
      this.isPremium = false,
      this.isServiceProvider = false,
      this.image = "",
      this.email});

  @override
  String toString() {
    // TODO: implement toString
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

  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance.collection("users").doc(uid).set(toJson());
  }

  removeAttendingTo(String eventId) async {
    attendingTo.remove(eventId);
    //await FirebaseFirestore.instance.collection("users").doc(uid).update(toJson());
    saveToFirestore();
  }

  addAttendingTo(String eventId) async {
    attendingTo.add(eventId);
    //await FirebaseFirestore.instance.collection("users").doc(uid).update(toJson());
    saveToFirestore();
  }

  void setUid(String uid) {
    this.uid = uid;
  }

  void setEmail(String email) {
    this.email = email;
  }
}
