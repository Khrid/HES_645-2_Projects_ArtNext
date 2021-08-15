import 'dart:developer' as dev;
import 'dart:math';

import 'package:artnext/models/event.dart';
import 'package:artnext/pages/ListEventsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'CreateEvenementScreen.dart';

class CreateEvenementScreen extends StatefulWidget {
  static const routeName = '/events/event/create';

  const CreateEvenementScreen({Key? key}) : super(key: key);

  CreateEvenementScreenState createState() {
    return CreateEvenementScreenState();
  }
}

class CreateEvenementScreenState extends State<CreateEvenementScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController eventNameController = new TextEditingController();
  TextEditingController eventCityController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference events =
        FirebaseFirestore.instance.collection("events");

    Future<void> addEvent(Event e) async {
      Event tmp = e;
      events.add(e.toJson()).then((value) => dev.log(value.id.toString()));
      //return tmp;
    }

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Create event'),
        ),
        body: Form(
          key: _formKey,
          child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                          controller: eventNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Event name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the event\'s name';
                            }
                            return null;
                          }),
                      SizedBox(height: 20),
                      TextFormField(
                          controller: eventCityController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Event city'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the event\'s city';
                            }
                            return null;
                          }),
                      SizedBox(height: 50),
                      ElevatedButton(
                          // Within the `FirstScreen` widget
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Event e = new Event(
                                  title: eventNameController.text,
                                  city: eventCityController.text,
                                  image: "imagePath",
                                  startDate: Timestamp.fromDate(DateTime.now()
                                      .add(Duration(
                                          days: new Random().nextInt(31)))),
                                details: 'detailEnDur'
                              );

                              addEvent(e);
                              // Navigate to the second screen using a named route.
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: const Text('Event created'),
                                      duration: Duration(seconds: 2)));
                              Navigator.pushNamedAndRemoveUntil(context,
                                  ListEventsScreen.routeName, (route) => false);
                            }
                          },
                          child: Text('Create event'))
                    ],
                  ))),
        ));
  }
}
