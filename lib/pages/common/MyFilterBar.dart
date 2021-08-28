import 'package:artnext/common/Constants.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/AuthenticationService.dart';

class MyFilterBar extends StatelessWidget implements PreferredSizeWidget {
  MyFilterBar(this.title);

  final String title;
  final AuthenticationService _auth = AuthenticationService();

  @override
// TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    // TODO: implement build
    return AppBar(
      title: Text(this.title),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: choiceAction,
          itemBuilder: (BuildContext context){
            return Constants.choices.map((String choice){
              return PopupMenuItem<String>(
                value: choice,
                child:Text(choice),
              );
            }).toList();
          },
        )
        // Padding(
        //     padding: EdgeInsets.only(right: 20.0),
        //     child: GestureDetector(
        //       onTap: () {},
        //       child: Icon(
        //           Icons.more_vert
        //       ),
        //     )
        // ),
      ],

      backgroundColor: Colors.brown[400],
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
