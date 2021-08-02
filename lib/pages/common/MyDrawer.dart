import 'package:flutter/material.dart';

import '../loginScreen.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer(this.currentPage);

  final String currentPage;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
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
                  Text("Hello Firstname lastname!")
                ],
              )),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
