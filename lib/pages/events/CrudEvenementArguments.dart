import 'package:artnext/enum/CrudEnum.dart';
import 'package:artnext/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudEvenementArguments {
  final Event? event;

  CrudEvenementArguments(this.event);
}