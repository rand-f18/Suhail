import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'Community.dart';
import 'Calendar.dart';
import 'PlanetariumPage.dart';
import 'Quiz.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 4; // كفهرس للصفحة المحددة
  List<Widget> _pages = [
    QuizPage(),
    Community(),
    PlanteariumPage(
      url: 'https://stellarium-web.org/',
    ),
    CalendarPage(),
    DashboardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,

        currentIndex: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.quiz,
              size: 30,
              color: Colors.white,
            ),
            label: "اختبار سهيل",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.people,
              size: 30,
              color: Colors.white,
            ),
            label: 'مجتمع سُهيل',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Image.asset(
              'IC/Planet.png', // استبدل هنا بالمسار الصحيح لصورة الكوكب
              width: 30,
              height: 30,
              color: Colors.white,
            ),
            label: 'القبة الفلكية',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.calendar_today,
              size: 30,
              color: Colors.white,
            ),
            label: 'التقويم الفلكي',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.home_rounded,
              size: 35,
              color: Colors.white,
            ),
            label: 'الصفحة الرئيسية',
          ),
        ],

        selectedLabelStyle: TextStyle(
          fontFamily: 'Almarai',
        ),
        //selectedItemColor: Colors.white,
        //unselectedItemColor: Colors.white.withOpacity(0.6),
      ),
      body: Stack(
        children: [
          for (int i = 0; i < _pages.length; i++)
            Visibility(
              visible: _page == i,
              child: _pages[i],
            ),
        ],
      ),
    );
  }
}
