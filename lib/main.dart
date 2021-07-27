import 'dart:developer';

import 'package:artnext/pages/events/CreateEvenementScreen.dart';
import 'package:artnext/pages/events/CrudEvenementArguments.dart';
import 'package:artnext/pages/events/DisplayEvenementScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/loginScreen.dart';
import 'pages/ListEventsScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    log('initializeFlutterFire - start');
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
      log('initializeFlutterFire - _initialized = true');
    }
    catch(e) {
      log('initializeFlutterFire - error');
      setState(() {
        _error = true;
      });
    }
    log('initializeFlutterFire - end');
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(_error) {
      // TODO: handle error
    }

    if(!_initialized) {
      // TODO: handle initialization error
    }

    return
      MaterialApp(
        title: 'NextArt',
        theme: ThemeData.light(),
        // Start the app with the "/" named route. In this case, the app starts
        // on the FirstScreen widget.
        initialRoute: LoginScreen.routeName,
        routes: {
          /**
           * Réflexion pour les routes
           * /
           * /login
           *
           * /events => pour la liste des évenements
           * /events/id => le détail d'un event
           * /events/id/attendees => liste des gens qui viennent à un event
           * /events/create
           * /events/modify/id ou /events/id/modify
           *
           * /account/ => info utilisateur
           * /account/upgrade => pour passer en premium
           *
           * /search => pour chercher quelqu'un
           * /user/id/attendencyHistory => historique de participation d'un user (à voir pour le nom)
           *
           * */
          LoginScreen.routeName: (context) => LoginScreen(), // /login
          ListEventsScreen.routeName: (context) => ListEventsScreen(), // /events
          DisplayEvenementScreen.routeName : (context) => DisplayEvenementScreen(), // /events/details
          CreateEvenementScreen.routeName : (context) => CreateEvenementScreen() // /events/details
        },
      );
  }
}
