import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:suhail_project/Drawer_menu.dart';
import 'package:date_format/date_format.dart';
import 'package:suhail_project/Navbar.dart';

class myNotifications extends StatefulWidget {
  const myNotifications({super.key});

  @override
  State<myNotifications> createState() {
    return myNotificationsstate();
  }
}

class myNotificationsstate extends State<myNotifications> {
  XFile? _image;
  BuildContext? mainDialogContext;
  bool isLiked = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> Notifications = [];

  List<String> _pageRoutes = [
    '/community',
    '/planetarium',
    '/calendar',
    '/home',
  ];

  Future<List<Map<String, dynamic>>> getNotificationsFromFirebase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String username = '';
    try {
      // get the username of the current user from the database
      DocumentSnapshot documentSnapshot = await firestore
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      username =
          documentSnapshot.exists ? documentSnapshot['Username'] : "null";

      // get the Notifications of the current user from the database
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Notifications')
            .where('photoPublisher', isEqualTo: username)
            .get();

        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          if (data != null) {
            String title = data['title'] ?? '';
            String body = data['body'] ?? '';
            String imageURL = data['imageURL'] ?? '';
            DateTime? publishTime = data['publishTime'].toDate();
            Map<String, dynamic> imageInfo = {
              'title': title, //The tilte of the notifications
              'body': body, //The body of the notifications
              "publishTime": publishTime, //The time  the image was published
              'imageURL': imageURL, // The URL of the image
            };
            // add the notifications to the Notifications list
            Notifications.add(imageInfo);
          }
        }
      }
    } catch (e) {
      print('Error retrieving user Notifications: $e');
    }
    Notifications.sort((a, b) => b["publishTime"].compareTo(a["publishTime"]));
    return Notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 1,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => BottomNavBar()));
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(2.0),
              child: Container(
                color: Colors.white,
                height: 0.1,
              ),
            ),
            title: const Positioned(
              left: 100,
              top: 100,
              child: SizedBox(
                width: 280,
                height: 24,
                child: Text(
                  'تنبيهاتي',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getNotificationsFromFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 99, 136, 255),
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      "لا يوجد لديك تنبيهات",
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ));
                  } else {
                    return ListView.builder(
                      itemCount: Notifications.length,
                      itemBuilder: (context, index) {
                        return _buildImageCard(Notifications[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String publishTime = ' ';
  Widget _buildImageCard(Map<String, dynamic> NotificationseData) {
    String body = NotificationseData['body']!;
    String imageURL = NotificationseData['imageURL']!;
    String publishTime = DateFormat('dd/MM/yyyy HH:mm', 'ar')
        .format(NotificationseData['publishTime']);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: const Color(0xFF1C1C1E),
        elevation: 5.0,
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(2),
                  ),
                  const Text(
                    "إعجاب",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Almarai',
                        fontSize: 20),
                  ),
                  Spacer(),
                  Text(
                    publishTime,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Almarai',
                        fontSize: 20),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Container(
                  width: 80, // Set the width to create a square
                  height: 80, // Set the height to match the width
                  child: Image.network(
                    imageURL,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),

                const SizedBox(width: 10),

                // Text on the Right
                Expanded(
                  child: Text(
                    "   " + body,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Almarai',
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
