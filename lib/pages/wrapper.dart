import 'package:artnext/pages/events/ListEventsScreen.dart';
import 'package:artnext/pages/login/authenticate.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/myuser.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    print("Wrapper - user = " + user.toString());
    // return Home or Authenticate widget
    if (user == null) {
      // print("Wrapper - user is null, display Authenticate widget");
      return Authenticate();
    }

    // print("Wrapper - user is not null, display ListEventsScreen widget");
    return ListEventsScreen();
  }
}
