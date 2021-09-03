import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'UserDisplay.dart';

class SearchUser extends StatefulWidget {
  static const routeName = '/user/search';
  _SearchUser createState() => _SearchUser();
}

class _SearchUser extends State<SearchUser> {
  List _resultsList = [];
  var showResults = [];
  var ListResults = [];
  late MyUser userfind;

  late Map test;

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

  Future<void>getUidByName(String firstname) async{
        FirebaseFirestore.instance.collection("users").where('firstname', isEqualTo: 'David').get()
            .then((querySnapshot) {
      querySnapshot.docs.forEach((value) {
        var temp = value.data();
        userfind = MyUser.fromJson(temp);
        print("TEST " + userfind.firstname);
        print("TEST " + userfind.firstname);

        //test=value.data(); // >>>> fonctionne mais n'est pas un objet mais une map
        // print("MON RESULTAT" + result.data().toString());
      });
    });
  }



  searchResultList() {
    if (_searchController.text != ""){
      FirebaseFirestore.instance.collection('users').get()
          .then((querySnapshot){
        querySnapshot.docs.forEach((result){

          if(result.data()["firstname"]== _searchController.text){
            if(!ListResults.contains(_searchController.text)){
              //print("TEST" + result.data()["firstname"]);
              //TODO Faire en sorte de récupérer le user ou le uuid en fonction du firstname
              getUidByName(result.data()["firstname"]);

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
                      child: Text(_list),
                      onTap: () {
                        print("J'ai bien cliqué ");
                        Navigator.pushNamed(
                            context, UserDisplay.routeName,
                            arguments: userfind);
                      },
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
