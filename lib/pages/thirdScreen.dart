
import 'package:flutter/material.dart';
export 'thirdScreen.dart';

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          // Within the `FirstScreen` widget
          onPressed: () {
            Navigator.of(context).pop(); // revenir au précédent
          },
          child: Text('Go back to second screen'),
        ),
      ),
    );
  }
}