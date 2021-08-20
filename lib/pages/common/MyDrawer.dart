import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/user/UserInfo.dart';
import 'package:artnext/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/AuthenticationService.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer(this.currentPage);

  final String currentPage;
  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    // TODO: implement build
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color:
                    (user!.isServiceProvider) ? Colors.blue : Colors.lightGreen,
              ),
              child: Column(
                children: [
                  Text("ArtNext",
                      style: TextStyle(
                          fontSize: 70.0,
                          color: Colors.white,
                          fontFamily: 'RichieBrusher')),
                  RichText(
                    text: TextSpan(
                        text:
                            'Made with love by David, Micaela, Quentin, Samuel & Sylvain',
                        style: TextStyle(
                            fontSize: 10.0, fontStyle: FontStyle.italic)),
                  ),
                  SizedBox(height: 25),
                  Text("Hello " + user.firstname + " " + user.lastname)
                ],
              )),
          ListTile(
            title: const Text('My account'),
            onTap: () async {
              // Update the state of the app.
              // ...
              Navigator.pushNamed(context, UserInfo.routeName);
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              // Update the state of the app.
              // ...
              await _auth.signOut();
            },
          )
        ],
      ),
    );
  }
}
