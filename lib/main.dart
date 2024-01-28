import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:suhail_project/EventPage.dart';
import 'package:suhail_project/SignIn.dart';
import 'package:suhail_project/SignUp.dart';
import 'package:suhail_project/fire_data.dart';
import 'package:suhail_project/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  modelList = await getData();
  model = getSingleModel();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suhail',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF071951),
        ),
        child: Center(
          child: Image.asset(
            "IM/Logo2.png",
            width: 120,
            height: 120,
          ),
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("IM/NEWBK.jpg"), fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
            //added by rand
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 0),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(right: 14),
                  child: const Text(
                    "مرحبًا بك في سُهَيْل",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(right: 14),
                  child: const Text(
                    "التطبيق الذي سيأسرك بسحر الكواكب والنجوم",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(right: 14),
                  child: const Text(
                    "ومواسم السماء في المملكة العربية السعودية",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(right: 50),
                  child: const Text(
                    " ! انضم إلينا وانغمس في عالم الفلك ",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Container(
                  width: 360,
                  height: 30,
                ),
                const SizedBox(height: 0),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff72b2ff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: Size(328, 52),
                  ),
                  child: const Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to New User screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: Size(328, 52),
                  ),
                  child: const Text(
                    "مستخدم جديد",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
