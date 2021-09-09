import 'package:cloud_firestore/cloud_firestore.dart';

/// Manage the research
class SearchService {
  /// Search a user with given username
  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('firstname', isEqualTo: searchField)
        .get();
  }
}
