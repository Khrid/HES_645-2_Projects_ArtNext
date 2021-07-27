import 'dart:developer';

import 'package:artnext/pages/events/CrudEvenementArguments.dart';
import 'package:artnext/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'DisplayEvenementScreen.dart';

class DisplayEvenementScreen extends StatelessWidget {
  static const routeName = '/events/event/display';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CrudEvenementArguments;
    Event? event = args.event;
    log(event.toString());
    log(event!.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Event detail'),
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
              return new Text(e.title);
            }
          }),
    );
  }
}
