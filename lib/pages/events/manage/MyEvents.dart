import 'package:artnext/models/event.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:artnext/pages/common/MyDrawer.dart';
import 'package:artnext/widget/readTimeStamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CreateEvenementScreen.dart';
import '../DisplayEvenementScreen.dart';

class MyEvents extends StatelessWidget {
  static const routeName = '/events/manage/';

  late MyUser? user;

/*
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {*/
  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);
    print("MyEvents - user = " + user.toString());
    return Scaffold(
      appBar: MyAppBar("My events", false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    //.orderBy('endDate')
                    //.where('endDate', isGreaterThan: DateTime.now())
                    .where('organizer', isEqualTo: user!.uid)
                    .snapshots(),
                builder: buildEventsList,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        onPressed: () {
          Navigator.pushNamed(context, CreateEvenementScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
      drawer: MyDrawer(""),
    );
  }
}

Widget buildEventsList(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData) {
    if (!snapshot.data!.docs.isEmpty) {
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
                  MyUser? user = Provider.of<MyUser?>(context);
                  DocumentSnapshot eventFromFirebase =
                      snapshot.data!.docs[index];
                  //log(event.reference.id);
                  Event event = Event.fromJson(eventFromFirebase);
                  // log("ListEventsScreen - buildEventsList - event #" +
                  //     index.toString() +
                  //     " = " +
                  //     event.id);

                  var datum = readTimestamptoDate(
                      event.startDate.millisecondsSinceEpoch);
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
    } else {
      return Center(
        child: Text("No events found."),
      );
    }
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
