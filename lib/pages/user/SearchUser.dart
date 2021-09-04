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

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    searchResultList();
  }

  Future<void>getUidByName(String firstname) async{
    FirebaseFirestore.instance.collection("users").where('firstname', isEqualTo: firstname).get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((value) {
        userfind = MyUser(
          firstname: value.data()["firstname"],
          lastname: value.data()["lastname"],
          isPremium: value.data()["isPremium"],
          isServiceProvider: value.data()["isServiceProvider"],
          image: value.data()["image"],
        );
        userfind.setUid(value.id);
        print("test " + userfind.firstname);
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

              //method pour get le USER dans firestore
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
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(_list),
        onTap: () => {
          Navigator.pushNamed(
              context, UserDisplay.routeName,
              arguments: userfind),
          _searchController.clear(),
        },
      ),
    );
  }
}
