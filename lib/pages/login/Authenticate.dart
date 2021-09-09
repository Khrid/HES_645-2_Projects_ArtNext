import 'package:artnext/pages/login/LoginScreen.dart';
import 'package:flutter/cupertino.dart';

/// Manage the autentication status
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginScreen(),
    );
  }
}
