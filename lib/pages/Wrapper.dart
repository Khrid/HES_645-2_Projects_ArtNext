import 'package:artnext/pages/events/ListEventsScreen.dart';
import 'package:artnext/pages/login/Authenticate.dart';
import 'package:artnext/pages/OverviewScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/myuser.dart';

class Wrapper extends StatelessWidget {
  static const routeName = '';
  late SharedPreferences sharedPrefs;

  _isFirstLaunch() async {
    try {
      sharedPrefs = await SharedPreferences.getInstance();
      // décommenter pour tester le first launch
      //sharedPrefs.clear();
      if(sharedPrefs.getBool("firstLaunch") == null ||
          sharedPrefs.getBool("firstLaunch") == true) {
        print("Wrapper - _isFirstLaunch - " + sharedPrefs.getBool("firstLaunch").toString());
        sharedPrefs.setBool("firstLaunch", false);
        return true;
      } else {
        print("Wrapper - _isFirstLaunch - " + sharedPrefs.getBool("firstLaunch").toString());
        return false;
      }
    } catch(error) {
      print("Error while getting SharedPreferences");
      return false;
    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isFirstLaunch(),
        builder: (context, snapshot) {
          //print(snapshot);
          if(snapshot.data == true) {
            return OverviewScreen();
          } else {
            final user = Provider.of<MyUser?>(context);
            print("Wrapper - user = " + user.toString());
            if (user == null) {
              return Authenticate();
            }
            return ListEventsScreen();
          }
        });
  }
}
