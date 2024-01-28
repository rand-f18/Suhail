import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suhail_project/Calendar.dart';
import 'package:suhail_project/Drawer_menu.dart';
import 'package:suhail_project/quizQuestions.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  DateTime _nextDay = DateTime.now().add(Duration(days: 1));
  bool _isButtonVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Positioned(
          left: 100,
          right: 100,
          top: 100,
          child: SizedBox(
            width: 430,
            height: 24,
            child: Padding(
              padding: EdgeInsets.only(left: 50),
              child: Text(
                'اختبار سُهيل',
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
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("IM/QuizUI2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 300, // Adjust the width as needed
            height: 380,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Icon(
                    Icons.help_outline_rounded,
                    color: Color(0xff72b2ff), // Change color as needed
                    size: 110,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(13),
                  width: 332,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    ' اختبار سُهيل اليومي',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  width: 380,
                  height: 40,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                    child: Text(
                      '! اختبر معلوماتك الفلكية معنا',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_isButtonVisible)
                  FutureBuilder<String>(
                    future: _calculateTimeRemaining(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Color.fromARGB(255, 254, 255, 255),
                        );
                      } else if (snapshot.hasError) {
                        return Column(
                          children: [
                            const Text(
                              'Error calculating time remaining',
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                width: 100,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                QuizPage()));
                                  },
                                  child: const Text(
                                    'ابدأ ',
                                    style: TextStyle(
                                      fontFamily: 'Almarai',
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                width: 328,
                                height: 48,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Color(0xff72b2ff),
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                quizQuestions()));
                                  },
                                  child: const Text(
                                    'ابدأ ',
                                    style: TextStyle(
                                      fontFamily: 'Almarai',
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              snapshot.data!,
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontSize: 14,
                                color: Color.fromARGB(255, 47, 45, 45),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _calculateTimeRemaining() async {
    DateTime nextDayMidnight =
        DateTime(_nextDay.year, _nextDay.month, _nextDay.day, 0, 0, 0);
    Duration timeRemaining = nextDayMidnight.difference(DateTime.now());
    int hours = timeRemaining.inHours;
    int minutes = timeRemaining.inMinutes % 60;
    return '   الاختبار ينتهي بعد :  $hours ساعة و $minutes دقيقة';
  }
}
