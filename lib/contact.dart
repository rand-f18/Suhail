import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'HomePage.dart';
import 'Navbar.dart';

void main() {
  runApp(contact());
}

/// comment --

class contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContactPage(),
    );
  }
}

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final Uri phoneNumber = Uri.parse('tel:+0530636903');
    final Uri whatsApp = Uri.parse('https://wa.me/0530636903');
    

    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.fromLTRB(90, 0, 0, 0),
            child: Text(
              'عن سُهَيل',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 19,
                fontFamily: 'Almarai',
              ),
            ),
          ),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => BottomNavBar()));
            },
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [
                Colors.black,
                Color.fromARGB(255, 8, 3, 30),
                Color.fromARGB(255, 8, 3, 48)
              ],
            ),
          ),

          // Image.asset('IM/app_logo.png'),

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Container(
                  width: 900,
                  height: 125,
                  decoration: ShapeDecoration(
                    color: Color.fromARGB(30, 154, 153, 158),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          'سُهَيل هو أول تطبيق عَربي مُهتم بالفَلك',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            fontFamily: 'Almarai',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(17, 0, 0, 0),
                        child: Container(
                          width: 55,
                          height: 65,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'IM/app_black_logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(260, 20, 0, 0),
                child: Text(
                  'المزيد عنا',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    fontFamily: 'Almarai',
                    color: Colors.white,
                  ),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      'تطبيق سهيل هو تطبيق فلكي مثير للاهتمام يهدف إلى جمع مجتمع من الأفراد الذين يشتركون في شغفهم بعجائب الكون. يمكن للهواة والمحترفين على حد سواء مشاركة صور مذهلة للأحداث الفلكية مع المجتمع، يبقى سهيل المستخدم على اطلاع بالأحداث الفلكية وأحداث الفصول السنوية من خلال تقويم مدمج يقوم بعرضها. واحدة من أبرز ميزات سهيل هي القبة الفلكية، حيث يمكن للمستخدمين مسح النجوم واكتشاف معلومات ثرية حولها. حاليًا، يتوفر تطبيق سهيل تحت سماء المملكة العربية السعودية، ونسعى لتطويره في المستقبل',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: 'Almarai',
                        color: Colors.white,
                      ),
                    ),
                  )),
              const Padding(
                padding: EdgeInsets.fromLTRB(230, 50, 0, 0),
                child: Text(
                  'للتواصل معنا',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    fontFamily: 'Almarai',
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    //   width: 50,
                    //   height: 50,
                    //   decoration: ShapeDecoration(
                    //    color: Color.fromARGB(30, 154, 153, 158),
                    //     shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20),
                    //  ),
                    // ),
                    child: GestureDetector(
                      onTap: (() async {
                        launchUrl(whatsApp);
                      }),
                      child: Container(
                          width: 35,
                          height: 35,
                          child: Image.asset('IC/whatsapp.png')),
                    ),
                  ),
                  SizedBox(width: 35),
                  Container(
                    //   width: 50,
                    //   height: 50,
                    //   decoration: ShapeDecoration(
                    //    color: Color.fromARGB(30, 154, 153, 158),
                    //     shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20),
                    //  ),
                    // ),
                    child: GestureDetector(
                      onTap: () => calling(),
                      child: Icon(
                        Icons.phone,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  void calling() async {
    final Uri num = Uri.parse('tel:+0530636903');
    if (await canLaunchUrl(num)) {
      await launchUrl(num);
    } else {
      throw 'could not launch';
    }
  }

  // whats()async{
  //   final Uri chat = Uri.parse('whatsapp://send?phone=+0530636903');
  //       if (await canLaunchUrl(chat)){
  //     await launchUrl(chat);
  //   } else{
  //     throw 'could not launch';
  //   }
  // }
}
