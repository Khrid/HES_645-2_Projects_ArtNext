import 'package:artnext/models/event.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:artnext/pages/common/MyDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

export 'ListEventsScreen.dart';

class ListAttendees extends StatelessWidget {
  static const routeName = '/events/event/display/attendees';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final event = ModalRoute.of(context)!.settings.arguments as Event;
    print("ListAttendees - user = " + user.toString() + " " + event.toString());
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: MyAppBar("Attendees", false),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .doc(event.id)
                    .snapshots(),
                builder: buildAttendeesList,
              ),
            ),
          ),
        ],
      ),
      //drawer: MyDrawer(""),
    );
  }
}

Widget buildAttendeesList(
    BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  if (snapshot.hasData) {
    var event = snapshot.data;
    Event e = Event.fromJson(event);
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: e.listAttendees.length,
              itemBuilder: (context, index) {
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(e.listAttendees[index].toString())
                        .snapshots(),
                    builder: buildAttendeeCard);
                /*MyUser tmp = MyUser();
                  tmp.setUid(e.listAttendees[index].toString());
                  tmp.populateUserInfoFromFirestore();
                  print(tmp);
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                          tmp.firstname + " " + tmp.lastname),
                      leading: SizedBox(
                        height: 100.0,
                        width: 100.0,
                      ),
                      //isThreeLine: true,
                    ),
                  );*/
              }),
        ),
      ],
    );
  } else {
    return Text("No attendees yet :(");
  }
}

Widget buildAttendeeCard(BuildContext context,
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
  if (snapshot.hasData) {
    var attendee = snapshot.data;
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(attendee!["lastname"].toString() +
            " " +
            attendee["firstname"].toString()),
        leading: SizedBox(
          height: 100.0,
          width: 100.0,
        ),
        //isThreeLine: true,
      ),
    );
  } else {
    return Column();
  }
}
