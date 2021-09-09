import 'package:artnext/pages/OverviewScreen.dart';
import 'package:artnext/pages/events/ListEventsScreen.dart';
import 'package:artnext/pages/login/Authenticate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/myuser.dart';

/// Manage everything :) high level Widget that manage what to display
class Wrapper extends StatelessWidget {
  static const routeName = '';
  late SharedPreferences sharedPrefs;

  /// Get the info from local storage if this is the first time that we launch
  /// the application
  _isFirstLaunch() async {
    try {
      sharedPrefs = await SharedPreferences.getInstance();
      // décommenter pour tester le first launch
      //sharedPrefs.clear();
      if (sharedPrefs.getBool("firstLaunch") == null ||
          sharedPrefs.getBool("firstLaunch") == true) {
        print("Wrapper - _isFirstLaunch - " +
            sharedPrefs.getBool("firstLaunch").toString());
        sharedPrefs.setBool("firstLaunch", false);
        return true;
      } else {
        print("Wrapper - _isFirstLaunch - " +
            sharedPrefs.getBool("firstLaunch").toString());
        return false;
      }
    } catch (error) {
      print("Error while getting SharedPreferences");
      return false;
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isFirstLaunch(),
        builder: (context, snapshot) {
          // if this is the first time that we launch the app
          if (snapshot.data == true) {
            // display the app overview
            return OverviewScreen();
          } else {
            // Are we authenticated ?
            final user = Provider.of<MyUser?>(context);
            print("Wrapper - user = " + user.toString());
            if (user == null) {
              // no, display login form
              return Authenticate();
            }
            // otherwise, display the events list
            return ListEventsScreen();
          }
        });
  }
}
