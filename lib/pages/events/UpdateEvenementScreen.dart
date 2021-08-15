import 'dart:developer' as dev;
import 'dart:math';

import 'package:artnext/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ListEventsScreen.dart';

export 'CreateEvenementScreen.dart';

class UpdateEvenementScreen extends StatefulWidget {
  static const routeName = '/events/event/update';

  const UpdateEvenementScreen({Key? key}) : super(key: key);

  UpdateEvenementScreenState createState() {
    return UpdateEvenementScreenState();
  }
}

class UpdateEvenementScreenState extends State<UpdateEvenementScreen> {
  final _formKey = GlobalKey<FormState>();
  Event? _event;
  late CollectionReference _events;
  TextEditingController eventNameController = new TextEditingController();
  TextEditingController eventCityController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Event? event = args.event;
    _event = ModalRoute.of(context)!.settings.arguments as Event;
    dev.log("UpdateEvenementScreen - event from args = " + _event!.id);

    eventNameController.text = _event!.title;
    eventCityController.text = _event!.city;

    _events = FirebaseFirestore.instance.collection("events");

    Future<void> updateEvent(Event e) async {
      _events.doc(e.id).update(e.toJson());
    }

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit event'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              // Within the `FirstScreen` widget
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Event e = new Event(
                                     id: _event!.id,
                                      title: eventNameController.text,
                                      city: eventCityController.text,
                                    startDate: _event!.startDate,
                                    image: _event!.image,
                                      details: _event!.details
                                  );

                                  updateEvent(e);
                                  // Navigate to the second screen using a named route.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: const Text('Event updated'),
                                          duration: Duration(seconds: 2)));
                                  //Navigator.pushNamedAndRemoveUntil(context,
                                  //    ListEventsScreen.routeName, (route) => false);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Update event')),
                          Container(width: 20, height: 20),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              // Within the `FirstScreen` widget
                              onPressed: () {
                                showAlertDialog(context);
                              },
                              child: Text('Delete event'))
                        ],
                      ),
                    ],
                  ))),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        _events.doc(_event!.id).delete();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Event deleted'),
                duration: Duration(seconds: 2)));
        Navigator.pushNamedAndRemoveUntil(context,
            ListEventsScreen.routeName, (route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Event deletion"),
      content: Text("Do you really want to delete this event?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
