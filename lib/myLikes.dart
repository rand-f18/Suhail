import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:suhail_project/Calendar.dart';
import 'package:suhail_project/Community.dart';
import 'package:suhail_project/Drawer_menu.dart';
import 'package:suhail_project/HomePage.dart';
import 'package:suhail_project/Navbar.dart';
import 'package:suhail_project/PlanetariumPage.dart';

class myLikes extends StatefulWidget {
  const myLikes({super.key});

  @override
  State<myLikes> createState() {
    return myLikesState();
  }
}

class myLikesState extends State<myLikes> {
  XFile? _image;
  BuildContext? mainDialogContext;
  bool isLiked = false;

  int _selectedIndex = -1;

  List<bool> _iconSelected = [false, false, false, true];

  List<Map<String, dynamic>> likedImages = [];

  List<String> _pageRoutes = [
    '/community',
    '/planetarium',
    '/calendar',
    '/home',
  ];

  void _onIconTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      Navigator.pushNamed(context as BuildContext, _pageRoutes[index]);
    }
  }

  Future<List<Map<String, dynamic>>> getLikedImagesByCurrentUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String currentUserID = user.uid;

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('SuhailCommunityphotos')
            .where('likes', arrayContains: currentUserID)
            .get();

        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          FirebaseFirestore firestore = FirebaseFirestore.instance;
          String? username;

          if (data != null) {
            String imageURL = data['imageURL'] ?? '';
            String userID = data['user ID'] ?? '';
            DateTime? dateTime = data['datetime'].toDate();
            try {
              DocumentSnapshot documentSnapshot =
                  await firestore.collection('Users').doc(userID).get();
              username = documentSnapshot.exists
                  ? documentSnapshot['Username']
                  : "null";
            } catch (e) {}

            Map<String, dynamic> imageInfo = {
              'imageURL': imageURL,
              'userID': username!,
              "datetime": dateTime,
            };

            likedImages.add(imageInfo);
          }
        }
      }
    } catch (e) {
      print('Error retrieving liked images: $e');
    }
    likedImages.sort((a, b) => b["datetime"].compareTo(a["datetime"]));
    return likedImages;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Scaffold(
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
                  'إعجاباتي',
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
                future: getLikedImagesByCurrentUser(),
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
                      'لم تقم بالإعجاب بأي صورة بعد ',
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ));
                  } else {
                    return ListView.builder(
                      itemCount: likedImages.length,
                      itemBuilder: (context, index) {
                        return _buildImageCard(likedImages[index]);
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

  Widget _buildImageCard(Map<String, dynamic> imageData) {
    String imageURL = imageData['imageURL']!;
    String userID = imageData['userID']!;
    String dateTime =
        DateFormat('dd/MM/yyyy HH:mm', 'en').format(imageData['datetime']);
    Future<List<dynamic>?> list = getLikesForImage(imageURL);
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
                    child: Icon(
                      Icons.account_circle_sharp,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Text(
                    userID,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Almarai',
                        fontSize: 18),
                  ),
                  Spacer(),
                  Text(
                    dateTime,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Almarai',
                        fontSize: 18),
                  )
                ],
              ),
            ),
            // Image
            Image.network(
              imageURL,
              height: 400,
              width: 400,
              fit: BoxFit.cover,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FutureBuilder<List<dynamic>?>(
                  future: getLikesForImage(imageURL),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Loading state
                      return const CircularProgressIndicator(
                        color: Color(0xff72b2ff),
                      );
                    }

                    if (snapshot.hasError) {
                      // Handle the error
                      return const Icon(
                        Icons.favorite_border_outlined,
                        size: 30,
                        color: Colors.white,
                      );
                    }

                    final likes = snapshot.data;

                    // Calculate the number of likes
                    final numLikes = likes != null ? likes.length : 0;

                    // Check if the current user has liked the image
                    final isLiked = likes != null &&
                        likes.contains(FirebaseAuth.instance.currentUser!.uid);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          " $numLikes ",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Almarai',
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 35,
                            color: isLiked ? Colors.red : Colors.white,
                          ),
                          onPressed: () {
                            // Toggle like status
                            likePost(imageURL,
                                FirebaseAuth.instance.currentUser!.uid);
                            refreshUI();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            )

            // Username
          ],
        ),
      ),
    );
  }

  Future<void> refreshUI() async {
    List<Map<String, dynamic>> newData = await getLikedImagesByCurrentUser();
    setState(() {
      likedImages.clear();
      // Add newly fetched data at the beginning of the list
      likedImages.addAll(newData);
    });
  }
}

Future<String> likePost(String imageURL, String uid) async {
  String res = "Some error occurred";
  try {
    final likesCollection =
        FirebaseFirestore.instance.collection('SuhailCommunityphotos');
    final likeQuery =
        await likesCollection.where('imageURL', isEqualTo: imageURL).get();

    if (likeQuery.docs.isNotEmpty) {
      // Document with the imageURL exists
      final doc = likeQuery.docs.first;
      final List<dynamic>? likes = doc['likes'];

      if (likes != null && likes.contains(uid)) {
        // User has already liked this photo; unlike it
        await doc.reference.update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // User hasn't liked this photo; like it
        await doc.reference.update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } else {
      // The document with the imageURL does not exist; create it with the initial like
      await likesCollection.add({
        'imageURL': imageURL,
        'likes': [uid]
      });
    }

    res = 'success';
  } catch (err) {
    res = err.toString();
  }
  return res;
}
