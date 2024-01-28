import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suhail_project/suhailNotification.dart';
import 'package:table_calendar/table_calendar.dart';
import './firebase_options.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:ui' as ui;
import 'Drawer_menu.dart';
import 'SignIn.dart';
import 'UserEditEvent.dart';
// notification
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math'; // for generating random notification id's
//import 'package:timezone'

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Event {
  final String title;
  final String? description;
  final DateTime date;
  final String id;
  final String? userID;
  final int? reminder;
  final int notificationID;
  Event(
      {required this.title,
      this.description,
      required this.date,
      required this.id,
      this.userID,
      this.reminder,
      required this.notificationID});

  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Event(
        date: data['date'].toDate(),
        title: data['title'],
        description: data['description'],
        id: snapshot.id,
        userID: data['userID'],
        reminder: data['reminder'],
        notificationID: data['notificationID']);
  }

  factory Event.contentProviderfromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Event(
        date: DateFormat("yyyy-MM-dd").parse(data['DateTime']),
        title: data['Event'],
        description: data['Notification'],
        id: snapshot.id,
        // no userID
        reminder: 0,
        notificationID: -2);
  }

  Map<String, Object?> toFirestore() {
    return {
      "date": Timestamp.fromDate(date),
      "title": title,
      "description": description,
      "reminder": reminder
    };
  }

  Map<String, Object?> contentProvidertoFirestore() {
    return {
      "DateTime": Timestamp.fromDate(date),
      "Event": title,
      "Notification": description
    };
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    initializeDateFormatting('ar');
    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Calendar(),
          ),
        ],
      ),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<Event>> _events;
  //bool _showAddEvent = false; will come back inshaallah, only for making the page look cooler

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _loadFirestoreEvents();

    // for notification
    SuhailNotification notification = SuhailNotification();
    notification.initializeNotifications();
  }

  _loadFirestoreEvents() async {
    _events = {};

// User Events
    final userSnap = await FirebaseFirestore.instance
        .collection('events')
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: Event.fromFirestore,
            toFirestore: (event, options) => event.toFirestore())
        .get();

// Content Provider Events
    final contentProviderSnap = await FirebaseFirestore.instance
        .collection('CP')
        .withConverter(
            fromFirestore: Event.contentProviderfromFirestore,
            toFirestore: (cp, options) => cp.contentProvidertoFirestore())
        .get();

    for (var doc in userSnap.docs) {
      final event = doc.data();
      final day =
          DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }

    for (var doc in contentProviderSnap.docs) {
      final cp = doc.data();
      final day = DateTime.utc(cp.date.year, cp.date.month, cp.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(cp);
    }

    setState(() {});
  }

  List<Event> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: AppDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("التقويم الفلكي"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Almarai',
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          Directionality(
            textDirection: ui.TextDirection.rtl,
            child: TableCalendar(
              pageJumpingEnabled: true,
              currentDay: DateTime.now(),
              locale: 'ar',
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              eventLoader: _getEventsForTheDay,
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: _firstDay,
              lastDay: _lastDay,
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                _loadFirestoreEvents();
              },
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(
                    color: Colors.white, fontSize: 20, fontFamily: 'Almarai'),
                titleCentered: true,
                formatButtonVisible: false,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
              calendarStyle: CalendarStyle(
                  rowDecoration: BoxDecoration(
                    //color: Color(0xA0071952).withOpacity(0.4),
                    color: Color(0xA0071952), //.withOpacity(0.40),
                  ),
                  defaultTextStyle: TextStyle(
                      color: Colors.white, fontSize: 16, fontFamily: 'Almarai'),
                  holidayTextStyle: TextStyle(
                      color: Colors.white, fontSize: 16, fontFamily: 'Almarai'),
                  //here
                  markerDecoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'أحداث هذا اليوم',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
            ),
          ),
          ..._getEventsForTheDay(_selectedDay).map(
            (event) => Container(
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 5),
              child: ListTile(
                trailing: const Icon(
                  Icons.auto_awesome_outlined,
                  size: 30,
                ),

                iconColor:
                    event.userID == FirebaseAuth.instance.currentUser!.uid
                        ? const Color(0xFF1C1C1E)
                        : Color.fromARGB(255, 232, 232, 238),
                textColor:
                    event.userID == FirebaseAuth.instance.currentUser!.uid
                        ? const Color(0xFF1C1C1E)
                        : Color.fromARGB(255, 232, 232, 238),
                tileColor:
                    event.userID == FirebaseAuth.instance.currentUser!.uid
                        ? Colors.white
                        : Color(0xA0071952),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                contentPadding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                // ListTileTitleAlignment k:    ListTileTitleAlignment.center,

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Text(event.title, textAlign: TextAlign.right),
                    Visibility(
                      visible: event.userID ==
                          FirebaseAuth.instance.currentUser!.uid,
// user can edit/delete his/her own events only

                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'تأكيد الحذف',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Almarai',
                                        //  fontSize: 30,
                                      ),
                                    ),
                                    content: const Text(
                                      'هل أنت متأكد من رغبتك في حذف الحدث؟',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Almarai',
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context)
                                              .pop(); // Close the confirmation dialog
                                          deleteEvent(event);
                                          _loadFirestoreEvents();
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              Colors.red, // Background color
                                        ),
                                        child: const Text(
                                          'حذف',
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
                                          'إلغاء',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontFamily: 'Almarai',
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          UserEditEvent(event: event)));
                              if (result ?? false) {
                                _loadFirestoreEvents();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    //Text(event.title, textAlign: TextAlign.right),
                    Expanded(
                      child: Text(
                        event.title,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                subtitle: Text(event.description.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.grey)),
                //onTap: () => _something,
              ),
            ),
            // ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(300, 0, 10, 70),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => AddEvent(
                  firstDate: _firstDay,
                  lastDate: _lastDay,
                  selectedDate: _selectedDay,
                ),
              ),
            );
            if (result ?? false) {
              _loadFirestoreEvents();
            }
          },
          backgroundColor: const Color(0xff72b2ff),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// Add Event State
class AddEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? selectedDate;

  const AddEvent(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      this.selectedDate})
      : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  int? reminderTime = -1;
  late DateTime _selectedDate;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String? eventNameError;
  String? eventDescriptionError;
  bool? pass = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now(); // hmm ok
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("IM/BCKSTARS.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("حدث جديد",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Almarai',
              )),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 20),
            SuhailField(_titleController, "عنوان الحدث", null, false, null),
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
            const SizedBox(height: 20),
            SuhailField(_descController, "وصف الحدث", null, false, null),
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
            //fixed menu
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(left: 80.0, right: 10)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'وقت التذكير بالحدث',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Almarai',
                        ),
                      ),
                    ),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.arrow_drop_down,
                            color: Color(0xFF6288FF), size: 44),
                      ),
                      iconSize: 0.0,
                      isExpanded: true,
                      isDense: false,
                      //alignment: AlignmentDirectional.topStart,
                      value: reminderTime,
                      onChanged: (value) {
                        setState(() {
                          reminderTime = value;
                        });
                      },
                      dropdownColor: const Color.fromARGB(255, 57, 56, 56),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Almarai',
                      ),
                      borderRadius: BorderRadius.circular(20),
                      items: const [
                        DropdownMenuItem<int>(
                          value: -1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('بلا تذكير'),
                            ],
                          ),
                        ),
                        DropdownMenuItem<int>(
                          value: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('في يوم الحدث'),
                            ],
                          ),
                        ),
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('قبل يوم من الحدث'),
                            ],
                          ),
                        ),
                        DropdownMenuItem<int>(
                          value: 7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('قبل أسبوع من الحدث'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 27),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                    width: 328,
                    height: 57,
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        color: Color(0xff72b2ff),
                        onPressed: () async {
                          _addEvent(reminderTime);
                        },
                        child: const Text(
                          "إضافة الحدث",
                          style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 20,
                              color: Colors.white),
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addEvent(int? reminderTime) async {
    final title = _titleController.text;
    final description = _descController.text;
    // generate a random integer ID for each notification
    final Random random = Random();
    int notificationId = random.nextInt(100000);

    if (title.isEmpty || title.length > 20) {
      setState(() {
        eventNameError = 'الرجاء إدخال اسم الحدث وأن لا يزيد عن 20 حرفًا';
        pass = false;
      });
    } else {
      eventNameError = null;
    }

    if (description.length > 30) {
      setState(() {
        eventDescriptionError = 'الرجاء إدخال وصف للحدث لا يزيد عن 30 حرفًا';
        pass = false;
      });
    } else {
      eventDescriptionError = null;
    }

    if (eventNameError == null && eventDescriptionError == null) {
// To unify all events time to be at 12:00AM -- why tho
      DateTime eventDate = _selectedDate.toLocal();
      eventDate = DateTime(
          eventDate.year, eventDate.month, eventDate.day, 0, 0, 0, 0, 0);

// storing notification time
      SuhailNotification addNotification = SuhailNotification();
      addNotification.initializeNotifications();
      DateTime eventTime = _selectedDate;

      DateTime notificationTime = getNotificationTime(eventTime, reminderTime);
      if (reminderTime! > 0 || reminderTime == 0) {
        // user selected to be notified on the event day
        addNotification.scheduleNotification(
            notificationTime, title, description, reminderTime, notificationId);
      }

      final userId =
          FirebaseAuth.instance.currentUser!.uid; // Get the user's ID
      await FirebaseFirestore.instance.collection('events').add({
        "userID": userId,
        "title": title,
        "description": description,
        "date": eventDate,
        "reminder": reminderTime,
        "notificationID": notificationId
      });
      if (mounted) {
        Navigator.pop<bool>(context, true);
      }
    }
  }
}

DateTime getNotificationTime(DateTime eventTime, int? reminderTime) {
  DateTime notificationTime = DateTime.now();

  if (reminderTime == 0) {
    // same day
    notificationTime = eventTime;
  } else if (reminderTime == 1) {
    // day before
    notificationTime = eventTime.subtract(const Duration(days: 1));
  } else if (reminderTime == 7) {
    // week before
    notificationTime = eventTime.subtract(const Duration(days: 7));
  } else {
    // -1
// No notification
  }

  return notificationTime;
}

// Delete Event
Future<bool> deleteEvent(Event event) async {
  String eventId = event.id;
  FirebaseFirestore.instance
      .collection('events')
      .doc(eventId)
      .delete()
      .then((value) {
    print('Event deleted successfully');
    return true;
  }).catchError((error) {
    print('Failed to delete event: $error');
    return false;
  });
  return false;
}
