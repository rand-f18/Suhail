import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:suhail_project/SettingsPage.dart';
import 'package:suhail_project/firebase_options.dart';
import 'package:suhail_project/main.dart';
import 'changeProviderPass.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('ar'); // added By nouf for calender*/
}

class CPDrawer extends StatefulWidget {
  @override
  _CPDrawerState createState() => _CPDrawerState();
}

class _CPDrawerState extends State<CPDrawer> {


  @override
  Widget build(BuildContext context) {
  
    return Drawer(
        child: Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Colors.black,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text( "Suhail Content Provider",
                
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
               "suhailcontentprovider@gmail.com",
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
            ),),
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
                    'تغيير كلمة المرور',
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
                    builder: (BuildContext context) => changePasswordPage(),
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