import 'package:artnext/models/ScreenArguments.dart';
import 'package:artnext/models/event.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:artnext/pages/events/DisplayEvenementScreen.dart';
import 'package:artnext/widget/readTimeStamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'manage/CreateEvenementScreen.dart';

export 'ListEventsScreen.dart';

/// Screen for displaying the event based on a filter
class ListEventsFilteredScreen extends StatefulWidget {
  ListEventsFilteredScreen({Key? key}) : super(key: key);

  static const routeName = '/eventsfilter';

  var selectedOrderBy = "Start date";
  var orderByFirebase = "startDate";

  ListEventsFilteredScreenState createState() {
    return ListEventsFilteredScreenState();
  }
}

class ListEventsFilteredScreenState extends State<ListEventsFilteredScreen> {
  @override
  Widget build(BuildContext context) {
    final filter =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final user = Provider.of<MyUser?>(context);

    return Scaffold(
      appBar: MyAppBar("Events filter by " + filter.genre, false),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .where(filter.genre, isEqualTo: filter.recherche)
                    .snapshots(),
                builder: buildEventsList,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: user!.isServiceProvider
          ? FloatingActionButton(
              elevation: 0.0,
              onPressed: () {
                Navigator.pushNamed(context, CreateEvenementScreen.routeName);
              },
              child: const Icon(Icons.add),
            )
          : Container(),
    );
  }
}

Widget buildEventsList(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData && snapshot.data!.docs.length > 0) {
    return Column(
      children: <Widget>[
        Text(
          readTimestampYear(Event.fromJson(snapshot.data!.docs[0])
              .startDate
              .millisecondsSinceEpoch),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot eventFromFirebase = snapshot.data!.docs[index];
                Event event = Event.fromJson(eventFromFirebase);
                var datum =
                    readTimestamptoDate(event.startDate.millisecondsSinceEpoch);
                var eventTypeTransform = event.type
                    .toString()
                    .toLowerCase()
                    .replaceAll('eventtypeenum.', '');

                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text((event.title.length > 100)
                        ? event.title.substring(0, 100) + ("[...]")
                        : event.title),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                          eventTypeTransform.substring(0, 1).toUpperCase() +
                              eventTypeTransform.substring(
                                1,
                              )),
                    ),
                    leading: SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: ClipRRect(
                          // borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          child: FadeInImage(
                        image: NetworkImage(event.image),
                        placeholder:
                            AssetImage('assets/images/placeholder.jpg'),
                        imageErrorBuilder: (BuildContext context,
                            Object exception, StackTrace? stacktrace) {
                          return Container(
                            child: FadeInImage(
                              image:
                                  AssetImage('assets/images/placeholder.jpg'),
                              placeholder:
                                  AssetImage('assets/images/placeholder.jpg'),
                            ),
                          );
                        },
                      )),
                    ),
                    onTap: () => {
                      Navigator.pushNamed(
                          context, DisplayEvenementScreen.routeName,
                          arguments: event)
                    },
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Text(datum),
                        ),
                        Text(event.city),
                      ],
                    ),
                    isThreeLine: true,
                  ),
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
    // return Center(child: CircularProgressIndicator());
    return Center(
      child: Text("No events found."),
    );
  }
}
