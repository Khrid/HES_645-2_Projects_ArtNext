import 'package:artnext/models/myuser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  static const routeName = '/user/info';

  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('User info'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Align(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
                padding: EdgeInsets.only(left: 60, right: 60),
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Column(
                  children: [
                    Text("uid : " + user!.uid),
                    Text("lastname : " + user.lastname),
                    Text("firstname : " + user.firstname),
                    Text("isPremium : " + user.isPremium.toString()),
                    Text("isServiceProvider : " + user.isServiceProvider.toString()),
                    Text("image : " + user.image),
                  ],
                ));
          },
        ),
      ),
    );
  }
}
