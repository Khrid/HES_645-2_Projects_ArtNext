import 'dart:developer';

import 'package:artnext/models/event.dart';
import 'package:artnext/pages/common/MyDrawer.dart';
import 'package:artnext/pages/events/DisplayEvenementScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'events/CreateEvenementScreen.dart';

export 'ListEventsScreen.dart';

class ListEventsScreen extends StatelessWidget {
  static const routeName = '/events';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: StreamBuilder(stream: FirebaseFirestore.instance
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
      drawer: MyDrawer(""),
    );
  }
}

Widget buildEventsList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData) {
    return ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          DocumentSnapshot eventFromFirebase = snapshot.data!.docs[index];
          //log(event.reference.id);
          Event event = Event.fromJson(eventFromFirebase);
          log("ListEventsScreen - buildEventsList - event #" +
              index.toString() +
              " = " +
              event.id);
          return ListTile(

            title: Text(event.title),
            subtitle: Text(event.city),
            // TODO décommenter pour remettre l'image
            /*leading: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                child:
                FadeInImage(
                  image: NetworkImage((event.image.contains("http") ? event.image : "https://cdn1.iconfinder.com/data/icons/business-company-1/500/image-512.png")),
                  placeholder: AssetImage('https://cdn1.iconfinder.com/data/icons/business-company-1/500/image-512.png'),
                  // CachedNetworkImage(
                  //     placeholder: (context, url) => CircularProgressIndicator(),
                  //     imageUrl: event.image,
                  // ),
                )),*/
            onTap: () => {
              Navigator.pushNamed(context, DisplayEvenementScreen.routeName,
                  arguments: event)
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
