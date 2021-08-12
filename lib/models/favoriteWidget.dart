import 'package:flutter/material.dart';

class FavoriteWidget extends StatefulWidget{
  _FavoriteWidgetState createState() => _FavoriteWidgetState();

}

class _FavoriteWidgetState extends State<FavoriteWidget>{
  bool _isFavorited = false;
  String _favoriteCheck = "Participate ?";

  void _toggleFavorite(){
    setState(() {
      if(_isFavorited){
        _isFavorited = false;
        _favoriteCheck ="Participate ?";
      }else{
        _isFavorited = true;
        _favoriteCheck ="Participe";
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
            color: Colors.black,
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