import 'dart:developer';

import 'package:artnext/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/src/provider.dart';

import 'ListEventsScreen.dart';

export 'loginScreen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    log("LoginScreen - build - start");

    return Scaffold(
      body: Align(
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
                            fontFamily: 'RichieBrusher'
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 250),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top:250),

                            child: Text("Username"),
                        )
                      ]
                    ),


                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(color: Colors.teal, width: 2.0)
                                )
                            )
                        ),

                        // Within the `FirstScreen` widget
                        onPressed: () {

                          Provider.of<User>(context,listen:false);

                          log("LoginScreen - connection");

                          // TODO : voir pourquoi la ligne suivante ne remonte pas l'UID de l'utilisateur

                          context.read<AuthenticationService>().signIn(email: "sylvain.meyer@students.hevs.ch", password: "Qwertz.1234");

                          final firebaseUser = context.watch<User>();

                          if(firebaseUser != null){
                            log("LoginScreen - Signed in");

                            // Navigate to the second screen using a named route.
                            Navigator.pushNamedAndRemoveUntil(context,
                                ListEventsScreen.routeName, (_) => false);
                          }else {
                            log("LoginScreen - Not signed in");
                          }

                        },
                        child: Text('Connexion')

                    ),




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
    );
  }
}
