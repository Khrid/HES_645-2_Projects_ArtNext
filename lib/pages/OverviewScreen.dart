import 'package:artnext/pages/Wrapper.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OverviewScreen extends StatelessWidget{

  final pageDecoration = PageDecoration(
    titleTextStyle:
    PageDecoration().titleTextStyle.copyWith(color: Colors.black),
    bodyTextStyle: PageDecoration().bodyTextStyle.copyWith(color: Colors.black),
    contentMargin: const EdgeInsets.all(10),
  );

  static String routeName = "introduction";

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset("assets/images/testonboarding.jpg"),
          title: "Image 1",
          body: "This is my body.",
          footer: Text(
            "footer",
            style: TextStyle(color: Colors.black),
          ),
          decoration: pageDecoration),
      PageViewModel(
          image: Image.asset("assets/images/testonboarding.jpg"),
          title: "Image 2",
          body: "This is my body.",
          footer: Text(
            "footer",
            style: TextStyle(color: Colors.black),
          ),
          decoration: pageDecoration),
      PageViewModel(
          image: Image.asset("assets/images/testonboarding.jpg"),
          title: "Image 3",
          body: "This is my body.",
          footer: Text(
            "footer",
            style: TextStyle(color: Colors.black),
          ),
          decoration: pageDecoration),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: getPages(),
        done: Text(
          "Done",
          style: TextStyle(color: Colors.black),
        ),
        onDone: () => Navigator.pushNamed(context, Wrapper.routeName),
        next: Text('Next'),
      ),
    );
  }
}