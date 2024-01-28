import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:suhail_project/Calendar.dart';
import 'package:suhail_project/Community.dart';
import 'package:suhail_project/Drawer_menu.dart';
import 'package:suhail_project/HomePage.dart';
import 'package:suhail_project/Navbar.dart';
import 'package:suhail_project/PlanetariumPage.dart';
import 'package:suhail_project/UploadFeedbackDialog.dart';

class myAlbum extends StatefulWidget {
  const myAlbum({super.key});

  @override
  State<myAlbum> createState() {
    return myAlbumstate();
  }
}

class myAlbumstate extends State<myAlbum> {
  XFile? _image;
  BuildContext? mainDialogContext;
  bool isLiked = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = -1;

  List<bool> _iconSelected = [false, false, false, true];

  List<Map<String, dynamic>> filterdImageList = [];

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

  Future<List<Map<String, dynamic>>> getImageDataFromFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String currentUserID = user.uid;

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('SuhailCommunityphotos')
            .where('user ID', isEqualTo: currentUserID)
            .get();

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        String? username;

        try {
          DocumentSnapshot documentSnapshot =
              await firestore.collection('Users').doc(currentUserID).get();
          username =
              documentSnapshot.exists ? documentSnapshot['Username'] : "null";
        } catch (e) {}

        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          if (data != null) {
            String imageURL = data['imageURL'] ?? '';
            String userID = data['user ID'] ?? '';
            DateTime? dateTime = data['datetime'].toDate();

            Map<String, dynamic> imageInfo = {
              'imageURL': imageURL,
              'userID': username!,
              "datetime": dateTime,
            };

            filterdImageList.add(imageInfo);
          }
        }
      }
    } catch (e) {
      print('Error retrieving user images: $e');
    }
    filterdImageList.sort((a, b) => b["datetime"].compareTo(a["datetime"]));
    return filterdImageList;
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
                child: Padding(
                  padding: EdgeInsets.only(right: 40.0),
                  child: Text(
                    'ألبومي',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            )),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getImageDataFromFirebase(),
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
                      "لا توجد صور،  شاركنا الآن",
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ));
                  } else {
                    return ListView.builder(
                      itemCount: filterdImageList.length,
                      itemBuilder: (context, index) {
                        return _buildImageCard(filterdImageList[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(290, 0, 10, 50),
          child: FloatingActionButton(
            onPressed: () async {
              var image = await showModalBottomSheet<XFile>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 150.0,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.photo_camera,
                            color: Color.fromARGB(255, 18, 32, 47),
                          ),
                          title: const Text(
                            'التقط صورة بالكاميرا',
                            style: TextStyle(
                                color: Color.fromARGB(255, 18, 32, 47)),
                          ),
                          onTap: () async {
                            var image = await _pickImage(ImageSource.camera);
                            Navigator.pop(context, image);
                          },
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 18, 32, 47),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.photo_library,
                            color: Color.fromARGB(255, 18, 32, 47),
                          ),
                          title: const Text(
                            'اختر صورة من معرض الصور',
                            style: TextStyle(
                                color: Color.fromARGB(255, 18, 32, 47)),
                          ),
                          onTap: () async {
                            var image = await _pickImage(ImageSource.gallery);
                            Navigator.pop(context, image);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );

              if (image != null) {
                setState(() {
                  _image = image;
                  _showPicDialog(context);
                });
              }
            },
            backgroundColor: const Color(0xff72b2ff),
            mini: false,
            child: const Icon(
              Icons.add_photo_alternate,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Future<XFile?> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    try {
      return await imagePicker.pickImage(source: source);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
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
                        Positioned(
                          right: 10, // Adjust the left position as needed
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Show a confirmation dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'تأكيد الحذف',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Almarai',
                                        fontSize: 30,
                                      ),
                                    ),
                                    content: const Text(
                                      'هل ترغب بحذف هذة الصورة',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Almarai',
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the confirmation dialog
                                        },
                                        child: const Text(
                                          'إلغاء',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Almarai',
                                            color: Color(0xff72b2ff),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context)
                                              .pop(); // Close the confirmation dialog
                                          await deletePost(imageURL);

                                          refreshUI();
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              Colors.red, // Background color
                                        ),
                                        child: const Text(
                                          'حذف',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Almarai',
                                            color: Colors.white, // Text color
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 8), // Add some spacing between icons

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
                            setState(() {
                              filterdImageList.clear();
                              likePost(imageURL,
                                  FirebaseAuth.instance.currentUser!.uid);
                            });
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

  Future<void> _showPicDialog(ctx) async {
    double imageHeight = 0.0;

    try {
      if (_image != null) {
        final image = Image.file(File(_image!.path));
        final completer = Completer<void>();
        image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener((info, _) {
            completer.complete();
            imageHeight = info.image.height.toDouble();
          }),
        );
        await completer.future;
      }
    } catch (e) {
      print('Error loading image: $e');
    }

    imageHeight = min(imageHeight, MediaQuery.of(ctx).size.height * 0.4);

    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        mainDialogContext = context;
        return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: Container(
              height: imageHeight + 150, // Adjusted height based on the image
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Column(children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0, top: 7),
                  child: Text(
                    textAlign: TextAlign.right,
                    "مشاركة صورة",
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 30,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: imageHeight, // Adjusted height for the image
                    child: _image != null
                        ? Image.file(
                            File(_image!.path),
                            height: imageHeight,
                            width: 400,
                          )
                        : const Text(
                            "لا يوجد صورة",
                            style: TextStyle(fontFamily: 'Almarai'),
                          ),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 5),
                  child: Text(
                    "هل ترغب بمشاركة هذه الصورة؟",
                    style: TextStyle(
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                        refreshUI();
                      },
                      child: const Text("إلغاء",
                          style: TextStyle(
                              fontFamily: 'Almarai', color: Colors.black)),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xff72b2ff),
                        ),
                      ),
                      onPressed: () {
                        // Pass the main dialog context to uploadImage
                        uploadImage(ctx);
                      },
                      child: const Text(
                        "مشاركة الصورة",
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ));
      },
    );
  }

  Future<void> refreshUI() async {
    List<Map<String, dynamic>> newData = await getImageDataFromFirebase();
    setState(() {
      filterdImageList.clear();
      // Add newly fetched data at the beginning of the list
      filterdImageList.addAll(newData);
    });
  }

  Future<void> uploadImage(BuildContext context) async {
    String fileName = basename(_image!.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(File(_image!.path));
    BuildContext? loadingDialogContext;
    // Show a loading dialog while uploadingzzz
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        loadingDialogContext = context;
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(
                color: Color.fromRGBO(7, 25, 81, 1),
              ),
              SizedBox(width: 20.0),
              Text(
                "جار مشاركة الصورة",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  color: Color.fromRGBO(7, 25, 81, 1),
                ),
              ),
            ],
          ),
        );
      },
    );

    try {
      await uploadTask.whenComplete(() async {
        // Get the download URL of the uploaded image
        String downloadURL = await firebaseStorageRef.getDownloadURL();
        String userID = await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .id;

        // Save the download URL to Firestore
        await FirebaseFirestore.instance
            .collection('SuhailCommunityphotos')
            .doc()
            .set({
          'imageURL': downloadURL,
          'user ID': userID,
          'likes': [],
          'datetime': DateTime.now(),
        });

        // Add the newly added image to the image list

        /* addImageToImageList({
          'imageURL': downloadURL,
          'userID': userID,
        });*/
        refreshUI();
      });
    } catch (e) {
      print(e);
    }

    try {
      await uploadTask.whenComplete(() {
        // Close the loading dialog
        if (loadingDialogContext != null) {
          Navigator.of(loadingDialogContext!).pop();
        }

        // Show a success dialog for a few seconds

        late Timer timer;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            timer = Timer(const Duration(seconds: 1), () {
              Navigator.of(context).pop();
              Navigator.of(mainDialogContext!).pop();
            });
            return const UploadFeedbackDialog(
              message: 'تمت مشاركة الصورة بنجاح',
              messageTextStyle: TextStyle(
                fontFamily: 'Almarai',
                color: Color.fromRGBO(7, 25, 81, 1),
              ),
            );
          },
        ).then((_) {
          if (timer.isActive) {
            timer.cancel();
          }
        });
      });
    } catch (e) {
      // Handle errors
      print('Error uploading image: $e');
      if (loadingDialogContext != null) {
        if (!context.mounted) return;

        Navigator.of(loadingDialogContext!).pop(); // Close the loading dialog
      }
      late Timer timer;

      // Show an error dialog
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          timer = Timer(const Duration(seconds: 1), () {
            Navigator.of(context).pop();
            Navigator.of(mainDialogContext!).pop();
          });
          return UploadFeedbackDialog(
            message: 'المعذرة حصل خطأ ما! الرجاء المحاولة مرة أخرى: $e',
            messageTextStyle: const TextStyle(
              fontFamily: 'Almarai',
              color: Color.fromRGBO(7, 25, 81, 1),
            ),
            onTimerEnd: () {
              Navigator.of(context).pop(); // Close the error dialog
            },
          );
        },
      ).then((_) {
        if (timer.isActive) {
          timer.cancel();
        }
      });
    } finally {
      print("here");
    }
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

Future<List<dynamic>?> getLikesForImage(String imageURL) async {
  try {
    final likesCollection =
        FirebaseFirestore.instance.collection('SuhailCommunityphotos');
    final likeQuery =
        await likesCollection.where('imageURL', isEqualTo: imageURL).get();

    if (likeQuery.docs.isNotEmpty) {
      final doc = likeQuery.docs.first;
      final likes = doc['likes'];
      return likes;
    } else {
      // No document with the imageURL found, return null or an empty list as appropriate
      return null;
    }
  } catch (err) {
    print('Error getting likes: $err');
    return null;
  }
}

Future<String> deletePost(String imageURL) async {
  String res = "Some error occurred";
  try {
    final likesCollection =
        FirebaseFirestore.instance.collection('SuhailCommunityphotos');
    final likeQuery =
        await likesCollection.where('imageURL', isEqualTo: imageURL).get();

    if (likeQuery.docs.isNotEmpty) {
      final doc = likeQuery.docs.first;
      await doc.reference.delete();

      res = 'success';
    }
  } catch (err) {
    res = err.toString();
  }
  return res;
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: DashboardPage(),
      routes: {
        '/community': (context) => Community(),
        '/planetarium': (context) => PlanteariumPage(
              url: 'https://stellarium-web.org/',
            ),
        '/calendar': (context) => CalendarPage(),
        '/home': (context) => DashboardPage(),
      },
    );
  }
}
