import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:suhail_project/EventPage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:ui' as ui;
import 'dart:io';
import 'EventPage.dart';
import 'package:image_picker/image_picker.dart';
import 'CP_menu.dart';

class EventModificationPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventModificationPage({required this.event});

  @override
  _EventModificationPageState createState() => _EventModificationPageState();
}

class _EventModificationPageState extends State<EventModificationPage> {
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventDateController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
  TextEditingController _eventDateTimeController = TextEditingController();
  String? _eventImage;
  File? _selectedImage;
  String? eventNameError;
  String? eventdisError;
  bool? pass = false;
  bool? madeChange = false;

  @override
  void initState() {
    super.initState();
    _eventNameController.text = widget.event['name'];
    _eventDateController.text = widget.event['starName'];
    _eventDescriptionController.text = widget.event['not'];

    _eventDateTimeController.text = widget.event['date'].toString();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDateController.dispose();
    _eventDescriptionController.dispose();
    _eventDateTimeController.dispose();

    super.dispose();
  }

  void _saveEvent() async {
    String eventName = _eventNameController.text;
    String eventDate = _eventDateController.text;
    String eventDescription = _eventDescriptionController.text;
    String eventDateTime = _eventDateTimeController.text;

    setState(() {
      eventNameError =
          eventName.isEmpty || eventName.replaceAll(" ", "").length > 20
              ? 'الرجاء إدخال اسم الحدث وأن لا يزيد عن 20 حرفًا'
              : null;

      eventdisError = eventDescription.isEmpty ||
              eventDescription.replaceAll(" ", "").length > 30
          ? 'الرجاء إدخال وصف للحدث وأن لا يزيد عن 30 حرفًا'
          : null;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300.0,
          width: 400,
          color: Color(0xff72b2ff),
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  color: Colors.white, // Text color
                  fontFamily: 'Almarai',
                  fontSize: 13, // Font size
                ),
              ),
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumYear: 2000,
              maximumYear: 2100,
              onDateTimeChanged: (DateTime newDateTime) {
                // Do something with the selected date
                final arabicDateFormat =
                    intl.DateFormat('EEEE, d MMMM, yyyy', 'ar');
                final EFormat = intl.DateFormat('yyyy-MM-dd', 'en');

                final formattedDate =
                    '${arabicDateFormat.format(newDateTime)} ';
                _eventDateController.text = formattedDate;
                _eventDateTimeController.text =
                    '${EFormat.format(newDateTime)} ';
              },
              backgroundColor: Color(0xff72b2ff),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "إرفاق الصورة",
              style: TextStyle(
                fontFamily: 'Almarai',
                color: Color(0xFF1C1C1E),
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(
                  File(pickedFile.path),
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // إغلاق الشاشة
                      },
                      child: Text("إلغاء",
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            color: Color(0xFF1C1C1E),
                          )),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xff72b2ff),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // إغلاق الشاشة
                        setState(() {
                          _selectedImage = File(pickedFile.path);
                          madeChange = true;
                        });
                      },
                      child: Text(
                        "إرفاق الصورة",
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          color: Colors.white,
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
            onPressed: () {
              if (madeChange == true) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'تأكيد الإلغاء',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Almarai'),
                      ),
                      content: Text(
                        "هل أنت متأكد من رغبتك في إلغاء التغييرات؟",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Almarai'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // إخفاء الـ AlertDialog
                          },
                          child: Text(
                            "تراجع",
                            style: TextStyle(
                                fontFamily: 'Almarai', color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context); // إخفاء الـ AlertDialog
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => EventPage(),
                              ),
                            );
                          },
                          child: Text(
                            "إلغاء",
                            style: TextStyle(
                                fontFamily: 'Almarai', color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => EventPage(),
                  ),
                );
              }
            },
            child: Text(
              "إلغاء",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Almarai",
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                _saveEvent();

                if (eventNameError == null && eventdisError == null) {
                  String eventName = _eventNameController.text;
                  String eventDate = _eventDateController.text;
                  String eventDescription = _eventDescriptionController.text;
                  String eventDateTime = _eventDateTimeController.text;
                  // Create a reference to the Firebase storage bucket
                  final firebase_storage.FirebaseStorage storage =
                      firebase_storage.FirebaseStorage.instance;
                  final firebase_storage.Reference storageRef =
                      storage.ref().child('images');

                  // Check if a new image is selected
                  if (_selectedImage != null) {
                    // Upload the new image to Firebase storage
                    final firebase_storage.UploadTask uploadTask = storageRef
                        .child(DateTime.now().toString())
                        .putFile(_selectedImage!);
                    final firebase_storage.TaskSnapshot storageSnapshot =
                        await uploadTask.whenComplete(() => null);

                    // Get the download URL of the uploaded image
                    String eventImageURL =
                        await storageSnapshot.ref.getDownloadURL();

                    // Update the event image URL
                    widget.event['imageUrl'] = eventImageURL;
                  }

                  // Update the event details

                  // Get the document ID associated with the event
                  String eventId = widget.event['eventId'];

                  // Update the event in Firestore
                  FirebaseFirestore.instance
                      .collection('CP')
                      .doc(eventId)
                      .update({
                    'Event': eventName,
                    'Date': eventDate,
                    'DateTime': eventDateTime,
                    'Notification': eventDescription,
                    'Image': widget.event['imageUrl'],
                  });
                  pass = true;
                  // Close the page

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Events(),
                    ),
                  );
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
              child: Text(
                "حفظ",
                style: TextStyle(fontFamily: 'Almarai'),
              ),
              style: TextButton.styleFrom(
                primary: Color(0xff72b2ff),// text color
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
                SizedBox(height: 16.0),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: _eventImage != null || _selectedImage != null
                          ? _selectedImage != null
                              ? Image.file(
                                  _selectedImage!,
                                )
                              : Image.network(
                                  widget.event['imageUrl'],
                                )
                          : Image.network(
                              widget.event['imageUrl'],
                            ),
                    ),
                    Positioned(
                      top: 5,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'اسم الحدث',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Almarai',
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    // so if user pressed 'cancel' after editing the fieldm we confirm the cancel
                    madeChange = true;
                  },
                  controller: _eventNameController,
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
                  onChanged: (value) {
                    // so if user pressed 'cancel' after editing the fieldm we confirm the cancel
                    madeChange = true;
                  },
                  controller: _eventDescriptionController,
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
                    eventdisError ?? '',
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
                    'التاريخ',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Almarai',
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    // so if user pressed 'cancel' after editing the fieldm we confirm the cancel
                    madeChange = true;
                  },
                  controller: _eventDateController,
                  onTap: _selectDate,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white)),
                    prefixIcon: IconButton(
                      onPressed: _selectDate,
                      icon: Icon(Icons.calendar_today),
                      color: Colors.white,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Almarai',
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ));
  }
}
