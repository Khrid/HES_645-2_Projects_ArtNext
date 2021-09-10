import 'package:artnext/common/Constants.dart';
import 'package:artnext/enums/EventTypeEnum.dart';
import 'package:artnext/models/ScreenArguments.dart';
import 'package:artnext/models/event.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyDrawer.dart';
import 'package:artnext/pages/events/DisplayEvenementScreen.dart';
import 'package:artnext/widget/readTimeStamp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ListEventsFilteredScreen.dart';
import 'manage/CreateEvenementScreen.dart';

export 'ListEventsScreen.dart';

/// Screen for displaying the events list
class ListEventsScreen extends StatefulWidget {
  static const routeName = '/events';
  var selectedOrderBy = "Start date";
  var orderByFirebase = "startDate";
  List<String> myList = [];

  ListEventsScreenState createState() {
    return ListEventsScreenState();
  }
}

class ListEventsScreenState extends State<ListEventsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Events"),
        backgroundColor: Theme.of(context).accentColor,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => showSortDialog(context, value),
            itemBuilder: (BuildContext context) {
              return Constants.SORT_FILTER_CHOICES.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(''
                        'events')
                    .orderBy(widget.orderByFirebase)
                    // .where('endDate', isGreaterThan: DateTime.now())
                    .snapshots(),
                builder: buildEventsList,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: user!.isServiceProvider
          ? FloatingActionButton(
              elevation: 0.0,
              onPressed: () {
                Navigator.pushNamed(context, CreateEvenementScreen.routeName);
              },
              child: const Icon(Icons.add),
            )
          : Container(),
      drawer: MyDrawer(""),
    );
  }

  Widget buildEventsList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData) {
      // List<String> myList = [];
      return Column(
        children: <Widget>[
          Text(
            readTimestampYear(Event.fromJson(snapshot.data!.docs[0])
                .startDate
                .millisecondsSinceEpoch),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot eventFromFirebase =
                      snapshot.data!.docs[index];
                  Event event = Event.fromJson(eventFromFirebase);
                  var datum = readTimestamptoDate(
                      event.startDate.millisecondsSinceEpoch);
                  var eventTypeTransform = event.type
                      .toString()
                      .toLowerCase()
                      .replaceAll('eventtypeenum.', '');

                  //Allow add only one instance of each city
                  if (!widget.myList.contains(event.city.toString())) {
                    widget.myList.add(event.city.toString());
                  }

                  return Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text((event.title.length > 100)
                          ? event.title.substring(0, 100) + ("[...]")
                          : event.title),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                            eventTypeTransform.substring(0, 1).toUpperCase() +
                                eventTypeTransform.substring(
                                  1,
                                )),
                      ),
                      leading: SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: ClipRRect(
                            // borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            child: CachedNetworkImage(
                              imageUrl: event.image,
                              placeholder: (context, url) =>
                                  Image.asset("assets/images/placeholder.jpg"),
                              errorWidget: (context, error, url) =>
                                  Image.asset("assets/images/placeholder.jpg"),
                            ),
                          )),
                      onTap: () => {
                        Navigator.pushNamed(
                            context, DisplayEvenementScreen.routeName,
                            arguments: event)
                      },
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Text(datum),
                          ),
                          Text(event.city),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                }),
          ),
        ],
      );
    } else if (snapshot.connectionState == ConnectionState.done &&
        !snapshot.hasData) {
      // Handle no data
      return Center(
        child: Text("No events found."),
      );
    } else {
      // Still loading
      return Center(child: CircularProgressIndicator());
    }
  }

  void showSortDialog(BuildContext context, String value) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (value.toString() == Constants.SORT_BY) {
            return AlertDialog(
              title: Text(value.toString()),
              content: Container(
                child: Row(
                  children: [
                    DropdownButton<String>(
                      value: widget.selectedOrderBy,
                      items: <String>['Start date', 'End date', 'Title']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          widget.selectedOrderBy = value!;
                          switch (value) {
                            case 'Start date':
                              widget.orderByFirebase = 'startDate';
                              break;
                            case 'End date':
                              widget.orderByFirebase = 'endDate';
                              break;
                            case 'Title':
                              widget.orderByFirebase = 'title';
                              break;
                          }
                        });
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            );
          } else {
            return AlertDialog(
              title: Text(value.toString()),
              content: Container(
                child: Wrap(
                  children: [
                    Row(children: [
                      Text(
                        "Type of event:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
                    //For create a list of button with all parameters for filter type
                    getFilterType(context, 'type'),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(children: [
                        Text(
                          "By city: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    DropdownButton<String>(
                      value: widget.myList[0],
                      items: widget.myList.map((String cityList) {
                        return DropdownMenuItem<String>(
                            value: cityList, child: Text(cityList));
                      }).toList(),
                      onChanged: (String? newValue) {
                        Navigator.pushNamed(
                            context, ListEventsFilteredScreen.routeName,
                            arguments: ScreenArguments('city', newValue!));
                      },
                    ),
                    SizedBox(width: 200),
                  ],
                ),
              ),
            );
          }
        });
  }
}

// For creating a list of filtering button from a list
Widget getFilterType(BuildContext context, String type) {
  return Wrap(
      children: EventTypeEnum.values
          .map(
            (item) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, ListEventsFilteredScreen.routeName,
                      arguments: ScreenArguments(type, getEventTypeText(item)));
                },
                child: Text(getEventTypeText(item)),
              ),
            ),
          )
          .toList());
}
