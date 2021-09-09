import 'dart:developer' as dev;

import 'package:artnext/enums/EventTypeEnum.dart';
import 'package:artnext/models/event.dart';
import 'package:artnext/pages/common/MyAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../ListEventsScreen.dart';

export 'CreateEvenementScreen.dart';

/// Screen for existing event edition
class UpdateEvenementScreen extends StatefulWidget {
  static const routeName = '/events/event/update';

  const UpdateEvenementScreen({Key? key}) : super(key: key);

  UpdateEvenementScreenState createState() {
    return UpdateEvenementScreenState();
  }
}

class UpdateEvenementScreenState extends State<UpdateEvenementScreen> {
  final _formKey = GlobalKey<FormState>();
  Event? _event;
  late CollectionReference _events;
  TextEditingController eventTitleController = new TextEditingController();
  TextEditingController eventCityController = new TextEditingController();
  TextEditingController eventAddressController = new TextEditingController();
  TextEditingController eventDetailsController = new TextEditingController();
  TextEditingController eventStartDateController = new TextEditingController();
  TextEditingController eventStartTimeController = new TextEditingController();
  TextEditingController eventEndDateController = new TextEditingController();
  TextEditingController eventEndTimeController = new TextEditingController();
  TextEditingController eventimageController = new TextEditingController();
  var eventTypeSelectedValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Event? event = args.event;
    _event = ModalRoute.of(context)!.settings.arguments as Event;
    dev.log("UpdateEvenementScreen - event from args = " + _event!.id);
    if (eventTypeSelectedValue != null) {
      dev.log("UpdateEvenementScreen - eventTypeSelectedValue = " +
          eventTypeSelectedValue);
    } else {
      eventTypeSelectedValue = getEventTypeText(_event!.type);
    }

    DateTime startDateTimeEvent =
        DateTime.parse(_event!.startDate.toDate().toString());
    DateTime endDateTimeEvent =
        DateTime.parse(_event!.endDate.toDate().toString());

    eventTitleController.text = _event!.title;
    eventCityController.text = _event!.city;
    eventAddressController.text = _event!.address;
    eventDetailsController.text = _event!.details;
    eventimageController.text = _event!.image;

    // Dates
    initializeDateFormatting("fr", null).then((_) {
      var formatter = DateFormat.yMMMd("fr_CH");
      eventStartDateController.text =
          formatter.format(startDateTimeEvent).toString();
      eventEndDateController.text =
          formatter.format(endDateTimeEvent).toString();
    });

    // Heures
    eventStartTimeController.text =
        startDateTimeEvent.hour.toString().padLeft(2, '0') +
            ":" +
            startDateTimeEvent.minute.toString().padLeft(2, '0');

    eventEndTimeController.text =
        endDateTimeEvent.hour.toString().padLeft(2, '0') +
            ":" +
            endDateTimeEvent.minute.toString().padLeft(2, '0');

    //eventTypeSelectedValue = getEventTypeText(_event!.type);
    dev.log("UpdateEvenementScreen - eventTypeSelectedValue = " +
        eventTypeSelectedValue);

    _events = FirebaseFirestore.instance.collection("events");

    Future<void> updateEvent(Event e) async {
      _events.doc(e.id).update(e.toJson());
    }

    return Scaffold(
        appBar: MyAppBar("Edit event", false),
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
                                dev.log(value.toString());
                                eventTypeSelectedValue = value!;
                                dev.log(eventTypeSelectedValue);
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
                                  labelText: 'Image - http://...'),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.substring(0, 4) != 'http') {
                                  return 'Please enter the image url of a png';
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
                                      } else if (endDateTimeEvent
                                              .compareTo(startDateTimeEvent) <
                                          1) {
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
                                              startDateTimeEvent.minute);
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
                                      } else if (endDateTimeEvent
                                              .compareTo(startDateTimeEvent) <
                                          1) {
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
                                            timePicked.minute);
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
                                      } else if (endDateTimeEvent
                                              .compareTo(startDateTimeEvent) <
                                          1) {
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
                                              endDateTimeEvent.minute);
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
                                      } else if (endDateTimeEvent
                                              .compareTo(startDateTimeEvent) <
                                          1) {
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
                                        eventEndTimeController.text = timePicked
                                                .hour
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
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  // Within the `FirstScreen` widget
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      Timestamp startDate = Timestamp.fromDate(
                                          startDateTimeEvent);
                                      Timestamp endDate =
                                          Timestamp.fromDate(endDateTimeEvent);
                                      List listAttendees =
                                          _event!.listAttendees;
                                      Event e = new Event(
                                          id: _event!.id,
                                          title: eventTitleController.text,
                                          city: eventCityController.text,
                                          type: getEventTypeEnum(
                                              eventTypeSelectedValue),
                                          startDate: startDate,
                                          image: eventimageController.text,
                                          details: eventDetailsController.text,
                                          geopoint: _event!.geopoint,
                                          endDate: endDate,
                                          address: eventAddressController.text,
                                          organizer: _event!.organizer,
                                          listAttendees: listAttendees);

                                      _event = e;

                                      updateEvent(e);
                                      // Navigate to the second screen using a named route.
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  const Text('Event updated'),
                                              duration: Duration(seconds: 2)));
                                      //Navigator.pushNamedAndRemoveUntil(context,
                                      //    ListEventsScreen.routeName, (route) => false);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text('Update event')),
                              Container(width: 20, height: 20),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red, // background
                                    onPrimary: Colors.white, // foreground
                                  ),
                                  // Within the `FirstScreen` widget
                                  onPressed: () {
                                    showAlertDialog(context);
                                  },
                                  child: Text('Delete event'))
                            ],
                          ),
                        ],
                      ))),
            )));
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        _events.doc(_event!.id).delete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Event deleted'),
            duration: Duration(seconds: 2)));
        Navigator.pushNamedAndRemoveUntil(
            context, ListEventsScreen.routeName, (route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Event deletion"),
      content: Text("Do you really want to delete this event?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
