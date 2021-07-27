import 'dart:developer';

import 'package:artnext/pages/ListEventsScreen.dart';
import 'package:flutter/material.dart';

export 'loginScreen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    log("LoginScreen - build - start");

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            new Row(
              children: [
                Image.asset('assets/images/login.png'), //   <--- image
              ],
            ),
            new Row(
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
      )
      ,
    );

  }
}
