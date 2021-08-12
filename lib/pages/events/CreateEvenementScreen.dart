import 'dart:developer' as dev;
import 'dart:math';

import 'package:artnext/models/event.dart';
import 'package:artnext/pages/ListEventsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'CreateEvenementScreen.dart';

class CreateEvenementScreen extends StatelessWidget {
  static const routeName = '/events/event/create';

  @override
  Widget build(BuildContext context) {
    CollectionReference events =
    FirebaseFirestore.instance.collection("events");

    Future<void> addEvent(Event e) async {
      Event tmp = e;
      events.add(e.toJson()).then((value) =>
          dev.log(value.id.toString())
    );
      //return tmp;

    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Create event'),
      ),
      body: Center(
          child: Column(
            children: [
              Text("Creation screen to build"),
              ElevatedButton(
                // Within the `FirstScreen` widget
                  onPressed: () {
                    Event e = new Event(
                        title: "Random #" +
                            new Random().nextInt(1000).toString(),
                        details: "Description of event",
                        city: "Martigny",
                        image: "imagePath",
                        startDate: Timestamp.fromDate(DateTime.now().add(
                            Duration(days: new Random().nextInt(31)))));

                    addEvent(e);
                    // Navigate to the second screen using a named route.
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Clickity click'),
                        duration: Duration(seconds: 2)));
                    Navigator.pushNamedAndRemoveUntil(
                        context, ListEventsScreen.routeName, (route) => false);
                  },
                  child: Text('Create event'))
            ],
          )),
    );
  }
}
