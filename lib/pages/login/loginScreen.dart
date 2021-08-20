import 'dart:developer';

import 'package:artnext/services/AuthenticationService.dart';
import 'package:artnext/models/myuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'loginScreen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthenticationService _auth =
      AuthenticationService();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    log("LoginScreen - build - start");
    usernameController.text = "user@artnext.ch";
    passwordController.text = "test123";

    return Scaffold(
        body: Form(
          key: _formKey,
          child: Align(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                    padding: EdgeInsets.only(left: 60, right: 60),
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: const Color(0xffa3a3a3),
                      image: DecorationImage(
                        image: AssetImage('assets/images/login.png'),
                        fit: BoxFit.fill,
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.4), BlendMode.dstATop),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 75),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "ArtNext",
                              style: TextStyle(
                                  fontSize: 70.0,
                                  color: Colors.white,
                                  fontFamily: 'RichieBrusher'),
                            ),
                          ],
                        ),
                        // SizedBox(height: 250),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 250),
                                child: Text("Username"),
                              )
                            ]),

                        TextFormField(
                            controller: usernameController,
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'User',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the username';
                              }
                              return null;
                            }),

                        SizedBox(height: 20),
                        TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the password';
                              }
                              return null;
                            }),
                        SizedBox(height: 20),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        side: BorderSide(
                                            color: Colors.teal, width: 2.0)))),

                            // Within the `FirstScreen` widget
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Object? result = await _auth.signIn(
                                    email: usernameController.text,
                                    password: passwordController.text);
                                if (result is MyUser) {
                                  // result is user => login successful
                                  log(result.uid);
                                } else {}
                              }

                              /*Provider.of<User>(context, listen: false);

                          log("LoginScreen - connection");

                          // TODO : voir pourquoi la ligne suivante ne remonte pas l'UID de l'utilisateur

                          //context.read<AuthenticationService>().signIn(email: "sylvain.meyer@students.hevs.ch", password: "Qwertz.1234");
                          context.read<AuthenticationService>().signIn(
                              email: "david.crittin@students.hevs.ch",
                              password: "testtest");

                          final firebaseUser = context.watch<User?>();

                          if (firebaseUser != null) {
                            log("LoginScreen - Signed in");

                            // Navigate to the second screen using a named route.
                            Navigator.pushNamedAndRemoveUntil(context,
                                ListEventsScreen.routeName, (_) => false);
                          } else {
                            log("LoginScreen - Not signed in");
                          }*/
                            },
                            child: Text('Connexion')),
                      ],
                    ));
              },
            ),
          ),

          /*Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
            crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
          children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/login.png'), //   <--- image
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  // Within the `FirstScreen` widget
                    onPressed: () {
                      // Navigate to the second screen using a named route.
                      Navigator.pushNamedAndRemoveUntil(context,
                          ListEventsScreen.routeName, (_) => false);
                    },
                    child: Text('Connexion (fake)')
                )
              ],
            )
          ],
        ),

        /*ElevatedButton(
        // Within the `FirstScreen` widget
        onPressed: () {
          // Navigate to the second screen using a named route.
          Navigator.pushNamedAndRemoveUntil(context, ListEventsScreen.routeName, (_) => false);
        },
        child: Text('Connexion (fake)'),*/
      )*/
        ));
  }
}
