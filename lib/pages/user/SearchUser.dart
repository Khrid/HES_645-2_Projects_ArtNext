import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:artnext/pages/user/UserInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'UserDisplay.dart';

class SearchUser extends StatefulWidget {
  static const routeName = '/user/search';

  _SearchUser createState() => _SearchUser();
}

class _SearchUser extends State<SearchUser> {
  List _resultsList = [];
  var showResults = [];
  var ListResults = [];
  late MyUser user;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    searchResultList();
  }

  // CollectionReference _collectionRef =
  // FirebaseFirestore.instance.collection('users');

  getUidByName(String firstname) {
    return FirebaseFirestore.instance.collection('users').where('firstname', isEqualTo: 'David')
        .snapshots();
  }


  searchResultList() {
    // TODO A implémenter, tests Sylvain
    if (_searchController.text != ""){
      FirebaseFirestore.instance.collection('users').get()
          .then((querySnapshot){
        querySnapshot.docs.forEach((result){

          if(result.data()["firstname"]== _searchController.text){
            if(!ListResults.contains(_searchController.text)){
              //print("TEST" + result.data()["firstname"]);

              //TODO Faire en sorte de récupérer le user ou le uuid en fonction du firstname
              // user=getUidByName(result.data()["firstname"]) as MyUser;
              // print("Mon USER " + user.uid);

              showResults.add(result.data()["firstname"] + " " + result.data()["lastname"]);
              ListResults.add(_searchController.text);


            }
          }

        });
      });
    }else{
      print("Il n'y a pas de paramètre");
      ListResults.clear();
      showResults.clear();
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar("Search a user", false),
        body: Container(
          child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: _resultsList.length,
                        itemBuilder: (context, index) {
                          return _listItem(context, _resultsList[index]);
                        }
                    )
                )
              ]
          ),
        ));
  }

  _listItem(context, _list){
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.brown[400],
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children: <Widget>[
              Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        print("J'ai bien cliqué ");
                        Navigator.pushNamed(
                            context, UserInfo.routeName,
                            arguments:  _list);
                      },
                      child: Text(_list),
                    )
                    // Expanded(
                    //   flex: 3,
                    //   child: Text(_list),
                    // )
                  ]
              )
            ]
        )
    );
  }





}
