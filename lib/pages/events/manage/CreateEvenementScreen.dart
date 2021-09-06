import 'dart:developer' as dev;

import 'package:artnext/enums/EventTypeEnum.dart';
import 'package:artnext/models/event.dart';
import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:artnext/pages/events/ListEventsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

export 'CreateEvenementScreen.dart';

class CreateEvenementScreen extends StatefulWidget {
  static const routeName = '/events/event/create';

  const CreateEvenementScreen({Key? key}) : super(key: key);

  CreateEvenementScreenState createState() {
    return CreateEvenementScreenState();
  }
}

class CreateEvenementScreenState extends State<CreateEvenementScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController eventTitleController = new TextEditingController();
  TextEditingController eventCityController = new TextEditingController();
  TextEditingController eventAddressController = new TextEditingController();
  TextEditingController eventDetailsController = new TextEditingController();
  TextEditingController eventStartDateController = new TextEditingController();
  TextEditingController eventStartTimeController = new TextEditingController();
  TextEditingController eventEndDateController = new TextEditingController();
  TextEditingController eventEndTimeController = new TextEditingController();
  TextEditingController eventimageController = new TextEditingController();

  DateTime startDateTimeEvent = DateTime.now();
  DateTime endDateTimeEvent = DateTime.now();
  var eventTypeSelectedValue = getEventTypeText(EventTypeEnum.UNDEFINED);
  late GoogleMapController mapController;
  List<Marker> _markers = <Marker>[];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {

    MyUser? user = Provider.of<MyUser?>(context);
    CollectionReference events =
        FirebaseFirestore.instance.collection("events");

    initializeDateFormatting("fr", null).then((_) {
      var formatter = DateFormat.yMMMd("fr_CH");
      eventStartDateController.text =
          formatter.format(DateTime.now()).toString();
      eventStartTimeController.text =
          TimeOfDay.now().hour.toString().padLeft(2, '0') +
              ":" +
              TimeOfDay.now().minute.toString().padLeft(2, '0');


      eventEndDateController.text =
          formatter.format(DateTime.now()).toString();
      eventEndTimeController.text =
          TimeOfDay.now().hour.toString().padLeft(2, '0') +
              ":" +
              TimeOfDay.now().minute.toString().padLeft(2, '0');
    });

    _markers.add(Marker(
        markerId: MarkerId("testId"),
        position: LatLng(46.09473118297104, 7.070971809710631),
        infoWindow: InfoWindow(title: "Test"),
        draggable: true,
        onDragEnd: ((newPos) async {})));

    Future<void> addEvent(Event e) async {
      Event tmp = e;
      events.add(e.toJson()).then((value) => dev.log(value.id.toString()));
      //return tmp;
    }

    // TODO: implement build
    return Scaffold(

        appBar: MyAppBar("Create event", false),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          /// Title
                          TextFormField(
                              controller: eventTitleController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Title'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the title';
                                }
                                return null;
                              }),

                          /// Address
                          SizedBox(height: 10),
                          TextFormField(
                              controller: eventAddressController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Address'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the address';
                                }
                                return null;
                              }),

                          /// City
                          SizedBox(height: 10),
                          TextFormField(
                              controller: eventCityController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'City'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the city';
                                }
                                return null;
                              }),

                          /// Map
                          /*SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // or use fixed size like 200
                              height: 200,
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                markers: Set<Marker>.of(_markers),
                                initialCameraPosition: CameraPosition(
                                    target: new LatLng(
                                        46.09473118297104, 7.070971809710631),
                                    zoom: 11),
                              )),*/

                          /// Details
                          SizedBox(height: 10),
                          TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: 5,
                              //Normal textInputField will be displayed
                              maxLines: 5,
                              // when user presses enter it will adapt to it
                              controller: eventDetailsController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Details'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the details';
                                }
                                return null;
                              }),

                          /// Type
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Type'),
                            isExpanded: true,
                            value: eventTypeSelectedValue,
                            items:
                                EventTypeEnum.values.map((EventTypeEnum value) {
                              return DropdownMenuItem<String>(
                                value: getEventTypeText(value),
                                child: new Text(getEventTypeText(value)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                eventTypeSelectedValue = value!;
                              });
                            },
                          ),
                          /// image
                          SizedBox(height: 10),
                          TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              //Normal textInputField will be displayed
                              maxLines: 5,
                              // when user presses enter it will adapt to it
                              controller: eventimageController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Image'),
                              validator: (value) {
                                if (value == null || value.isEmpty || value.substring(0,4) != 'http') {
                                  return 'Please enter the image url';
                                }
                                return null;
                              }),
                          /// Start date
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 7,
                                  child: TextFormField(
                                    controller: eventStartDateController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Start date'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the start date';
                                      } else if(endDateTimeEvent.compareTo(startDateTimeEvent) < 1) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    onTap: () async {
                                      DateTime? datePicked =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: new DateTime.now(),
                                          firstDate: new DateTime(2021),
                                          lastDate: new DateTime(2022));
                                      if (datePicked != null) {
                                        initializeDateFormatting("fr", null)
                                            .then((_) {
                                          var formatter =
                                          DateFormat.yMMMd("fr_CH");
                                          eventStartDateController.text =
                                              formatter
                                                  .format(datePicked)
                                                  .toString();
                                          startDateTimeEvent = new DateTime(
                                            datePicked.year,
                                            datePicked.month,
                                            datePicked.day,
                                            startDateTimeEvent.hour,
                                            startDateTimeEvent.minute
                                          );
                                        });
                                      }
                                    },
                                  )),
                              Spacer(),
                              Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: eventStartTimeController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Start time'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the start time';
                                      } else if(endDateTimeEvent.compareTo(startDateTimeEvent) < 1) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    onTap: () async {
                                      TimeOfDay? timePicked =
                                      await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                    alwaysUse24HourFormat:
                                                    true),
                                                child: child!);
                                          });
                                      if (timePicked != null) {
                                        eventStartTimeController.text =
                                            timePicked.hour
                                                .toString()
                                                .padLeft(2, '0') +
                                                ":" +
                                                timePicked.minute
                                                    .toString()
                                                    .padLeft(2, '0');

                                        startDateTimeEvent = new DateTime(
                                          startDateTimeEvent.year,
                                          startDateTimeEvent.month,
                                          startDateTimeEvent.day,
                                          timePicked.hour,
                                          timePicked.minute
                                        );
                                      }
                                    },
                                  ))
                            ],
                          ),


                          /// End date
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 7,
                                  child: TextFormField(
                                    controller: eventEndDateController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'End date'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the end date';
                                      } else if(endDateTimeEvent.compareTo(startDateTimeEvent) < 1) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    onTap: () async {
                                      DateTime? datePicked =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: new DateTime.now(),
                                          firstDate: new DateTime(2021),
                                          lastDate: new DateTime(2022));
                                      if (datePicked != null) {
                                        initializeDateFormatting("fr", null)
                                            .then((_) {
                                          var formatter =
                                          DateFormat.yMMMd("fr_CH");
                                          eventEndDateController.text =
                                              formatter
                                                  .format(datePicked)
                                                  .toString();
                                          endDateTimeEvent = new DateTime(
                                              datePicked.year,
                                              datePicked.month,
                                              datePicked.day,
                                              endDateTimeEvent.hour,
                                              endDateTimeEvent.minute
                                          );
                                        });
                                      }
                                    },
                                  )),
                              Spacer(),
                              Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: eventEndTimeController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'End time'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the end time';
                                      } else if(endDateTimeEvent.compareTo(startDateTimeEvent) < 1) {
                                        return '';
                                      }

                                      return null;
                                    },
                                    onTap: () async {
                                      TimeOfDay? timePicked =
                                      await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                    alwaysUse24HourFormat:
                                                    true),
                                                child: child!);
                                          });
                                      if (timePicked != null) {
                                        eventEndTimeController.text =
                                            timePicked.hour
                                                .toString()
                                                .padLeft(2, '0') +
                                                ":" +
                                                timePicked.minute
                                                    .toString()
                                                    .padLeft(2, '0');
                                        endDateTimeEvent = new DateTime(
                                            endDateTimeEvent.year,
                                            endDateTimeEvent.month,
                                            endDateTimeEvent.day,
                                            timePicked.hour,
                                            timePicked.minute);
                                      }
                                    },
                                  ))
                            ],
                          ),

                          /// Create button
                          SizedBox(height: 50),
                          ElevatedButton(
                              // Within the `FirstScreen` widget
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Timestamp startDate = Timestamp.fromDate(startDateTimeEvent);
                                  Timestamp endDate = Timestamp.fromDate(endDateTimeEvent);
                                  List<String> listAttendees = [];
                                  Event e = new Event(
                                      title: eventTitleController.text,
                                      city: eventCityController.text,
                                      image: eventimageController.text,
                                      type: getEventTypeEnum(
                                          eventTypeSelectedValue),
                                      startDate: startDate,
                                      // https://pub.dev/packages/datetime_picker_formfield
                                      endDate: endDate,
                                      details: eventDetailsController.text,
                                      organizer: user!.uid,
                                      address: eventAddressController.text,
                                      geopoint: new GeoPoint(0, 0),
                                      listAttendees: listAttendees);

                                  addEvent(e);

                                  // Navigate to the second screen using a named route.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: const Text('Event created'),
                                          duration: Duration(seconds: 2)));
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      ListEventsScreen.routeName,
                                      (route) => false);
                                }
                              },
                              child: Text('Create event'))
                        ],
                      )))),
        ));
  }
}
