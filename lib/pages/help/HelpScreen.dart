import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:flutter/material.dart';

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

  String _feedbackType = 'COMMENT';

  @override
  Widget build(BuildContext context) {
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
                      SizedBox(
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
                      _buildEmail(),
                      SizedBox(
                        height: _minValue * 3,
                      ),
                      _buildDescription(),
                      SizedBox(
                        height: _minValue * 3,
                      ),
                      SizedBox(
                        height: _minValue * 4,
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
          labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
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
      keyboardType: TextInputType.text,
      maxLines: 2,
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
            value: 'COMMENT',
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
            value: 'BUG',
            groupValue: _feedbackType,
            onChanged: (String? v) {
              setState(() {
                _feedbackType = v!;
              });
            }),
        Text('Bug Reports'),
        SizedBox(
          width: _minValue,
        ),
        Radio<String>(
            value: 'QUESTION',
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
        onPressed: () => null,
        padding: EdgeInsets.symmetric(vertical: _minValue * 2),
        elevation: 0.0,
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        child: Text('SAVE'),
      ),
    );
  }
}
