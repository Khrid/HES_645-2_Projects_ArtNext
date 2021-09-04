import 'package:artnext/models/event.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:artnext/pages/events/ListAttendeesScreen.dart';
import 'package:artnext/pages/events/manage/UpdateEvenementScreen.dart';
import 'package:artnext/pages/user/UserInfo.dart';
import 'package:artnext/widget/participateWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:artnext/widget/readTimeStamp.dart';
import 'package:url_launcher/url_launcher.dart';

export 'DisplayEvenementScreen.dart';

class DisplayEvenementScreen extends StatelessWidget {
  static const routeName = '/events/event/display';
  late final MyUser user;

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as Event;
    user = Provider.of<MyUser>(context);
    bool canEdit = false;
    if ((user.uid == event.organizer) && user.isServiceProvider) canEdit = true;

    return Scaffold(
      appBar: MyAppBar("Event detail", false),
      floatingActionButton: canEdit
          ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, UpdateEvenementScreen.routeName,
              arguments: event);
        },
        child: Icon(Icons.edit),
      )
          : Container(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(event.id)
            .snapshots(),
        builder: buildEventDetails,
      ),
    );
  }

  Widget buildEventDetails(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    if (!snapshot.hasData) {
      return Center(child: CircularProgressIndicator());
    } else {
      var event = snapshot.data;
      Event e = Event.fromJson(event);

      //Buttons
      Widget shareAndParticipateButtons = Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _buildButtonShare(e.city),
            _buildButtonDirection(e.address + ", " + e.city),
            SizedBox(width: 30),
            ParticipateWidget(user, e),
          ]));

      var attendees;
      // si on a bien des attendees
      if (e.listAttendees.length > 0) {
        attendees = GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: e.listAttendees.length,
          itemBuilder: (context, index) {
            // si on a 3 ou moins attendees, on affiche tout
            if (e.listAttendees.length <= 3) {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(e.listAttendees[index].toString())
                      .snapshots(),
                  builder: buildAttendeeInfo);
            } else {
              // si on en a plus, on affiche les trois premiers et un bouton "more"
              // on travaille avec l'index
              // si index 0 1 2 on affiche
              if (index <= 2) {
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(e.listAttendees[index].toString())
                        .snapshots(),
                    builder: buildAttendeeInfo);
              } else if (index == 3) {
                // si on est à l'index 3 => bouton "more"
                int howManyMore = e.listAttendees.length - index;
                return Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ListAttendees.routeName,
                              arguments: e);
                        },
                        child: CircleAvatar(
                          radius: 25,
                          child: Text(
                            "+" + howManyMore.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.brown[400],
                        )));
              } else {
                // pour les suivants, on ne fait plus rien
                return Container();
              }
            }
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
        );
      } else {
        attendees = Text("No attendees yet");
      }

      return Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            child: FadeInImage.memoryNetwork(
              image: (e.image),
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.2),
                        offset: Offset(0, -4),
                        blurRadius: 8)
                  ]),
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        e.title,
                        style: GoogleFonts.ptSans(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20),
                              child: Text(
                                "Du : " + readTimestamptoDate(e.startDate.millisecondsSinceEpoch) + " au " + readTimestamptoDate(e.endDate.millisecondsSinceEpoch),
                                textAlign: TextAlign.justify,
                                softWrap: true,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30),
                              child: Text(
                                "Details :\n\n" + e.details,
                                textAlign: TextAlign.justify,
                                softWrap: true,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  "Location :\n\n" + e.city,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ),
                      shareAndParticipateButtons,
                      const SizedBox(height: 24),
                      Text(
                        "Attendees : ",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(padding: const EdgeInsets.all(4), child: attendees)
                    ],
                  )),
            ),
          ),
        ],
      );
    }
  }

//Button share
  GestureDetector _buildButtonShare(String city) {
    return GestureDetector(
      onTap: () async {
        Share.share("Je participe bientôt à un super évènement à " + city + " ! \nRejoins-moi par ici !\n\nhttps://artnext.page.link/openapp");
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(child: Icon(Icons.share, color: Colors.black)),
          Text("Share",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ))
        ],
      ),
    );
  }

  GestureDetector _buildButtonDirection(String address) {
    return GestureDetector(
      onTap: () async {
        String query = Uri.encodeComponent(address);
        String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";
        await launch(googleUrl);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(child: Icon(Icons.directions, color: Colors.black)),
          Text("Directions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ))
        ],
      ),
    );
  }

  Widget buildAttendeeInfo(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    if (snapshot.hasData) {
      var attendee = snapshot.data;
      return Column(
        children: [
          Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.topCenter,
              //aligns CircleAvatar to Top Center.
              child: GestureDetector(
                onTap: () {
                  //TODO Est ce qu'il faut pouvoir atteindre les infos de l'utilisateur ? Quentin
                  // Navigator.pushNamed(context, UserInfo.routeName, arguments: attendee);
                },
                child: CircleAvatar(
                  radius: 25, //radius is 50
                  backgroundImage: NetworkImage(
                      "https://dza2a2ql7zktf.cloudfront.net/binaries-cdn/dqzqcuqf9/image/fetch/ar_16:10,q_auto:best,dpr_3.0,c_fill,w_376/https://d2u3kfwd92fzu7.cloudfront.net/asset/cms/THUMB_Art_Basel_2020_Francis_Picabia_1900-2000-3-1-11-3-1.jpg"),
                ),
              )
          ),
          Text(attendee!["firstname"].toString().substring(0, 1) +
              ". " +
              ((attendee["lastname"].toString().length > 5)
                  ? attendee["lastname"].toString().substring(0, 5) + "..."
                  : attendee["lastname"].toString()))
        ],
      );
    } else {
      return Column();
    }
  }
}
