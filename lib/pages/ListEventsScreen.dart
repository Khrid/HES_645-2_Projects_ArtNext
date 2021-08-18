import 'dart:developer';
import 'dart:js';

import 'package:artnext/models/event.dart';
import 'package:artnext/pages/common/MyDrawer.dart';
import 'package:artnext/pages/events/DisplayEvenementScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:15.0, bottom:10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Filter by'),
                ),
                SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Sorted by'),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: StreamBuilder(stream: FirebaseFirestore.instance
                    .collection('events')
                    .orderBy('startDate', descending: true)
                  .where('startDate', isGreaterThan: DateTime.now())
                    .snapshots(),
                builder: buildEventsList,
              ),
            ),
          ),
        ],
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

String readTimestamp(int timestamp) {
  initializeDateFormatting('fr_CH', null);
  var now = new DateTime.now();
  var format = new DateFormat('dd/MM/yyy');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var diff = date.difference(now);
  var time = '';
  var timer = format.format(date);

  // if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
  //   time = format.format(date);
  // } else {
  //   if (diff.inDays == 1) {
  //     time = diff.inDays.toString() + 'DAY AGO';
  //   } else {
  //     time = diff.inDays.toString() + 'DAYS AGO';
  //   }
  // }

  return timer;
}
String readTimestamp2(int timestamp) {
  initializeDateFormatting('fr_CH', null);
  var now = new DateTime.now();
  var format = new DateFormat('yyy');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var diff = date.difference(now);
  var time = '';
  var timer = format.format(date);

  // if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
  //   time = format.format(date);
  // } else {
  //   if (diff.inDays == 1) {
  //     time = diff.inDays.toString() + 'DAY AGO';
  //   } else {
  //     time = diff.inDays.toString() + 'DAYS AGO';
  //   }
  // }

  return timer;
}

Widget buildEventsList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData) {
    return Column(
      children: <Widget>[
        Text(readTimestamp2(Event.fromJson(snapshot.data!.docs[0]).startDate.millisecondsSinceEpoch)),
        Expanded(
          child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot eventFromFirebase = snapshot.data!.docs[index];
                //log(event.reference.id);
                Event event = Event.fromJson(eventFromFirebase);
                // log("ListEventsScreen - buildEventsList - event #" +
                //     index.toString() +
                //     " = " +
                //     event.id);

                var Datum = readTimestamp(event.startDate.millisecondsSinceEpoch);

                return ListTile(
                  title: Text(event.title),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text( (event.details.length > 100) ? event.details.substring(0,100)+("[...]") : event.details),
                  ),
                  leading:  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: ClipRRect(
                        // borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          child: FadeInImage(
                            image: NetworkImage((event.image.contains("http") ? event.image : "assets/images/placeholder.jpg")),
                            placeholder: AssetImage('assets/images/placeholder.jpg'),
                          )),
                  ),

                  onTap: () => {
                    Navigator.pushNamed(context, DisplayEvenementScreen.routeName,
                        arguments: event)
                  },
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Text( Datum),
                      ),
                      Text( event.city),
                    ],
                  ),
                  isThreeLine: true,
                );


              }),
        ),
      ],
    );
  } else if (snapshot.connectionState == ConnectionState.done &&
      !snapshot.hasData) {
    // Handle no data
    return Center(
      child: Text("No events found."),
    );
  } else {
    // Still loading
    return Center(child: CircularProgressIndicator());
  }
}
