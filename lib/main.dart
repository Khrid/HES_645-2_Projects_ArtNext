import 'dart:async';
import 'dart:developer';

import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/OverviewScreen.dart';
import 'package:artnext/pages/Wrapper.dart';
import 'package:artnext/pages/about/AboutScreen.dart';
import 'package:artnext/pages/events/DisplayEvenementScreen.dart';
import 'package:artnext/pages/events/ListAttendeesScreen.dart';
import 'package:artnext/pages/events/ListEventsFilteredScreen.dart';
import 'package:artnext/pages/events/ListEventsScreen.dart';
import 'package:artnext/pages/events/manage/CreateEvenementScreen.dart';
import 'package:artnext/pages/events/manage/MyEvents.dart';
import 'package:artnext/pages/events/manage/UpdateEvenementScreen.dart';
import 'package:artnext/pages/help/HelpScreen.dart';
import 'package:artnext/pages/login/LoginScreen.dart';
import 'package:artnext/pages/login/RegisterScreen.dart';
import 'package:artnext/pages/user/SearchUser.dart';
import 'package:artnext/pages/user/UserInfo.dart';
import 'package:artnext/services/AuthenticationService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  bool _initialized = false;
  bool _error = false;

  Color? _primaryColor = Colors.brown[100];
  Color? _accentColor = Colors.brown[400];

  /// initialize the FlutterFire plugin
  void initializeFlutterFire() async {
    log('initializeFlutterFire - start');
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
      log('initializeFlutterFire - _initialized = true');
    } catch (e) {
      log('initializeFlutterFire - error');
      setState(() {
        _error = true;
      });
    }
    log('initializeFlutterFire - end');
  }

  @override
  void initState() {
    initializeFlutterFire();
    Intl.defaultLocale = 'fr_CH'; // locale for date and time format
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
        value: AuthenticationService().user,
        initialData: null,
        catchError: (_, __) => null,
        child: MaterialApp(
            title: 'NextArt',
            //theme: ThemeData.light(),
            theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: _primaryColor,
                accentColor: _accentColor,

                // Button
                buttonTheme: ButtonThemeData(
                    buttonColor: _accentColor,
                    textTheme: ButtonTextTheme.primary),

                // ElevatedButton
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      primary: _accentColor, onPrimary: Colors.white),
                ),

                // FloatingActionButton
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: _accentColor)),
            debugShowCheckedModeBanner: false,
            home: Wrapper(),
            routes: {
              // ""
              Wrapper.routeName: (context) => Wrapper(),
              // /overview
              OverviewScreen.routeName: (context) => OverviewScreen(),
              // /login
              LoginScreen.routeName: (context) => LoginScreen(),
              // /register
              RegisterScreen.routeName: (context) => RegisterScreen(),
              // /events
              ListEventsScreen.routeName: (context) => ListEventsScreen(),
              // /events/filtered
              ListEventsFilteredScreen.routeName: (context) =>
                  ListEventsFilteredScreen(),
              // //events/event/display
              DisplayEvenementScreen.routeName: (context) =>
                  DisplayEvenementScreen(),
              // /events/event/create
              CreateEvenementScreen.routeName: (context) =>
                  CreateEvenementScreen(),
              // /events/event/update
              UpdateEvenementScreen.routeName: (context) =>
                  UpdateEvenementScreen(),
              // /events/event/attendees
              ListAttendees.routeName: (context) => ListAttendees(),
              // /user/info
              UserInfo.routeName: (context) => UserInfo(),
              // /events/manage/
              MyEvents.routeName: (context) => MyEvents(),
              // /user/search
              SearchUser.routeName: (context) => SearchUser(),
              // /about
              AboutScreen.routeName: (context) => AboutScreen(),
              // /help
              HelpScreen.routeName: (context) => HelpScreen(),
            }));
  }
}
