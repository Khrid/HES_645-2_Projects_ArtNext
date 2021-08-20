import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String uid;
  String firstname;
  String lastname;
  bool isPremium;
  bool isServiceProvider;
  String image;

  MyUser(
      {required this.uid,
      this.firstname = "test",
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

  populateUserInfoFromFirebase() async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (snap.exists) {
      lastname = (snap.data()!["lastname"] != null ? snap.data()!["lastname"] : "");
      firstname = (snap.data()!["firstname"] != null ? snap.data()!["firstname"] : "");
      isPremium = (snap.data()!["isPremium"] != null ? snap.data()!["isPremium"] : false);
      isServiceProvider = (snap.data()!["isServiceProvider"] != null ? snap.data()!["isServiceProvider"] : false);
      image = (snap.data()!["image"] != null ? snap.data()!["image"] : "");
      print(this);
    }
  }
}
