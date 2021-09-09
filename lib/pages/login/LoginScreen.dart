import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/events/ListAttendeesScreen.dart';
import 'package:artnext/pages/login/RegisterScreen.dart';
import 'package:artnext/services/AuthenticationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'LoginScreen.dart';

/// Screen for displaying the login form
class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthenticationService _auth = AuthenticationService();
  TextEditingController usernameController =
      new TextEditingController(text: "user@artnext.ch");
  TextEditingController passwordController =
      new TextEditingController(text: "test123");

  var errorMessage = "";

  void changeErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("LoginScreen - build - start");

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Align(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                    padding: EdgeInsets.only(left: 60, right: 60),
                    /*decoration: BoxDecoration(
                      color: const Color(0xffa3a3a3),
                      image: DecorationImage(
                        image: AssetImage('assets/images/login.png'),
                        fit: BoxFit.fill,
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.4), BlendMode.dstATop),
                      ),
                    ),*/
                    child: Column(
                      children: [
                        SizedBox(height: 75),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "ArtNext",
                              style: TextStyle(
                                  fontSize: 70.0,
                                  color: Colors.white,
                                  fontFamily: 'RichieBrusher'),
                            ),
                          ],
                        ),
                        // SizedBox(height: 250),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 50),
                              )
                            ]),

                        TextFormField(
                            controller: usernameController,
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the username';
                              }
                              return null;
                            }),

                        SizedBox(height: 20),
                        TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the password';
                              }
                              return null;
                            }),
                        SizedBox(height: 20),
                        Text(
                          '$errorMessage',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(

                            // Within the `FirstScreen` widget
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Object? result = await _auth.signIn(
                                    email: usernameController.text,
                                    password: passwordController.text);
                                if (result is MyUser) {
                                  // result is user => login successful
                                  print(
                                      "LoginScreen - Login ElevatedButton onPressed - result.uid = " +
                                          result.uid);
                                  changeErrorMessage("");
                                } else {
                                  changeErrorMessage(result.toString());
                                }
                              }
                            },
                            child: Text('Log in')),
                        SizedBox(height: 20),
                        ElevatedButton(
                            // Within the `FirstScreen` widget
                            onPressed: () async {
                              Navigator.pushNamed(
                                  context, RegisterScreen.routeName);
                            },
                            child: Text('Register'))
                      ],
                    ));
              },
            ),
          ),
        )));
  }
}
