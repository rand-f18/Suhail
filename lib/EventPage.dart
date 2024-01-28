import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:suhail_project/main.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' as ui;
import 'AddEvent.dart';
import 'SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'EditEvent.dart';
import 'CP_menu.dart';

void main() async {
  initializeDateFormatting("ar");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(Events());
}

class Events extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ar');
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ar'),
        const Locale('ar'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Suhail',
      home: EventPage(),
    );
  }
}

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Map<String, dynamic>? selectedEvent;

  void _selectEvent(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.white, // تحديد لون الظل إلى الأبيض
                blurRadius: 2,
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.auto_awesome_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    event['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                event['not'],
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Almarai',
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 20),
              Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    event['starName'],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Almarai',
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EventModificationPage(event: event),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff72b2ff), // تغيير لون الزر إلى الأزرق
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ) // تحديد حجم الزر
                        ),
                    child: Text(
                       "تعديل",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();

                      // عرض الحوار لتأكيد الحذف
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'تأكيد الحذف',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Almarai'),
                            ),
                            content: Text(
                              'هل أنت متأكد من رغبتك في حذف الحدث؟',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Almarai'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(false); // الغاء الحذف
                                },
                                child: Text(
                                  'إلغاء',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Almarai',
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.red,
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  FirebaseFirestore.instance
                                      .collection('CP')
                                      .doc(event['eventId'])
                                      .delete();
                                  setState(() {});
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                          'تم حذف الحدث بنجاح',
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(fontFamily: 'Almarai'),
                                        ),
                                      );
                                    },
                                  ); // Close the bottom sheet
                                },
                                child: Text(
                                  'حذف',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Almarai',
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // تغيير لون الزر إلى الأحمر
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "حذف",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CPDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('CP').get().asStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }

          List<Map<String, dynamic>> eventList =
              snapshot.data!.docs.map((document) {
            String eventName = document['Event'];
            String eventImageUrl = document['Image'];
            DateTime eventDate =
                DateFormat("yyyy-MM-dd").parse(document['DateTime']);
            String dn = document['Date'];
            String eventnot = document['Notification'];
            String eventId = document.id;

            return {
              'eventId': eventId,
              'name': eventName,
              'imageUrl': eventImageUrl,
              'date': eventDate,
              'starName': dn,
              'not': eventnot,
            };
          }).toList();

          DateTime currentDate = DateTime.now();

          // Filter events that have the same date as the current date
          List<Map<String, dynamic>> currentEvents = eventList
              .where((eventMap) =>
                  (eventMap['name'] != "") &&
                      (eventMap['date'].day == currentDate.day) &&
                      (eventMap['date'].month == currentDate.month) &&
                      (eventMap['date'].year == currentDate.year) ||
                  (eventMap['name'] != "" &&
                      eventMap['date'].isAfter(currentDate)))
              .toList();

          // Filter events that have a future date
          ;

          // Sort the current events by date
          currentEvents.sort((a, b) => a['date'].compareTo(b['date']));

          // Sort the future events by date

          // Combine the current and future events

          List<Widget> eventWidgets = currentEvents.map((eventMap) {
            String eventName = eventMap['name'];
            String eventImageUrl = eventMap['imageUrl'];
            DateTime eventDate = eventMap['date'];
            String dn = eventMap['starName'];
            String eventnot = eventMap['not'];

            Widget eventWidget = Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () => _selectEvent(eventMap),
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 330,
                  height: 113,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(eventImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Text(
                          dn,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        right: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eventName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            return eventWidget;
          }).toList();

          return Stack(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: FractionalTranslation(
                      translation: Offset(-0.19, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'الأحداث الفلكية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Almarai',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: eventWidgets.length,
                      itemBuilder: (context, index) {
                        return eventWidgets[index];
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 50,
                right: 50,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MyForm()));
                  },
                  backgroundColor: Color(0xff72b2ff),
                  child: Icon(Icons.add),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
















/*class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('CP').get().asStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }

          List<Map<String, dynamic>> eventList =
              snapshot.data!.docs.map((document) {
            String eventName = document['Event'];
            String eventImageUrl = document['Image'];
            DateTime eventDate =
                DateFormat("yyyy-MM-dd").parse(document['DateTime']);
            String dn = document['Date'];

            return {
              'name': eventName,
              'imageUrl': eventImageUrl,
              'date': eventDate,
              'starName': dn,
            };
          }).toList();

          DateTime currentDate = DateTime.now();

          eventList.removeWhere(
              (eventMap) => eventMap['date'].isAfter(currentDate));

          eventList.sort((a, b) => b['date'].compareTo(a['date']));

          List<Widget> eventWidgets = eventList.map((eventMap) {
            String eventName = eventMap['name'];
            String eventImageUrl = eventMap['imageUrl'];
            DateTime eventDate = eventMap['date'];
            String dn = eventMap['starName'];

            Widget eventWidget = Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width: 330,
                height: 113,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(eventImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Text(
                        dn,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      right: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          /*Text(
                            DateFormat('yyyy-MM-dd').format(eventDate),
                            style: TextStyle(
                              color: eventDate.isBefore(currentDate)
                                  ? Colors.grey
                                  : Colors.white,
                              fontSize: 18,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w600,
                            ),*/
                          //),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );

            return eventWidget;
          }).toList();

          return Stack(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: FractionalTranslation(
                      translation: Offset(-0.19, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'الأحداث الفلكية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Almarai',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: eventWidgets.length,
                      itemBuilder: (context, index) {
                        return eventWidgets[index];
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Color(0xFF6288FF),
                  child: Icon(Icons.add),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}*/
