import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suhail_project/HomePage.dart';
import 'package:suhail_project/Navbar.dart';
import 'package:suhail_project/PlanetariumPage.dart';
import 'package:suhail_project/main.dart';
import 'SettingUI.dart';
import 'changePassword.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                padding: EdgeInsets.only(right: 40),
                child: Text(
                  'الإعدادات',
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
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              const Row(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                      size: 30,
                      Icons.person,
                      color: Colors.white54,
                      weight: 44),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "الحساب",
                    style: TextStyle(
                        fontFamily: 'Almarai',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54),
                  ),
                ],
              ),
              Divider(
                height: 15,
                thickness: 1,
                color: Colors.white,
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  padding: EdgeInsets.all(13),
                  width: 332,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: Color(0xFF1C1C1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: GestureDetector(
                    child: const Text(
                      textAlign: TextAlign.start,
                      'تحديث المعلومات الشخصية ',
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const SettingsUI()));
                    },
                  )),
              const SizedBox(
                height: 5,
              ),
              Container(
                  padding: EdgeInsets.all(13),
                  width: 332,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: Color(0xFF1C1C1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: GestureDetector(
                    child: const Text(
                      textAlign: TextAlign.right,
                      'تغيير كلمة المرور',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => changePassword()));
                    },
                  )),
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.all(13),
                width: 332,
                height: 60,
                decoration: ShapeDecoration(
                  color: Color(0xFF1C1C1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: GestureDetector(
                  child: const Text(
                    textAlign: TextAlign.center,
                    'حذف الحساب',
                    style: TextStyle(
                      color: Color(0xFFA50000),
                      fontSize: 18,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  onTap: () async {
                    try {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'تأكيد الحذف',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                ),
                              ),
                              content: const Text(
                                'هل أنت متأكد من رغبتك في حذف حسابك؟',
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
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: 'Almarai',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      String currentUserID = "";

                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      if (user != null) {
                                        currentUserID = user.uid;
                                      }
                                      Navigator.of(context).pop();

                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  WelcomePage()));
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            content: Text(
                                              'تم حذف الحساب  بنجاح',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Almarai'),
                                            ),
                                          );
                                        },
                                      );
                                      await deleteLikesForUser(currentUserID);
                                      await deleteUserNotification(
                                          currentUserID);
                                      await deleteUserData(currentUserID);
                                      await deleteUserAccount();
                                    } catch (e) {
                                      print("error in finding uid");
                                    }
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
                                )
                              ],
                            );
                          });
                    } catch (e) {}
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteUserNotification(String currentUserID) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String username = '';
      try {
        DocumentSnapshot documentSnapshot =
            await firestore.collection('Users').doc(currentUserID).get();
        username =
            documentSnapshot.exists ? documentSnapshot['Username'] : "null";
      } catch (e) {}

      // Delete user's photos from SuhailCommunityphotos collection
      await FirebaseFirestore.instance
          .collection('Notifications')
          .where('username', isEqualTo: username)
          .get()
          .then((QuerySnapshot snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      print('1- Error deleting Notifications: $e');
    }
  }

  Future<void> deleteUserData(String currentUserID) async {
    try {
      // Delete user data from Users collection
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserID)
          .delete();

      // Delete user's photos from SuhailCommunityphotos collection
      await FirebaseFirestore.instance
          .collection('SuhailCommunityphotos')
          .where('user ID', isEqualTo: currentUserID)
          .get()
          .then((QuerySnapshot snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      print('1- Error deleting user data: $e');
    }
  }

  Future<void> deleteLikesForUser(String currentUserID) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('SuhailCommunityphotos')
          .where('likes', arrayContains: currentUserID)
          .get();

      for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        List<String> likes = List.from(doc.data()!['likes']);
        likes.remove(currentUserID);

        await FirebaseFirestore.instance
            .collection('SuhailCommunityphotos')
            .doc(doc.id)
            .update({'likes': likes});
      }
    } catch (e) {
      print('2- Error deleting user likes: $e');
    }
  }
}

Future<void> deleteUserAccount() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      print('3- No user logged in.');
      // Handle the case where no user is logged in
    }
  } catch (e) {
    print('4- Error deleting user authentication: $e');
  }
}
