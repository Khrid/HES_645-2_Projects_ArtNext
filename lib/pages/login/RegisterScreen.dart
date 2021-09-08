import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/events/ListEventsScreen.dart';
import 'package:artnext/services/AuthenticationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  const RegisterScreen({Key? key}) : super(key: key);

  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isServiceProvider = false;

  final _formKey = GlobalKey<FormState>();
  final AuthenticationService _auth = AuthenticationService();

  TextEditingController lastnameController =
      new TextEditingController(text: "Lastname");
  TextEditingController firstnameController =
      new TextEditingController(text: "Firstname");
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
    print("RegisterScreen - build - start");

    return Scaffold(
        backgroundColor: Colors.brown[100],
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Align(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                    padding: EdgeInsets.only(left: 60, right: 60),
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
                            controller: lastnameController,
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Lastname',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the lastname';
                              }
                              return null;
                            }),

                        SizedBox(height: 20),
                        TextFormField(
                            controller: firstnameController,
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Firstname',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the firstname';
                              }
                              return null;
                            }),

                        SizedBox(height: 20),
                        TextFormField(
                            controller: usernameController,
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an username';
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
                                return 'Please enter a password';
                              }
                              return null;
                            }),
                        SizedBox(height: 20),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Would you like to offer events?"),
                              Container(
                                child: buildAndroidSwitch(),
                              )
                            ]),
                        SizedBox(height: 20),
                        Text(
                          '$errorMessage',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                MyUser myUser = MyUser(
                                    firstname: firstnameController.text,
                                    lastname: lastnameController.text,
                                    isServiceProvider: isServiceProvider);
                                Object? result = await _auth.signUp(
                                    email: usernameController.text,
                                    password: passwordController.text,
                                    myUser: myUser);

                                // result is user => register successful
                                if (result is MyUser) {
                                  print(
                                      "RegisterScreen - Register ElevatedButton onPressed - user = " +
                                          result.toString());
                                  changeErrorMessage("");
                                  Navigator.pushNamed(
                                      context, ListEventsScreen.routeName);
                                } else {
                                  changeErrorMessage(result.toString());
                                }
                              }
                            },
                            child: Text('Register'))
                      ],
                    ));
              },
            ),
          ),
        )));
  }

  Widget buildAndroidSwitch() => Transform.scale(
        scale: 1,
        child: Switch(
          value: isServiceProvider,
          onChanged: (value) => setState(() => this.isServiceProvider = value),
        ),
      );
}
