import 'package:artnext/models/event.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:artnext/pages/events/DisplayEvenementScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

/// Screen for displaying the user information
class UserInfo extends StatefulWidget {
  static const routeName = '/user/info';

  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    var user;
    bool ownAccount = false;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      user = ModalRoute.of(context)!.settings.arguments as MyUser;
    } else {
      user = Provider.of<MyUser?>(context);
      ownAccount = true;
    }

    return Scaffold(
        appBar: MyAppBar(ownAccount ? "My info" : "User info", false),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            buildName(user!, ownAccount),
            const SizedBox(height: 24),
            ownAccount
                ? Center(child: buildUpgradeButton(user.isPremium))
                : SizedBox(),
            ownAccount ? const SizedBox(height: 24) : SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  onPressed: () {},
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      user.isPremium
                          ? FaIcon(
                              FontAwesomeIcons.solidStar,
                              size: 24,
                            )
                          : FaIcon(
                              FontAwesomeIcons.star,
                              size: 24,
                            ),
                      SizedBox(height: 2),
                      Text(
                        user.isPremium ? "Premium" : "Not premium",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 24,
                  child: VerticalDivider(),
                ),
                MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  onPressed: () {},
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      user.isServiceProvider
                          ? FaIcon(
                              FontAwesomeIcons.palette,
                              size: 24,
                            )
                          : FaIcon(
                              FontAwesomeIcons.user,
                              size: 24,
                            ),
                      SizedBox(height: 2),
                      Text(
                        user.isServiceProvider
                            ? "Service provider"
                            : "User account",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            buildMyEventsTitle(),
            const SizedBox(height: 24),
            Container(
              child: SizedBox(
                height: 400.0,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('events')
                      .where('listAttendees', arrayContains: user.uid)
                      .snapshots(),
                  builder: buildEventsList,
                ),
              ),
            ),
            //const SizedBox(height: 48),
            //buildAbout(user),
          ],
        ));
  }

  Widget buildName(MyUser user, bool ownAccount) => Column(
        children: [
          Text(
            user.firstname + " " + user.lastname,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          ownAccount
              ? Text(
                  user.email! + "",
                  style: TextStyle(color: Colors.grey),
                )
              : SizedBox()
        ],
      );

  Widget buildUpgradeButton(bool isPremium) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: Text(isPremium ? "Downgrade to CLASSIC" : "Upgrade to PREMIUM"),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Not implemented yet 😉'),
              duration: Duration(seconds: 2)));
        },
      );

  Widget buildMyEventsTitle() => Column(
        children: [
          Text(
            "Attendency history",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ],
      );
}

Widget buildEventsList(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot eventFromFirebase = snapshot.data!.docs[index];
                //log(event.reference.id);
                Event event = Event.fromJson(eventFromFirebase);
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text((event.title.length > 100)
                        ? event.title.substring(0, 100) + ("[...]")
                        : event.title),
                    onTap: () => {
                      Navigator.pushNamed(
                          context, DisplayEvenementScreen.routeName,
                          arguments: event)
                    },
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
