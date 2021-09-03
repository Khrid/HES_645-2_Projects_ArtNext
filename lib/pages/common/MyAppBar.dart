import 'package:artnext/common/Constants.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/AuthenticationService.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool filterActionsAvailable;
  final AuthenticationService _auth = AuthenticationService();

  MyAppBar(this.title, this.filterActionsAvailable);



  @override
  MyAppBarState createState() {
    return MyAppBarState();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class MyAppBarState extends State<MyAppBar> {

  @override
// TODO: implement preferredSize

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    //await user.populateUserInfoFromFirebase();
    // print("MyAppBar - user = " + user.toString());

    List<Widget> actions = <Widget>[];

    if (widget.filterActionsAvailable) {
      actions.add(PopupMenuButton<String>(
        onSelected: (value) => _showAlertDialog(context, value),
        itemBuilder: (BuildContext context) {
          return Constants.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ));
    }

    // TODO: implement build
    return AppBar(
      title: Text(widget.title),
      backgroundColor: Colors.brown[400],
      actions: actions,
      //backgroundColor: (user!.isServiceProvider ? Colors.orange[400] : Colors.brown[400]),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Filterby) {
      print('Filter bar');
    }
    if (choice == Constants.Sortedby) {
      print('Sorted bar');
    }
  }

  void _showAlertDialog(BuildContext context, String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: Text("content"),
          actions: <Widget>[
            FlatButton(
              child: Text(value),
              onPressed: () {
                ///Insert here an action, in your case should be:
                  Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
