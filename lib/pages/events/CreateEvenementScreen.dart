
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'CreateEvenementScreen.dart';

class CreateEvenementScreen extends StatelessWidget {
  static const routeName = '/events/event/create';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Create event'),
      ),
      body: Center(
        child: Text(
          "Creation screen to build"
        )
      ),
    );
  }
}