import 'dart:developer';

import 'package:artnext/models/event.dart';
import 'package:artnext/pages/favoriteWidget.dart';
import 'package:artnext/pages/events/UpdateEvenementScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

export 'DisplayEvenementScreen.dart';

class DisplayEvenementScreen extends StatelessWidget {
  static const routeName = '/events/event/display';

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as Event;
    //Event? event = args.event;
    log("DisplayEvenementScreen - event from args = " + event.toString());
    //log(event!.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Event detail'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, UpdateEvenementScreen.routeName,
              arguments: event);
        },
        child: Icon(Icons.edit),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(event.id)
            .snapshots(),
        builder: buildEventDetails,
      ),
    );
  }
}

Widget buildAttendeeInfo(
    BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  if (snapshot.hasData) {
    var attendee = snapshot.data;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: NetworkImage(
                    "https://dza2a2ql7zktf.cloudfront.net/binaries-cdn/dqzqcuqf9/image/fetch/ar_16:10,q_auto:best,dpr_3.0,c_fill,w_376/https://d2u3kfwd92fzu7.cloudfront.net/asset/cms/THUMB_Art_Basel_2020_Francis_Picabia_1900-2000-3-1-11-3-1.jpg"),
                fit: BoxFit.fill),
          ),
        ),
        Text(attendee!["firstname"].toString().substring(0,1) + ". "+attendee["lastname"].toString())
      ],
    );
  } else {
    return Column();
  }
}

Widget buildEventDetails(
    BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //Widget for buttons Share and participate
  Widget buttonSection = Container(
      padding: const EdgeInsets.all(8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _buildButtonColumn(Colors.black, Icons.share, "Share"),
        FavoriteWidget(),
      ]));

  if (!snapshot.hasData) {
    return Center(child: CircularProgressIndicator());
  } else {
    var event = snapshot.data;
    Event e = Event.fromJson(event);
    //return new Text(e.title + " - " + e.city);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            e.title,
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Stack(
          children: [
            Container(
              width: 600,
              height: 240,
              child: Center(child: CircularProgressIndicator()),
            ),
            FadeInImage.memoryNetwork(
              image: (e.image),
              width: 600,
              height: 240,
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
            ),
          ],
        ),

        // Image.asset("assets/images/login.png")],
        Container(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Text(
                "Details : " + e.details,
                softWrap: true,
              ),
              Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text("Lieu : " + e.city)),
            ],
          ),
        ),
        buttonSection,
        Text(
          "Attendees : ",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Flexible(
            child: Container(
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 200.0,
          child:
              /*Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [*/
              StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("events")
                .doc(e.id)
                .collection("attendees")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  //return Column();
                  if (snapshot.data!.docs.length > 0) {
                    return ListView.builder(
                      padding: EdgeInsets.all(8.0),
                        physics: NeverScrollableScrollPhysics(),

                        ///
                        shrinkWrap: true,

                        ///
                        scrollDirection: Axis.horizontal,

                        ///

                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          log(snapshot.data!.docs[index]["ref"].id);
                          //return Container();

                          return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(snapshot.data!.docs[index]["ref"].id)
                                  .snapshots(),
                              builder: buildAttendeeInfo);
                        });
                  } else {
                    return Text("No attendees yet :(");
                  }
              }
            },
          )
          //_buildAttendees(e),
          //_buildAttendees(e),
          //_buildAttendees(e),
          ,
        ))
      ],
    );
  }
}

//Button share
Column _buildButtonColumn(Color color, IconData icon, String label) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Icon(icon, color: color)),
      Text(label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: color,
          ))
    ],
  );
}

Column _buildAttendees(Event e) {
  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage((e.image.contains("http")
                  ? e.image
                  : "https://cdn1.iconfinder.com/data/icons/business-company-1/500/image-512.png")),
              fit: BoxFit.fill),
        ),
      ),
      Text("Le nom")
    ],
  );
}

Widget buildEventsList(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              event.toString());
          return ListTile(
            title: Text(event.title),
            subtitle: Text(event.city),
            leading: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                child: FadeInImage(
                  image: NetworkImage(event.image),
                  placeholder: AssetImage(
                      'https://cdn1.iconfinder.com/data/icons/business-company-1/500/image-512.png'),
                  // CachedNetworkImage(
                  //     placeholder: (context, url) => CircularProgressIndicator(),
                  //     imageUrl: event.image,
                  // ),
                )),
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
