import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/myuser.dart';

class AuthenticationService {
  //final FirebaseAuth _firebaseAuth;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationService();

  //Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // create user object base on FirebaseUser
  MyUser? _userFromFirebaseUser(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  /*Future<String?> signIn({required String email, required String password}) async{
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      log(user!.uid);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      return e.message;
    }
  }*/

  Stream<MyUser?> get user{
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user!));
  }

  Future signIn({required String email, required String password}) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      log(user!.uid);
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      return e.message;
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e) {
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