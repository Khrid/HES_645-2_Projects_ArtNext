import 'package:flutter/material.dart';
import 'pages/firstScreen.dart';
import 'pages/secondScreen.dart';
import 'pages/thirdScreen.dart';

//Sam Test

void main() {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => FirstScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => SecondScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/third': (context) => ThirdScreen(),
      },
    ),
  );
}

/*
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



