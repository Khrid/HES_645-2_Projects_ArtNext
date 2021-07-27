import 'dart:developer';

import 'package:artnext/models/event.dart';
import 'package:artnext/pages/events/DisplayEvenementScreen.dart';
import 'package:artnext/pages/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'events/CreateEvenementScreen.dart';
import 'events/CrudEvenementArguments.dart';

export 'ListEventsScreen.dart';

class ListEventsScreen extends StatelessWidget {
  static const routeName = '/events';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('startDate', descending: true)
            .snapshots(),
        builder: buildEventsList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreateEvenementScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('ArtNext'),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildEventsList(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData) {
    return ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          DocumentSnapshot event = snapshot.data!.docs[index];
          //log(event.reference.id);
          Event e = Event.fromJson(event);
          log(e.toString());
          return ListTile(
            title: Text(e.title),
            subtitle: Text(e.city),
            onTap: () => {
              Navigator.pushNamed(context, DisplayEvenementScreen.routeName,
                  arguments: CrudEvenementArguments(e))
            },
          );
        });
  } else if (snapshot.connectionState == ConnectionState.done &&
      !snapshot.hasData) {
    // Handle no data
    return Center(
      child: Text("No events found."),
    );
  } else {
    // Still loading
    return CircularProgressIndicator();
  }
}
