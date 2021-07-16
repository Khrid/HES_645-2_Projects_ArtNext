// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home:
      FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot){
          if(snapshot.hasError){
    print('You have an error ${snapshot.error.toString()}');
    return Text('Something went wrong!');
    }else if(snapshot.hasData){
    return RandomWords();
    }else{
            return Center(
            child: CircularProgressIndicator(),
            );
    }
    },
    )


    );
  }
}

//Raccourci stful
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  //default name of State prefixed by _
  final _suggestions = <WordPair>[]; //for saving suggested word
  final _saved = <WordPair>{};
  final _biggerFont =
      const TextStyle(fontSize: 18.0); //making the font size larger.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //implements the basic Material Design visual layout.
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [ //acceptent un tableau de widgets
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved,)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/ // divides i by 2
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair); //pour valider qu'une paire de mots n'a pas déjà été ajoutée aux favoris.
    //This function displays each new pair in a ListTile
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color : alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        DatabaseReference _testRef = FirebaseDatabase.instance.reference().child("test");
        _testRef.set("Hello world ${pair.toString()}"); // ENVOIE SUR FIREBASE
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          } else{
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles( //divideTiles ajoute un espacement horizontal entre chaque ListTile
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided), //divided contient les dernières lignes converties en liste par la fonction de commodité tolist
          );
        }, // ...to here.
      ),
    );
  }


}
