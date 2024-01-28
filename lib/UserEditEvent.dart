import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:suhail_project/EventPage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'Calendar.dart';
import 'Navbar.dart';
import 'suhailNotification.dart';

class UserEditEvent extends StatefulWidget {
  final Event event;
  const UserEditEvent({Key? key, required this.event}) : super(key: key);

  @override
  _UserEditEventState createState() => _UserEditEventState();
}

class _UserEditEventState extends State<UserEditEvent> {
  late DateTime _selectedDate;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  int? reminderTime;
  String eventName = '';
  String eventDescription = '';
  String? eventNameError;
  String? eventDescriptionError;
  bool? pass = false;
  bool? madeChange = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.event.date;
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
    _fetchReminderTime();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _validateForm() async {
    eventName = _titleController.text;
    eventDescription = _descController.text;

    if (eventName.isEmpty || eventName.length > 20) {
      setState(() {
        eventNameError = 'الرجاء إدخال اسم الحدث وأن لا يزيد عن 20 حرفًا';
        pass = false;
      });
    } else {
      eventNameError = null;
    }

    if (eventDescription.length > 30) {
      setState(() {
        eventDescriptionError = 'الرجاء إدخال وصف للحدث لا يزيد عن 30 حرفًا';
        pass = false;
      });
    } else {
      eventDescriptionError = null;
    }
  }

  Future<void> _fetchReminderTime() async {
    String eventId = widget.event.id;
    reminderTime = await _getReminderChoice(eventId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'تحديث معلومات الحدث',
          style: TextStyle(color: Colors.white, fontFamily: 'Almarai'),
        ),
        centerTitle: true,
        leading: TextButton(
          onPressed: () async {
            _validateForm();
            if (eventNameError == null && eventDescriptionError == null) {
              // Update the event details

              // Get the document ID associated with the event
              String eventId = widget.event.id;

//initialize notification object
              SuhailNotification addNotification = SuhailNotification();
              addNotification.initializeNotifications();

// calculate notificationTime
              DateTime eventDate = _selectedDate;
              DateTime notificationTime =
                  getNotificationTime(eventDate, reminderTime);

              //Update the notification:
              // 1. getting the notificationId
              int notificationId = await _getNotificationId(eventId);
              // 2. cancel the previous notification
              await flutterLocalNotificationsPlugin.cancel(notificationId);
              //3. schedule a new notification
              addNotification.scheduleNotification(notificationTime, eventName,
                  eventDescription, reminderTime, notificationId);

              // Update the event in Firestore
              FirebaseFirestore.instance
                  .collection('events')
                  .doc(eventId)
                  .update({
                'title': eventName,
                'description': eventDescription,
                'reminder': reminderTime,
              });
              pass = true;
              // Close the page
              // }

              if (mounted) {
                Navigator.pop<bool>(context, true);
              }
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                      'تم تحديث الحدث بنجاح',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Almarai'),
                    ),
                  );
                },
              );
            }
          },
          child: const Text(
            "حفظ",
          ),
          style: TextButton.styleFrom(
            textStyle: TextStyle(fontFamily: 'Almarai'),
            primary: Color(0xFF6288FF), // text color
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // اذا ضغظ الغاء
              // are you sure?
              if (madeChange == true) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'تأكيد الإلغاء',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Almarai',

                          //fontSize: 30,
                        ),
                      ),
                      content: const Text(
                        'هل أنت متأكد من رغبتك في إلغاء التغييرات؟',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Almarai',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            if (mounted) {
                              Navigator.pop<bool>(
                                  context, true); // back to edit
                              Navigator.pop<bool>(
                                  context, true); // back to calendar
                            } // Close the confirmation dialog
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red, // Background color
                          ),
                          child: const Text(
                            "إلغاء",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the confirmation dialog
                          },
                          child: const Text(
                            'تراجع',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                if (mounted) {
                  Navigator.pop<bool>(context, true);
                }
              }
            },
            child: const Text('إلغاء'),
            style: TextButton.styleFrom(
              textStyle: TextStyle(fontFamily: 'Almarai'),
              primary: Colors.white, // text color
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'عنوان الحدث',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Almarai',
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              TextFormField(
                textAlign: TextAlign.right,
                onChanged: (value) {
                  // so if user pressed 'cancel' after editing the fieldm we confirm the cancel
                  madeChange = true;
                },
                controller: _titleController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white,

                  enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white)),
                  //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Almarai',
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(top: 6.0),
                child: Text(
                  eventNameError ?? '',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Almarai',
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'وصف الحدث',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Almarai',
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              TextFormField(
                textAlign: TextAlign.right,
                onChanged: (value) {
                  // so if user pressed 'cancel' after editing the field, we confirm the cancel
                  madeChange = true;
                },
                controller: _descController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white)),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Almarai',
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(top: 6.0),
                child: Text(
                  eventDescriptionError ?? '',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Almarai',
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}

Future<int?> _getReminderChoice(String eventId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await firestore.collection('events').doc(eventId).get();

  if (documentSnapshot.exists) {
    final data = documentSnapshot.data();

    if (data != null) {
      int? reminderChoice = data['reminder'] as int?;

      if (reminderChoice != null) {
        return reminderChoice;
      }
    }
  }

  return 0;
}

Future<int> _getNotificationId(String eventId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await firestore.collection('events').doc(eventId).get();

  if (documentSnapshot.exists) {
    final data = documentSnapshot.data();

    if (data != null) {
      int notificationId = data['notificationID'] as int;
      return notificationId;
    }
    return -3; // error in getting notificationId
  }
  return -3; // error in getting notificationId
}



/* too much parameters, let's try to do it in the same widget
Future<void> _updatingNotification(
    int notificationId, int? newReminderTime, SuhailNotification addNotification) async {
// cancel the previous notification
  await flutterLocalNotificationsPlugin.cancel(notificationId);
// schedule a new notification

  addNotification.scheduleNotification(
      notificationTime, title, description, reminderTime, notificationId);
}
*/
