import 'package:artnext/models/myuser.dart';
import 'package:artnext/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/AuthenticationService.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar(this.title);

  final String title;
  final AuthenticationService _auth = AuthenticationService();

  @override
// TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    print("MyAppBar - user = " + user.toString());
    // TODO: implement build
    return AppBar(
      title: Text(this.title),
      backgroundColor: Colors.brown[400],
    );
  }
}
