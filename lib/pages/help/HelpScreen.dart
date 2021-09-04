import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  static const routeName = '/help';

  HelpScreenState createState() => HelpScreenState();
}

class HelpScreenState extends State<HelpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final double _minValue = 8.0;
  bool isLoading = false;
  bool hasError = false;
  String message = "";

  String _feedbackType = 'Comments';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    _emailController.text = user!.email!;
    _firstNameController.text = user.firstname;
    _lastNameController.text = user.lastname;
    return Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: MyAppBar("Help & feedback", false),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Container(
              padding: EdgeInsets.all(_minValue * 2),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Feedback Type"),
                      _buildFeedbackType(),
                      /*SizedBox(
                        height: _minValue * 3,
                      ),
                      _buildFirstName(),
                      SizedBox(
                        height: _minValue * 3,
                      ),
                      _buildLastName(),
                      SizedBox(
                        height: _minValue * 3,
                      ),
                      _buildEmail(),*/
                      SizedBox(
                        height: _minValue * 3,
                      ),
                      _buildDescription(),
                      SizedBox(
                        height: _minValue * 3,
                      ),
                    ],
                  )),
            ),
            _buildSubmitBtn()
          ],
        ));
  }

  Widget _buildFirstName() {
    return TextFormField(
      controller: _firstNameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: _minValue, horizontal: _minValue),
          labelText: 'First Name',
          hintText: 'First Name',
          labelStyle: TextStyle(fontSize: 16.0,)),
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      controller: _lastNameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: _minValue, horizontal: _minValue),
          hintText: 'Last Name',
          labelText: 'Last Name',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.text,
      onChanged: (String value) {},
      readOnly: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: _minValue, horizontal: _minValue),
          labelText: 'Email',
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      controller: _messageController,
      minLines: 5,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: _minValue, horizontal: _minValue),
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
    );
  }

  Widget _buildFeedbackType() {
    return Row(
      children: <Widget>[
        Radio<String>(
            value: 'Comments',
            groupValue: _feedbackType,
            onChanged: (String? v) {
              setState(() {
                _feedbackType = v!;
              });
            }),
        Text('Comments'),
        SizedBox(
          width: _minValue,
        ),
        Radio<String>(
            value: 'Bug',
            groupValue: _feedbackType,
            onChanged: (String? v) {
              setState(() {
                _feedbackType = v!;
              });
            }),
        Text('Bug'),
        SizedBox(
          width: _minValue,
        ),
        Radio<String>(
            value: 'Questions',
            groupValue: _feedbackType,
            onChanged: (String? v) {
              setState(() {
                _feedbackType = v!;
              });
            }),
        Text('Questions')
      ],
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _minValue * 3),
      child: RaisedButton(
        onPressed: () async {
          final mailtoLink = Mailto(
            to: ['6452.gr2@gmail.com'],
            subject: 'ArtNext user feedback',
            body: 'Feedback type : ' +
                _feedbackType +
                '\n\n' +
                'Description : \n' +
                _messageController.text +
                '\n\n' +
                'Contact info : \n' +
                _firstNameController.text +
                " " +
                _lastNameController.text +
                ", " +
                _emailController.text,
          );
          // Convert the Mailto instance into a string.
          // Use either Dart's string interpolation
          // or the toString() method.
          await launch('$mailtoLink');
        },
        child: Text('Send feedback'),
      ),
    );
  }
}
