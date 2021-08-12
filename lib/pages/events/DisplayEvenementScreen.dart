import 'dart:developer';

import 'package:artnext/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'DisplayEvenementScreen.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:artnext/models/favoriteWidget.dart';

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
      body:StreamBuilder(
        stream: FirebaseFirestore.instance
          .collection('events')
          .doc(event.id)
          .snapshots(),
        builder: buildEventDetails,

      ),
    );

  }
}

Widget buildEventDetails(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){

  //Widget for buttons Share and participate
  Widget buttonSection = Container(
      padding:const EdgeInsets.all(8),
      child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButtonColumn(Colors.black, Icons.share, "Share"),
            FavoriteWidget(),
          ])
  );

  if (!snapshot.hasData) {
    return Center(child:CircularProgressIndicator());
  } else {
    var event = snapshot.data;
    Event e = Event.fromJson(event);
    //return new Text(e.title + " - " + e.city);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child:Text(e.title,
            style: TextStyle(
                fontSize: 22.0
            ),
          ),
        ),
        Stack(children: [
          Container(
            width: 600,
            height: 240,
            child: Center(child:CircularProgressIndicator()),
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
          child:Column(
            children: [
              Text("Details : " + e.details,
                softWrap: true,
              ),
              Container(
                  padding: const EdgeInsets.only(top: 30),
                  child:Text("Lieu : " + e.city)
              ),

            ],
          ),
        ),
        buttonSection,
        Text( "Attendees : ",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
            padding: const EdgeInsets.all(8),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttendees(e),
                _buildAttendees(e),
                _buildAttendees(e),
              ],
            ))
      ] ,
    );
  }

}

//Button share
Column _buildButtonColumn(Color color, IconData icon, String label){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          padding: const EdgeInsets.only(bottom: 8),
          child:Icon(icon, color:color)),
      Text(label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color:color,
          ))
    ],
  );
}

Column _buildAttendees(Event e){
  return      Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(e.image),
              fit: BoxFit.fill
          ),
        ),
      ),
      Text("Le nom")
    ],
  );
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
              event.toString());
          return ListTile(

            title: Text(event.title),
            subtitle: Text(event.city),
            leading: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                child:
                FadeInImage(image: NetworkImage(event.image),
                  placeholder: AssetImage('https://cdn1.iconfinder.com/data/icons/business-company-1/500/image-512.png'),
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
