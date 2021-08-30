import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/myuser.dart';

class AuthenticationService {
  //final FirebaseAuth _firebaseAuth;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationService();

  //Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // create user object base on FirebaseUser
  MyUser? _userFromFirebaseUser(User user) {
    if(user == null) return null;
    MyUser myUser = MyUser(uid: user.uid);
    myUser.populateUserInfoFromFirebase();
    return myUser;
  }

  // complete the user object with info from the "users" collection
  Future _populateUserInfoFromCollection(User user) async {
    return null;
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((User? user) {
      return _userFromFirebaseUser(user!);
    });
  }

  Future signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print("AuthenticationService - signIn - returned user uid = " + user!.uid);
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      print("AuthenticationService - signIn - FireBaseAuthException message = " +e.message.toString());
      return e.message;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

/*Future<String?> signUp({required String email, required String password}) async{
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }*/

}
