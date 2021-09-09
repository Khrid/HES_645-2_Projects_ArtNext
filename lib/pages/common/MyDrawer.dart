import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/about/AboutScreen.dart';
import 'package:artnext/pages/events/ListEventsScreen.dart';
import 'package:artnext/pages/events/manage/MyEvents.dart';
import 'package:artnext/pages/help/HelpScreen.dart';
import 'package:artnext/pages/login/LoginScreen.dart';
import 'package:artnext/pages/user/SearchUser.dart';
import 'package:artnext/pages/user/UserInfo.dart';
import 'package:artnext/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/AuthenticationService.dart';

/// Custom Drawer that is used inside the Screen
class MyDrawer extends StatelessWidget {
  MyDrawer(this.currentPage);

  final String currentPage;
  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            // ListView contains a group of widgets that scroll inside the drawer
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      //    (user!.isServiceProvider) ? Colors.blue : Colors.lightGreen,
                    ),
                    child: Column(
                      children: [
                        Text("ArtNext",
                            style: TextStyle(
                                fontSize: 65.0,
                                color: Colors.white,
                                fontFamily: 'RichieBrusher')),
                        RichText(
                          text: TextSpan(
                              text:
                                  'Made with love by David, Micaela, Quentin, Samuel & Sylvain',
                              style: TextStyle(
                                  fontSize: 10.0, fontStyle: FontStyle.italic)),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Hello " + user!.firstname + " " + user.lastname,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //Center Row contents horizontally,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //Center Row contents vertically,
                          children: [
                            user.isPremium
                                ? FaIcon(
                                    FontAwesomeIcons.solidStar,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                : Container(),
                            (user.isServiceProvider && user.isPremium)
                                ? SizedBox(width: 15)
                                : Container(),
                            user.isServiceProvider
                                ? FaIcon(
                                    FontAwesomeIcons.palette,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                : Container()
                          ],
                        )
                      ],
                    )),
                ListTile(
                  leading: Icon(Icons.person),
                  title: const Text('My account'),
                  onTap: () async {
                    // Update the state of the app.
                    // ...
                    Navigator.pushNamed(context, UserInfo.routeName);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.event),
                  title: const Text('Event calendar'),
                  onTap: () async {
                    // Update the state of the app.
                    // ...
                    Navigator.pushNamed(context, ListEventsScreen.routeName);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.search_sharp),
                  title: const Text('Search a user'),
                  onTap: () async {
                    // Update the state of the app.
                    // ...
                    Navigator.pushNamed(context, SearchUser.routeName);
                  },
                ),
                user.isServiceProvider
                    ? ListTile(
                        leading: Icon(Icons.event_available),
                        title: Text("Manage my events"),
                        onTap: () async {
                          // Update the state of the app.
                          // ...
                          Navigator.pushNamed(context, MyEvents.routeName);
                        },
                      )
                    : Container(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    // Update the state of the app.
                    // ...
                    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                    await _auth.signOut();
                  },
                ),
              ],
            ),
          ),
          // This container holds the align
          Container(
              // This align moves the children to the bottom
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  // This container holds all the children that will be aligned
                  // on the bottom and should not scroll with the above ListView
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text('About'),
                        onTap: () {
                          Navigator.pushNamed(context, AboutScreen.routeName);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text('Help and Feedback'),
                        onTap: () {
                          Navigator.pushNamed(context, HelpScreen.routeName);
                        },
                      )
                    ],
                  ))))
        ],
      ),
    );
  }
}
