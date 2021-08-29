import 'package:artnext/common/Constants.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/AuthenticationService.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar(this.title, this.filterActionsAvailable);

  final String title;
  final bool filterActionsAvailable;
  final AuthenticationService _auth = AuthenticationService();

  @override
// TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    //await user.populateUserInfoFromFirebase();
    print("MyAppBar - user = " + user.toString());

    List<Widget> actions = <Widget>[];

    if(filterActionsAvailable) {
      actions.add(PopupMenuButton<String>(
        onSelected: choiceAction,
        itemBuilder: (BuildContext context){
          return Constants.choices.map((String choice){
            return PopupMenuItem<String>(
              value: choice,
              child:Text(choice),
            );
          }).toList();
        },
      ));
    }

    // TODO: implement build
    return AppBar(
      title: Text(this.title),
      backgroundColor: Colors.brown[400],
      actions: actions,
      //backgroundColor: (user!.isServiceProvider ? Colors.orange[400] : Colors.brown[400]),
    );
  }



  void choiceAction(String choice){
    if(choice == Constants.Filterby){
      print('Filter bar');
    }
    if(choice == Constants.Sortedby){
      print('Sorted bar');
    }
  }
}
