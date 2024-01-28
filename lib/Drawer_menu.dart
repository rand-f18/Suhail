import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:suhail_project/Calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:suhail_project/Community.dart';
import 'package:suhail_project/SettingsPage.dart';
import 'package:suhail_project/firebase_options.dart';
import 'package:suhail_project/main.dart';
import 'package:suhail_project/myAlbum.dart';
import 'package:suhail_project/myLikes.dart';
import 'package:suhail_project/myNotifications.dart';
import 'PlanetariumPage.dart';
import 'Community.dart';
import 'contact.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('ar'); // added By nouf for calender*/
}

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? FirstName = '';
  String? LastName = '';

  String? Username = '';

  Future _getDataFromDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((Snapshot) async {
      if (Snapshot.exists) {
        setState(() {
          FirstName = Snapshot.data()!["First name"];
          LastName = Snapshot.data()!["Last name"];

          Username = Snapshot.data()!["Username"];
        });
      }
    });
    _getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    _getDataFromDatabase();
    return Drawer(
        child: Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Colors.black,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                FirstName! + ' ' + LastName!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                Username! + '@',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 15,
                  color: Color(0xFF6B6B6D),
                ),
              ),
             
              decoration: const BoxDecoration(
image: DecorationImage(image: AssetImage("IM/UserHeader.png"
),fit: BoxFit.cover)



              ),
            ),
            const Divider(
              color: Color(0xFF1C1C1E),
            ),
            ListTile(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 25,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'ألبومي',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Almarai',
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const myAlbum(),
                  ),
                );
              },
            ),
            const Divider(
              color: Color(0xFF1C1C1E),
            ),
            ListTile(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.favorite_border_outlined,
                    size: 25,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'إعجاباتي',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Almarai',
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const myLikes(),
                  ),
                );
              },
            ),
            const Divider(
              color: Color(0xFF1C1C1E),
            ),
            ListTile(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notifications_none_outlined,
                    size: 25,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'تنبيهاتي',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Almarai',
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => myNotifications(),
                  ),
                );
              },
            ),
            const Divider(
              color: Color(0xFF1C1C1E),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'IC/Setting.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'الإعدادات',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Almarai',
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SettingsPage(),
                  ),
                );
              },
            ),
            const Divider(
              color: Color(0xFF1C1C1E),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'IM/Logo2.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'عن سُهيل',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Almarai',
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => contact(),
                  ),
                );
              },
            ),
            const Divider(
              color: Color(0xFF1C1C1E),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'IC/Exit.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      color: Color(0xFFA50000),
                      fontFamily: 'Almarai',
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => WelcomePage(),
                    ),
                  );
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          'تم تسجيل الخروج بنجاح',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Almarai'),
                        ),
                      );
                    },
                  );
                } catch (e) {
                  print("Error logging out: $e");
                }
              },
            ),
            const Divider(
              color: Color(0xFF1C1C1E),
            ),
          ],
        ),
      ),
    ));
  }
}
