//
//
//
//
// import 'package:artnext/models/myuser.dart';
// import 'package:firestore_search/firestore_search.dart';
// import 'package:flutter/material.dart';
//
// class SearchFeed extends StatefulWidget {
//   static const routeName = '/user/search';
//   @override
//   _SearchFeedState createState() => _SearchFeedState();
// }
//
// class _SearchFeedState extends State<SearchFeed> {
//   @override
//   Widget build(BuildContext context) {
//     return FirestoreSearchScaffold(
//       firestoreCollectionName: 'data',
//       searchBy: 'name',
//       dataListFromSnapshot: MyUser().dataListFromSnapshot,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final List<MyUser> dataList = snapshot.data;
//
//           return ListView.builder(
//               itemCount: dataList?.length ?? 0,
//               itemBuilder: (context, index) {
//                 final MyUser data = dataList[index];
//
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('${data?.firstname ?? ''}'),
//                     Text('${data?.lastname ?? ''}')
//                   ],
//                 );
//               });
//         }
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }
// }