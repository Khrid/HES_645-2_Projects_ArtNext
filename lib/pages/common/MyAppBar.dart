import 'package:artnext/common/Constants.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/AuthenticationService.dart';

/// Custom AppBar that is used inside the Screen
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool filterActionsAvailable;
  final AuthenticationService _auth = AuthenticationService();

  MyAppBar(this.title, this.filterActionsAvailable);

  MyAppBarState createState() {
    return MyAppBarState();
  }

  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class MyAppBarState extends State<MyAppBar> {
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    List<Widget> actions = <Widget>[];

    if (widget.filterActionsAvailable) {
      actions.add(PopupMenuButton<String>(
        onSelected: (value) => _showAlertDialog(context, value),
        itemBuilder: (BuildContext context) {
          return Constants.SORT_FILTER_CHOICES.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ));
    }

    return AppBar(
      title: Text(widget.title),
      backgroundColor: Theme.of(context).accentColor,
      actions: actions,
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.FILTER_BY) {
      print('Filter bar');
    }
    if (choice == Constants.SORT_BY) {
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
