import 'dart:developer';

import 'package:artnext/models/myuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/widgets/framework.dart';

class ParticipateWidget extends StatefulWidget{
  final String eventId;

  ParticipateWidget({  Key? key,  required this.eventId }): super(key: key);

  _ParticipateWidgetState createState() => _ParticipateWidgetState();
}

class _ParticipateWidgetState extends State<ParticipateWidget>{
  late bool _isFavorited = true;
  late final String _favoriteCheck = ' TOTO';
  late final DocumentSnapshot _eventData;
  late final DocumentReference _docRef;

  List<DocumentSnapshot> listSnap = [];

  @override
  void initState() {
    super.initState();



    // if(listSnap.contains(userInfo)){
    //   _isFavorited = true;
    //   // _favoriteCheck= "Participe ?";
    //   log("Contains :" + user.toString());
    // }else{
    //   _isFavorited = false;
    //   // _favoriteCheck= "Participe!";
    //   log("Not contains :" + user.toString());
    // }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }


  Future<void> _fetchEventsData() async {
    try{
      _docRef = FirebaseFirestore.instance.collection('events').doc(widget.eventId);
      _eventData = await _docRef.get();
      // listSnap.add(_eventData);
    } catch (e) {
      print("something went wrong");
    }
  }


  Future<void> _toggleFavorite(String user) async {
    setState(() {
      if(_isFavorited){
        _isFavorited = false;
        // _favoriteCheck ="Participate?";
        _docRef.update({"listAttendees": FieldValue.arrayRemove([user])});
      }else{
        _isFavorited = true;
        // _favoriteCheck ="I participate !" ;
        _docRef.update({"listAttendees": FieldValue.arrayUnion([user])});
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    _fetchEventsData();
    var user = Provider.of<MyUser?>(context);
    String userInfo = user!.uid.toString();
    return Container(
        child:Column(
          children: [
            IconButton(
              icon : _isFavorited ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                // TODO Re activer quand il n'y a plus d'erreurs d'initialisation
                _toggleFavorite(userInfo);
              },
            ),
            Text('$_favoriteCheck',style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            )
            ),
          ],
        )
    );
  }
}




// bool contains(List<DocumentSnapshot> list, DocumentSnapshot item) {
//   for (DocumentSnapshot i in list) {
//     if (i.documentID == item.documentID) return true;
//   }
//   return false;
// }




// Widget _button(event)=>ElevatedButton(
//     child: Text('$_favoriteCheck'),
//     onPressed: () async{
//       DocumentReference docRef = FirebaseFirestore.instance.collection('events').doc(widget.eventId);
//       DocumentSnapshot doc = await docRef.get();
//       docRef.update({"listAttendees": FieldValue.arrayUnion([event])});
//     }
// );