import 'package:artnext/models/event.dart';
import 'package:artnext/models/myuser.dart';
import 'package:flutter/material.dart';

class ParticipateWidget extends StatefulWidget {
  ParticipateWidget(this.user, this.e);

  MyUser user;
  Event e;

  _ParticipateWidgetState createState() => _ParticipateWidgetState();
}

class _ParticipateWidgetState extends State<ParticipateWidget> {
  var text = "";

  void _toggleFavorite() {
    var participating = (widget.e.listAttendees.contains(widget.user.uid));
    setState(() {
      text = (participating) ? "I am not going" : "I am going";
      if (participating) {
        widget.e.removeAttendee(widget.user.uid);
        widget.user.removeAttendingTo(widget.e.id);
        participating = false;
      } else {
        widget.e.addAttendee(widget.user.uid);
        widget.user.addAttendingTo(widget.e.id);
        participating = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var participating = (widget.e.listAttendees.contains(widget.user.uid));
    text = (participating) ? "I am not going" : "I am going";
    return Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: participating
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          color: Colors.red,
          onPressed: _toggleFavorite,
          padding: EdgeInsets.all(8.0),
          constraints: BoxConstraints(),
        ),
        Text('$text',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ))
      ],
    ));
  }
}
