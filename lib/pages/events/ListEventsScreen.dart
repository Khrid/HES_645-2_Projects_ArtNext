
import 'package:artnext/models/event.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyFilterBar.dart';
import 'package:artnext/pages/common/MyDrawer.dart';
import 'package:artnext/pages/events/DisplayEvenementScreen.dart';
import 'package:artnext/widget/readTimeStamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'manage/CreateEvenementScreen.dart';

export 'ListEventsScreen.dart';

class ListEventsScreen extends StatelessWidget {
  static const routeName = '/events';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    print("ListEventScreen - user = " + user.toString());
    return Scaffold(
      backgroundColor: Colors.brown[100],

      appBar: MyFilterBar("Events"),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(top:15.0, bottom:10.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       ElevatedButton(
          //         onPressed: () {},
          //         child: const Text('Filter by'),
          //       ),
          //       SizedBox(width: 30),
          //       ElevatedButton(
          //         onPressed: () {},
          //         child: const Text('Sort by'),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: StreamBuilder(stream: FirebaseFirestore.instance
                    .collection('events')
                    .orderBy('endDate')
                  .where('endDate', isGreaterThan: DateTime.now())
                    .snapshots(),
                builder: buildEventsList,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        elevation:0.0,
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
    return Column(
      children: <Widget>[
        Text(readTimestampYear(Event.fromJson(snapshot.data!.docs[0]).startDate.millisecondsSinceEpoch),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
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

                var datum = readTimestamptoDate(event.startDate.millisecondsSinceEpoch);
                var eventTypeTransform = event.type.toString().toLowerCase()
                    .replaceAll('eventtypeenum.','');

                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text((event.title.length > 100) ? event.title.substring(0,100)+("[...]") : event.title),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(eventTypeTransform.substring(0,1).toUpperCase()+eventTypeTransform.substring(1,)),
                    ),
                    leading:  SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: ClipRRect(
                          // borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            child: FadeInImage(
                              image: NetworkImage(event.image),
                              placeholder: AssetImage('assets/images/placeholder.jpg'),
                              imageErrorBuilder: (BuildContext context, Object exception, StackTrace? stacktrace) {
                                return Container(
                                  child: FadeInImage(
                                    image: AssetImage('assets/images/placeholder.jpg'), placeholder: AssetImage('assets/images/placeholder.jpg'),
                                  ),
                                );
                              },
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
                          child: Text( datum),
                        ),
                        Text( event.city),
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
    return Center(child: CircularProgressIndicator());
  }
}
