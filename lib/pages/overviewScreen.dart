import 'package:artnext/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class overviewScreen extends StatelessWidget{

  final pageDecoration = PageDecoration(
    titleTextStyle:
    PageDecoration().titleTextStyle.copyWith(color: Colors.black),
    bodyTextStyle: PageDecoration().bodyTextStyle.copyWith(color: Colors.black),
    contentMargin: const EdgeInsets.all(10),
    imagePadding: const EdgeInsets.only(top: 50),
    // footerPadding: const EdgeInsets.only(top: 8, left: 50, right: 50),

  );

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset("assets/images/searchevent.png"),
          title: "Participate",
          body: "Spot future events and check-in to participate.",
          footer: Text(
            "You can look into a list of incoming events, get every detail about it and decide to participate and add yourself to the attendees list ! Or not.. it's your call ! Or not.. it's your call !",
            style: TextStyle(color: Colors.black),
          ),
          decoration: pageDecoration),
      PageViewModel(
          image: Image.asset("assets/images/listevent.png"),
          title: "Follow your favorite artists !",
          body: "You can access the attendance list of your favorite artist, or see the attendance list of a specific event.",
          footer: Text(
              "You may meet your favorite artist in person if you attend the event too.",
              style: TextStyle(color: Colors.black),
            ),
          decoration: pageDecoration),
      PageViewModel(
          image: Image.asset("assets/images/schedule.png"),
          title: "Create or host your event !",
          body: "As an event creator and organizer, you can create all the information page about your event and publish it to the ArtNext Calendar.",
          footer: Text(
            "You can always edit the event if you indicated by mistake your cat's babyshower..",
            style: TextStyle(color: Colors.black),
          ),
          decoration: pageDecoration),
      PageViewModel(
          image: Image.asset("assets/images/listattendees.png"),
          title: "Handle your attendees",
          body: "As an event creator and organizer, you can access the attendance list of your event and be conscious of the success.",
          footer: Text(
            "Who knows, maybe your event might gather some great artists too..",
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