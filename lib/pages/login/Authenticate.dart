import 'package:artnext/pages/login/LoginScreen.dart';
import 'package:flutter/cupertino.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return Container(
        child: LoginScreen(),
      );
  }

}