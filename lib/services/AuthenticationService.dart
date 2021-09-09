import 'package:firebase_auth/firebase_auth.dart';

import '../models/myuser.dart';

/// Manage the authentication with Firebase
class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationService();

  /// create user object base on FirebaseUser
  MyUser? _userFromFirebaseUser(User user) {
    if (user == null) return null;
    MyUser myUser = MyUser();
    myUser.setEmail(_auth.currentUser!.email.toString());
    myUser.setUid(user.uid);
    myUser.populateUserInfoFromFirestore();
    return myUser;
  }

  /// complete the user object with info from the "users" collection
  Future _populateUserInfoFromCollection(User user) async {
    return null;
  }

  /// sync the user status with firebase
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((User? user) {
      return _userFromFirebaseUser(user!);
    });
  }

  /// Tries to sign in with email and password, and returns a MyUser if successful
  Future signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print(
          "AuthenticationService - signIn - returned user uid = " + user!.uid);
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      print(
          "AuthenticationService - signIn - FireBaseAuthException message = " +
              e.message.toString());
      return e.message;
    }
  }

  /// Sign out from the current account
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  /// Allows to sign up with given credentials, creates the account in Firebase
  Future signUp(
      {required String email,
      required String password,
      required MyUser myUser}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //MyUser user = MyUser(uid: result.user!.uid);
      myUser.setUid(result.user!.uid);
      print(myUser);
      await myUser.saveToFirestore();
      return myUser;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
