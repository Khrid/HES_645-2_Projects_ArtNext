import 'dart:developer';

import 'package:artnext/models/event.dart';
import 'package:artnext/pages/events/UpdateEvenementScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'DisplayEvenementScreen.dart';

class DisplayEvenementScreen extends StatelessWidget {
  static const routeName = '/events/event/display';

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as Event;
    //Event? event = args.event;
    log("DisplayEvenementScreen - event from args = " + event.id);
    //log(event!.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Event detail'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, UpdateEvenementScreen.routeName, arguments: event);
        },
        child: Icon(Icons.edit),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('events')
              .doc(event.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              var event = snapshot.data;
              Event e = Event.fromJson(event);
              //return new Text(e.title + " - " + e.city);
              return Column(
                children: [
                  Row(
                    children: [Image.asset("assets/images/login.png")],
                  ),
                  Row(
                    children: [new Text(e.title)],
                  ),
                  Row(
                    children: [new Text(e.city)],
                  )
                ],
              );
            }
          }),
    );
  }
}
