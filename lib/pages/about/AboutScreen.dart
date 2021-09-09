import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// The "About" screen displays the information about the app, developpers and
/// github link
class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: MyAppBar("About", false),
        body: SingleChildScrollView(
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text("ArtNext",
                        style: TextStyle(
                            fontSize: 105.0,
                            color: Colors.white,
                            fontFamily: 'RichieBrusher')),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'HES 645-2 Flutter project',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'Students',
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'Micaela Da Rocha, scrum master',
                            style: TextStyle(
                              fontSize: 16.0,
                            )),
                      ),
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'Quentin Beeckmans',
                            style: TextStyle(
                              fontSize: 16.0,
                            )),
                      ),
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'David Crittin',
                            style: TextStyle(
                              fontSize: 16.0,
                            )),
                      ),
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'Sylvain Meyer',
                            style: TextStyle(
                              fontSize: 16.0,
                            )),
                      ),
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'Samuel Wenger',
                            style: TextStyle(
                              fontSize: 16.0,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'Special thanks to',
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'Gaetano Manzo 😇',
                            style: TextStyle(
                              fontSize: 16.0,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await launch(
                            "https://github.com/hes-6452-gr2/HES_645-2_Projects_ArtNext");
                      }, // handle your image tap here
                      child: Image.asset(
                        'assets/images/github.png',
                        fit: BoxFit.cover, // this is the solution for border
                      ),
                    ),
                  ],
                ))));
  }
}
