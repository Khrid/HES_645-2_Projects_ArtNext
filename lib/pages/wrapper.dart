import 'package:artnext/pages/login/authenticate.dart';
import 'package:artnext/pages/events/ListEventsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/myuser.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      final user = Provider.of<MyUser?>(context);
      print(user);
      // return Home or Authenticate widget
      if(user == null) return Authenticate();
      return ListEventsScreen();
  }
  
}