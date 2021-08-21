import 'package:flutter/material.dart';

class ParticipateWidget extends StatefulWidget{



  _ParticipateWidgetState createState() => _ParticipateWidgetState();

}

class _ParticipateWidgetState extends State<ParticipateWidget>{
  bool _isFavorited = false;
  String _favoriteCheck = "Participate ?";


  void _toggleFavorite(){
    setState(() {
      if(_isFavorited){
        _isFavorited = false;
        _favoriteCheck ="Participate?";
      }else{
        _isFavorited = true;

        _favoriteCheck ="I participate !" ;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        children: [
            IconButton(
            icon : _isFavorited ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            color: Colors.red,
            onPressed: _toggleFavorite,
            ),
            Text('$_favoriteCheck',style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,

            ))
        ],
      )
    );
  }
}