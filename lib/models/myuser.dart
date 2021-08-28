import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  late final String uid;
  String firstname;
  String lastname;
  bool isPremium;
  bool isServiceProvider;
  String image;

  MyUser(
      {
      this.firstname = "",
      this.lastname = "",
      this.isPremium = false,
      this.isServiceProvider = false,
      this.image = ""});

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
        "}";
  }

  Map<String, Object?> toJson() {
    return {
      //'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'image': image,
      'isPremium': isPremium,
      'isServiceProvider': isServiceProvider
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
    }
  }

  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance.collection("users").doc(uid).set(toJson());
  }

  void setUid(String uid) {
    this.uid = uid;
  }
}
