import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:suhail_project/Calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:suhail_project/Community.dart';
import 'package:suhail_project/Drawer_menu.dart';
import 'package:suhail_project/SettingsPage.dart';
import 'package:suhail_project/firebase_options.dart';
import 'package:suhail_project/main.dart';
import 'PlanetariumPage.dart';
import 'Community.dart';
import 'Drawer_menu.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('ar'); // added By nouf for calender
  runApp(MyApp());
}

Future<String> fetchMoonImageUrl() async {
  final response = await http.get(Uri.parse(
      'https://api.nasa.gov/planetary/apod?api_key=uwikXURFcb6dnBLrrWHwTlUU2ES7ctnTiv3hv9zb'));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final mediaType = jsonData['media_type'];
    final title = jsonData['title'];

    // Check if media type is image and title includes 'moon'
    if (mediaType == 'image' &&
        (title.toLowerCase().contains('moon') ||
            title.toLowerCase().contains('star') ||
            title.toLowerCase().contains('sun') ||
            title.toLowerCase().contains('stars') ||
            title.toLowerCase().contains('norway') ||
            title.toLowerCase().contains('sky') ||
            title.toLowerCase().contains('aurora') ||
            title.toLowerCase().contains('galaxy'))) {
      return jsonData['url'];
    } else {
      return
          //'https://wallpapercave.com/wp/wp10350043.jpg';
          //'https://i.pinimg.com/originals/2e/4c/5b/2e4c5bd59dbf3d04145e109e10ff1f5e.png';
          //'https://cdn.wallpapersafari.com/17/0/UxT6gX.jpg';
          'https://getwallpapers.com/wallpaper/full/b/b/e/673515.jpg';
    }
  } else {
    throw Exception('Failed to fetch APOD data');
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      home: DashboardPage(),
      // routes: {
      //   '/community': (context) => CommunityPage(),
      //   '/planetarium': (context) => PlanetariumPage(),
      //   '/calendar': (context) => CalendarPage(),
      //   '/home': (context) => DashboardPage(),
      // },
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  /*String? FirstName = '';
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
  }*/

  int _selectedIndex = -1;

  List<bool> _iconSelected = [false, false, false, true];

  final List<String> _pageRoutes = [
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

      Navigator.pushNamed(context, _pageRoutes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    final now = DateTime.now();
    final formatter = DateFormat('EEEE d MMMM. yyyy', 'ar');
    final formattedDate = formatter.format(now);

    final DateTime currentDate = DateTime.now();

    late Future<String> apodImageUrl = fetchMoonImageUrl();

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: ListView(
          children: [
            Stack(
              // first child
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    width: 350,
                    //height: 150,
                    height: 197,

                    child:

                        //       FutureBuilder<List<Map<String, dynamic>>>(
                        //       future: fetchMoonPictures(),
                        //       builder: (context, snapshot) {
                        //       if (snapshot.hasData) {
                        //       final moonPictures = snapshot.data!;
                        //       return ListView.builder(
                        //       itemCount: moonPictures.length,
                        //       itemBuilder: (context, index) {
                        //       final imageUrl = moonPictures[index]['url'];
                        //       return Image.network(imageUrl);
                        //       },
                        //       );
                        //       } else if (snapshot.hasError) {
                        //       return Text('Failed to fetch moon pictures');
                        //       } else {
                        //       return CircularProgressIndicator();
                        //       }
                        //    },
                        // ),

                        FutureBuilder<String>(
                            future: apodImageUrl,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final imageUrl = snapshot.data!;
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              return const CircularProgressIndicator(
                                color: Color(0xff72b2ff),
                              );
                            }),

                    // لعرض صوره عاديه مب من ناسا
                    //   decoration: ShapeDecoration(
                    //     image: const DecorationImage(
                    //   image: NetworkImage("https://getwallpapers.com/wallpaper/full/b/b/e/673515.jpg"),
                    //   fit: BoxFit.cover,
                    // ),
                    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                    //      ),
                  ),
                ),
                Positioned(
                  // top: 120,
                  top: 170,
                  left: 225,
                  child: Text(
                    formattedDate,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 250, 248, 248),
                      fontSize: 16,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),

            // show deferent content depending on the current date
            // الجبهه
            if (currentDate.isAfter(DateTime(2024, 9, 6)) &&
                currentDate.isBefore(DateTime(2024, 9, 20)))
              (StarText('سهيل', 'الجبهة',
                  "يبرد فيها الجو ليلا، مع استمرار الحرارة المرتفعة وسط النهار")),
            if (currentDate.isAfter(DateTime(2024, 9, 6)) &&
                currentDate.isBefore(DateTime(2024, 9, 20)))
              (StarPeom(
                  'قال أحمد بن شاهين القبرسي',
                  'عَجِبْتُ للشَّمسِ إذْ حلَّت مؤثِّرةً في جَبْهةٍ لَمْ أَخَلْها قَطُّ في البشرِ',
                  'وإنما الجَبْهةُ الغرَّاءُ منزلةٌ مختصَّةٌ في ذرى الأفلاك بالقمرِ',
                  'ما كنتُ أحسَبُ أنَّ الشَّمس تعشقُهُ حتى تبيَّنتُ منها حدَّةَ النَّظرِ',
                  '',
                  '',
                  '')),
            // الزبرة
            if (currentDate.isAfter(DateTime(2023, 9, 20)) &&
                currentDate.isBefore(DateTime(2023, 10, 3)))
              (StarText('سهيل', 'الزبرة',
                  'يبرد فيه الليل ويكثر هبوب الرياح الشمالية ويتساوى فيه الليل مع النهار بإذن الله')),

            if (currentDate.isAfter(DateTime(2023, 9, 20)) &&
                currentDate.isBefore(DateTime(2023, 10, 3)))
              (StarPeom(
                  'من أشعار العرب التي ذهبت مضرب المثل في الاختلاف بين شيئيين قولهم',
                  'أَيُّهَا الْمُنْكِحُ الثُّرَيَّا سُهَيْلً',
                  'عَمْرَكَ اللهِ كَيْفَ يَلْتَقِيَانِ',
                  'هِيَ شَامِيَّةٌ إِذَا مَا اسْتَهَلَّتْ',
                  'وَسُهَيْلٌ إِذَا اسْتُهِلَّ يَمَانِ',
                  '',
                  '')),
            // الصرفة
            if (currentDate.isAfter(DateTime(2023, 10, 3)) &&
                currentDate.isBefore(DateTime(2023, 10, 16)))
              (StarText('سهيل', 'الصرفة',
                  "ابتداء دخول الوسمي وهو مطر الربيع الأول المنبت للفقع يعتدل فيها الجو نهارا وتزداد برودة الليل وسميت صرفة لانصراف الحر عند طلوعها")),

            if (currentDate.isAfter(DateTime(2023, 10, 3)) &&
                currentDate.isBefore(DateTime(2023, 10, 16)))
              (StarPeom(
                  'من أشعار العرب التي ذهبت مضرب المثل في الاختلاف بين شيئيين قولهم',
                  'أَيُّهَا الْمُنْكِحُ الثُّرَيَّا سُهَيْلً',
                  'عَمْرَكَ اللهِ كَيْفَ يَلْتَقِيَانِ',
                  'هِيَ شَامِيَّةٌ إِذَا مَا اسْتَهَلَّتْ',
                  'وَسُهَيْلٌ إِذَا اسْتُهِلَّ يَمَانِ',
                  '',
                  '')),
            // العواء
            if (currentDate.isAfter(DateTime(2023, 10, 16)) &&
                currentDate.isBefore(DateTime(2023, 10, 29)))
              (StarText('الوسم', 'العواء',
                  "يسمونه المزارعون ثريا الوسم ينبت فيه الفقع (الكمأة) يستحسن فيه زراعة الحبوب ويطيب فيه الهواء مع زيادة برود الليل")),
            if (currentDate.isAfter(DateTime(2023, 10, 16)) &&
                currentDate.isBefore(DateTime(2023, 10, 29)))
              (StarPeom(
                  'قال ساجع العرب في طالع العواء',
                  'اذا طلع العواء ضرب الخباء وطاب الهواء وكره العراء وشنن السقاء',
                  '',
                  'أي أنه عند طلوع العواء يبرد الليل فيضرب الخباء ويكره النوم في الصحاري، وتجف قرب الماء لأنهم لا يستقون منها في ذلك الوقت',
                  '',
                  '',
                  '')),
            // السماك
            if (currentDate.isAfter(DateTime(2023, 10, 29)) &&
                currentDate.isBefore(DateTime(2023, 11, 11)))
              (StarText('الوسم', 'السماك',
                  "أمطاره غزيرة بإذن الله تعالى وقلما يخف ويكون الهواء فيه رطبا\nتهيج فيه أمراض الحساسية بأنواعها المختلفة ( كالربو ) بسبب التقلبات الجوية وكذلك نزلات البرد")),
            if (currentDate.isAfter(DateTime(2023, 10, 29)) &&
                currentDate.isBefore(DateTime(2023, 11, 11)))
              (StarPeom(
                  'تقول فيه العرب',
                  'إذا طلع السماك ، ذهب العكاك ، وقل على الماء اللكاك',
                  'ومعنى ( العكاك ) : الحر\nواللكاك : الازدحام على الماء',
                  '',
                  'يراد قلة الازدحام عليه ، لقلة شرب الإبل للماء في ذلك الوقت ',
                  '',
                  '')),
            // الغفر
            if (currentDate.isAfter(DateTime(2023, 11, 11)) &&
                currentDate.isBefore(DateTime(2023, 11, 24)))
              (StarText('الوسم', 'الغفر',
                  "تبدأ فيه المظاهر الشتوية، وتزداد برودة الجو ليلا أكثر من ذي قبل ، مع اعتدال في النهار")),
            if (currentDate.isAfter(DateTime(2023, 11, 11)) &&
                currentDate.isBefore(DateTime(2023, 11, 24)))
              (StarPeom(
                  'وتُضرب بـ “الغَفْرِ” الأمثال في علوِّ الهمَّة، كقول البحتري في الخليفة المتوكِّل',
                  'مُتَمَكِّنٌ مِن هاشِمٍ في رُتبَةٍ عَلياءَ بَينَ الغَفْرِ وَالإِكليلِ',
                  'قَومٌ إِذا عَرَضَ الجَهولُ لِمَجدِهِم عَطَفَت عَلَيهِ قَوارِعُ التَنْزيلِ',
                  '',
                  '',
                  '',
                  '')),
            // الزبانا
            if (currentDate.isAfter(DateTime(2023, 11, 24)) &&
                currentDate.isBefore(DateTime(2023, 12, 7)))
              (StarText('الوسم', 'الزبانا',
                  "أول فصل من فصول الشتاء يبدأ فيه تأثير الانقلاب الشتوي ودخول البرد يتميز بغزاره الامطار بإذن الله")),
            if (currentDate.isAfter(DateTime(2023, 11, 24)) &&
                currentDate.isBefore(DateTime(2023, 12, 7)))
              (StarPeom(
                'قال ساجع العرب',
                "",
                // ' إِذَا طَلَعَتِ الزَّبَانَا أَحْدَثْتُ',
                // 'لِكُلِّ ذِي عِيَالٍ شَأْنًا',
                // 'وَلِكُلِّ ذِي مَاشِيَةٍ هَوَانًا',
                // 'وَقَالُوا كَانَ وَكَانًا',
                // 'فَأَجْمَعْ أَهْلَكَ وَلَا تَوَانَا'
                'إِذَا طَلَعَتِ الزَّبَانَا أَحْدَثْتُ لِكُلِّ ذِي عِيَالٍ شَأْنًا وَلِكُلِّ ذِي مَاشِيَةٍ هَوَانًا وَقَالُوا كَانَ وَكَانًا فَأَجْمَعْ أَهْلَكَ وَلَا تَوَانَا',
                '',
                '',
                '',
                '',
              )),
            // الاكليل
            if (currentDate.isAfter(DateTime(2023, 12, 7)) &&
                currentDate.isBefore(DateTime(2023, 12, 20)))
              (StarText('المربعانية', 'الإكليل',
                  "تشتد فيه قسوة البرد وتنشط فيه الرياح الباردة")),
            if (currentDate.isAfter(DateTime(2023, 12, 7)) &&
                currentDate.isBefore(DateTime(2023, 12, 20)))
              (StarPeom(
                  'قال الوزير ابن المصيصي',
                  'أضاءَ بك الأُفْقُ الذي كان أظلما وقد لُحتَ في الإكليلِ بدرًا متمّمَا',
                  'على أيِّ وجهٍ لم يُشعْشِعْ طَلاقةً وَفي أيِّ ثغْرٍ لم يُنَوّرْ تَبَسُّمَا',
                  'وقد صُغْتَ من ذاكَ المحيّا وحسنِهِ صَباحًا ومِنْ تلكَ الخلائِقِ أنْجُمَا',
                  'إذا غبتَ عن أرضٍ تمثَّلَ أهلُها "عَسَى وطنٌ يَدْنو بِهِمْ ولَعلَّمَا',
                  '',
                  '')),
            // القلب
            if (currentDate.isAfter(DateTime(2023, 12, 20)) &&
                currentDate.isBefore(DateTime(2024, 1, 2)))
              (StarText('المربعانية', 'القلب',
                  "يشتد فيه البرد وينتهي قصر النهار وطول الليل ويبدأ النهار في الزيادة")),
            if (currentDate.isAfter(DateTime(2023, 12, 20)) &&
                currentDate.isBefore(DateTime(2024, 1, 2)))
              (StarPeom(
                  'قال عبد الغني النابلسي',
                  'إن تَبْدُ قُلْ للشَّمسِ قولةَ ناصِحٍ باللهِ يا شمسَ النَّهارِ تحجَّبي ',
                  'هي كالغزالةِ إنْ بَدَتْ وتلفَّتَتْ لكنَّها حُجِبَتْ بقلبِ الْعَقْرَبِ',
                  '',
                  '',
                  '',
                  '')),
            // الشولة
            if (currentDate.isAfter(DateTime(2024, 1, 2)) &&
                currentDate.isBefore(DateTime(2024, 1, 15)))
              (StarText('المربعانية', 'الشولة', "يشتد فيه البرد")),
            if (currentDate.isAfter(DateTime(2024, 1, 2)) &&
                currentDate.isBefore(DateTime(2024, 1, 15)))
              (StarPeom(
                  'ذكر أبو الطيِّب المتنبي',
                  'رمَى الدَّرْبَ بالجُرْدِ الْغِنَاقِ إلى العِدا وما علموا أنَّ السِّهامَ خيولُ',
                  'شَوائِلَ تَشوالَ العَقارِبِ بِالقَنا لَها مَرَحٌ مِن تَحتِهِ وَصَهيلُ',
                  '',
                  '',
                  '',
                  '')),
            // النعايم
            if (currentDate.isAfter(DateTime(2024, 1, 15)) &&
                currentDate.isBefore(DateTime(2024, 1, 28)))
              (StarText('الشبط', 'النعايم', 'يزداد فيها البرد، والصقيع')),
            if (currentDate.isAfter(DateTime(2024, 1, 15)) &&
                currentDate.isBefore(DateTime(2024, 1, 28)))
              /*
              (StarPeom('قال الشريف دَفتر خُوَان وقد عرَّج على ذِكْرِ "النَّعائم" في قصيدة تناول فيها المنازل ونجومها',
                  'كأن نجومَ الغَفْرِ وهي ثلاثةٌ أَثافيُّ خلَّاها على الدارِ راحلُ',
                  'كأن بها سربَ النعائم راعه قنيصٌ فمنه واردٌ وَمُواِئلُ',
                  'كأن بها الإكليلَ تاجُ مُتَوَّجٍ ومن حوله بالبيضِ جَيْشٌ مقاتلُ',
                  'كأن بها نهرَ المجرة مَنْهَلٌ له قافلٌ نالَ الورودَ ونازلُ',
                  '', '')),
                  */
              (StarPeom(
                  'تقول فيه العرب',
                  '،إذا طلعت النعايم؛ ابيضت البهائم من الصقيع الدائم\"',
                  '،وقصر النهار للصائم، و كبرت العمائم',
                  '\"وخلص البرد إلى كل نائم، وتلاقت الرعاة بالنمائم',
                  '',
                  '',
                  '')),

            // البلده
            if (currentDate.isAfter(DateTime(2024, 1, 28)) &&
                currentDate.isBefore(DateTime(2024, 2, 10)))
              (StarText('الشبط', 'البلدة',
                  "نوؤها محمود، وقل ما يخلف مطرها بإذن الله تعالى")),
            if (currentDate.isAfter(DateTime(2024, 1, 28)) &&
                currentDate.isBefore(DateTime(2024, 2, 10)))
              (StarPeom('', '', '', '', '', '', '')),
            // سعد الذابح
            if (currentDate.isAfter(DateTime(2024, 2, 10)) &&
                currentDate.isBefore(DateTime(2024, 2, 23)))
              (StarText('العقارب', 'سعد الذابح',
                  "تهب فيه الرياح الشمالية الشرقية الجافة، الباردة")),
            if (currentDate.isAfter(DateTime(2024, 2, 10)) &&
                currentDate.isBefore(DateTime(2024, 2, 23)))
              (StarPeom(
                  'قال الشريف الموسوي الطوسي',
                  'ما لِلْبَليدِ ما أَتى بطائلِ يقولُهُ في بَلْدةِ المنازلِ',
                  'خُذْ وصفها من عربيٍّ باسلِ مثل الإوز طُفْنَ بالمناهلِ',
                  'أو كالشهودِ حول مالٍ مائلِ بالطيلساناتِ وبالغلائلِ',
                  'أو كالعُفاةِ حول بَذْلِ النّائلِ كشكلِ ثوبٍ من يمينِ فاضلِ',
                  '',
                  '')),
            // سعد بٌلع
            if (currentDate.isAfter(DateTime(2024, 2, 23)) &&
                currentDate.isBefore(DateTime(2024, 3, 8)))
              (StarText('العقارب', 'سعد بٌلع',
                  "تكون فيه أشعة الشمس حارة، ويصعب الجلوس في حرورها كثيرا")),
            if (currentDate.isAfter(DateTime(2024, 2, 23)) &&
                currentDate.isBefore(DateTime(2024, 3, 8)))
              (StarPeom(
                  'قال ابن دنينير',
                  'أهلَتْ ربوعُ المَكرمات بجودِهِ مِن بعدِ ما عَهِدتْ برسمٍ ماصِحِ',
                  'تُلِيَتْ مناقِبُهُ وسُيِّرَ ذِكْرُه بين الرُّواة وكلِّ غادٍ رَائِحِ',
                  'لِعدوِّه ووليِّهِ من كَفِّهِ سَعدُ السُّعودِ وذاكَ سَعْدُ الذّابِحِ',
                  '',
                  '',
                  '')),
            // سعد السعود
            if (currentDate.isAfter(DateTime(2024, 3, 8)) &&
                currentDate.isBefore(DateTime(2024, 3, 21)))
              (StarText(
                  'العقارب', 'سعد السعود', "يعتدل فيه الجو، خاصة وقت النهار")),
            if (currentDate.isAfter(DateTime(2024, 3, 8)) &&
                currentDate.isBefore(DateTime(2024, 3, 21)))
              (StarPeom(
                  'قال الكميت',
                  'ولم يك نشؤك لي إذ نشأت كنوء الزُّبانَى عَجاجًا ومُورا',
                  'ولكنْ بِنجمِكَ سعدُ السُّعودِ طبقت أرضي غيثًا دَرورا',
                  '',
                  '',
                  '',
                  '')),
            // سعد الاخبية
            if (currentDate.isAfter(DateTime(2024, 3, 21)) &&
                currentDate.isBefore(DateTime(2024, 4, 3)))
              (StarText('الحميمين', 'سعد الاخبية', "يزداد فيه الجو دفئا")),
            if (currentDate.isAfter(DateTime(2024, 3, 21)) &&
                currentDate.isBefore(DateTime(2024, 4, 3)))
              (StarPeom(
                  'وقال الصفاقسي',
                  'وقال الصفاقسي',
                  'حللتُ بدارِ القيروانِ بجَحْفَلٍ فَخِلْنا بُدُورَ الأُفْقِ حَلَّتْ مَع الشُّهْبِ',
                  'وفُسطاطُك الميمونُ حِينَ نَصَبتَهُ ظننَّا رِياضَ الزَّهْرِ في أخْضَرِ العُشْبِ',
                  'فسعدُ سُعودِ المُلْكِ أنْتَ وإنما خِباؤُك فِيها سَعْدُ أخْبِيَةٍ النُّصْبِ',
                  'وشرَّعْتَ أحْكامًا بها عُمَرِيَّةً فأصْبَحَ مِنْهَا الشّاءُ يَرْعَى مَعَ الذِّئْبِ',
                  '')),
            // المقدم
            if (currentDate.isAfter(DateTime(2024, 4, 3)) &&
                currentDate.isBefore(DateTime(2024, 4, 16)))
              (StarText(
                  'الحميمين', 'المقدم ', " ترتفع فيه درجات الحرارة عن ذي قبل")),
            if (currentDate.isAfter(DateTime(2024, 4, 3)) &&
                currentDate.isBefore(DateTime(2024, 4, 16)))
              (StarPeom(
                  'قال أبو العلاء المعرِّي',
                  'وَأَمسى اللَيثُ مِنها لَيثَ غابٍ يُجاذِبُ فَرسَهُ المُتَوَحِّداتُ',
                  'وَآضَ الفَرْغُ لِلسَّاقينَ فَرْغًا تُحاوِلُ ماءَهُ المُتَوَرِّداتُ',
                  'وَهَبَّ يَرومُ سُنبُلَةَ السَّواري خَبيرٌ وَالزَّرائِعُ مُحصِداتُ',
                  '',
                  '',
                  '')),
            // المؤخر
            if (currentDate.isAfter(DateTime(2024, 4, 16)) &&
                currentDate.isBefore(DateTime(2024, 4, 29)))
              (StarText('الذراعين', 'المؤخر',
                  " يعتدل فيه الجو ليلا، ويميل إلى الحرارة وقت الظهيرة")),
            if (currentDate.isAfter(DateTime(2024, 4, 16)) &&
                currentDate.isBefore(DateTime(2024, 4, 29)))
              (StarPeom(
                  'قال ابن الأبَّار البَلَنْسي',
                  'مَرَرْتُ بِأَطْلالِ الأَحِبَّة باكِيًا فَدَهْدَهَ مَطْلُولُ الدُّمُوعِ بِها المَرْوَا',
                  'وَقَدْ كانَ أَخْوَى النَّجْمُ واحتَبَسَ الحَيا فَشَكْوًا لِسَيْلٍ مِنهُ يُرعِبُ مَنْ أَخْوَى',
                  'وَلَو أَنَّ لِلسُحْبِ السِّفاحِ مَدامِعِي لَما أَبْصَرُوا مِنْها جَهَامًا وَلا نَجْوَا',
                  'كأَنَّ دِلاء مِنْ جُفونِيَ أُفْرِغَتْ فَلا نُكْر إنْ لَمْ يَعْرِفُوا الفَرْغَ وَالدَّلوَا',
                  '',
                  '')),
            // الرشا
            if (currentDate.isAfter(DateTime(2024, 4, 29)) &&
                currentDate.isBefore(DateTime(2024, 5, 12)))
              (StarText('الذراعين', 'الرشا',
                  " نوءه محمود، غزير فيه المطر (بإذن الله تعالى) وقل ما يخلف مطره")),
            if (currentDate.isAfter(DateTime(2024, 4, 29)) &&
                currentDate.isBefore(DateTime(2024, 5, 12)))
              (StarPeom(
                  'قال علي بن محمد الكاتب',
                  'والبدرُ كالملكِ الأَعلى وأنْجُمُهُ جنودُهُ ومباني قصره الفَلَكُ',
                  'والنهرُ من تحته مثلُ المجرةِ والـ رشاء يشبهه في مائِهِ السمك',
                  '',
                  '',
                  '',
                  '')),
            // الشرطين
            if (currentDate.isAfter(DateTime(2024, 5, 12)) &&
                currentDate.isBefore(DateTime(2024, 5, 25)))
              (StarText('الثريا', 'الشرطين',
                  "يميل فيه الطقس إلى الدفء, يكثر فيه هبوب الرياح، والعواصف")),
            if (currentDate.isAfter(DateTime(2024, 5, 12)) &&
                currentDate.isBefore(DateTime(2024, 5, 25)))
              (StarPeom(
                  'كان أبو العلاء يصف السَّماء كمبصر وهو كفيف، وقال',
                  'سُبحانَ مَن بَرَأَ النُّجومَ كَأَنَّها دُرٌّ طَفا مِن فَوقِ بَحرٍ مائِجِ',
                  'لَو شاءَ رَبُّكَ صَيَّرَ الشَّرطَينِ مِن هَذي الكَواكِبِ عِندَ أَدنى ثائِجِ',
                  'وَالتَّاجُ تَقوى اللهِ لا ما رَصَّعوا لِيَكونَ زينًا لِلأَميرِ التائِجِ',
                  '',
                  '',
                  '')),
            // البطين
            if (currentDate.isAfter(DateTime(2024, 5, 25)) &&
                currentDate.isBefore(DateTime(2024, 6, 7)))
              (StarText('الثريا', 'البطين',
                  " يجف فيه العشب, هو آخر المنازل مطرا (وعلمه عند الله)")),
            if (currentDate.isAfter(DateTime(2024, 5, 25)) &&
                currentDate.isBefore(DateTime(2024, 6, 7)))
              (StarPeom(
                  'وقال القاضي التَّنوخي',
                  'كأنّما الناطِحُ عَيْنَا شاخِصٍ يَضْعُفُ عَن تَغْميضِها مِن الضِّيَا',
                  'كأنّما البُطينُ في آثارِهِ طَالِبُ ثأرٍ عِنْدَ عَاتٍ قَدْ عَتَا',
                  '',
                  '',
                  '',
                  '')),
            // الثريا
            if (currentDate.isAfter(DateTime(2024, 6, 7)) &&
                currentDate.isBefore(DateTime(2024, 6, 20)))
              (StarText('الثريا', 'الثريا', " يشتد فيها الحر والسموم")),
            if (currentDate.isAfter(DateTime(2024, 6, 7)) &&
                currentDate.isBefore(DateTime(2024, 6, 20)))
              (StarPeom(
                  'وقال ابن أبي صبح المزني',
                  'سَقَى الله مِن نَوء الثُّريَّا ظَعَائِنًا تَيَمَّمْنَ نَجدا واختَصَرْنَ المُرَخَّصا',
                  'ظَعَائنَ مِمَّن سَارَ فاحتَلَّ رَابِغًا وَوَدَّانَ أيَّامَ الجلاَءِ فَالأخمَصَا',
                  'أَقَمنَ بِهِ حَتَّى أتَى الصَّيفُ قادِمًا وَقَضَّوا لُبَانَاتِ الرَّبِيعَ فَأَشخَصَا',
                  '',
                  '',
                  '')),
            // الدبران
            if (currentDate.isAfter(DateTime(2024, 6, 20)) &&
                currentDate.isBefore(DateTime(2024, 7, 3)))
              (StarText('التويبع', 'الدبران', "تشتد فيه حرارة الجو")),
            if (currentDate.isAfter(DateTime(2024, 6, 20)) &&
                currentDate.isBefore(DateTime(2024, 7, 3)))
              (StarPeom(
                  'من أشعار العرب في "الدَّبَران" قول ذي الرُّمَّة',
                  'وَماءٍ قَديمِ العَهدِ بِالناسِ آجِنٍ كَأَنَّ الدَبا ماءَ الغَضى فيهِ يَبصُقُ',
                  'وَرَدْتُ اعتِسافا وَالثُّرَيَّا كَأَنَّها عَلى قِمَّةِ الرَّأسِ ابْنُ ماءٍ مُحَلِّقُ',
                  'يَدُفُّ عَلى آثارِها دَبَرانُه فَلا هُوَ مَسبوقٌ وَلا هُوَ يَلحَقُ',
                  'بِعِشرينَ مِن صُغرى النُّجومِ كَأَنَّها وَإياهُ في الخَضراءِ لَو كانَ يَنطِقُ',
                  'قِلاصٌ حَداها راكِبٌ مُتَعَمِّمٌ هَجائِنُ قَد كادَت عَلَيهِ تَفَرَّقُ',
                  'والأبيات تروي الحكاية المعروفة عن الدَّبران والثُّريا')),
            // الهقعه
            if (currentDate.isAfter(DateTime(2024, 7, 3)) &&
                currentDate.isBefore(DateTime(2024, 7, 16)))
              (StarText('الجوزاء', 'الهقعة',
                  " تكثر في نوءها السمائم، والعواصف الترابية")),
            if (currentDate.isAfter(DateTime(2024, 7, 3)) &&
                currentDate.isBefore(DateTime(2024, 7, 16)))
              (StarPeom(
                  'وقال حازم القُرْطَاجَنِّي من قصيدة طويلة يصف بها النجوم',
                  'كأن الثُّريَّا كاعب أزمعت نوى وأمَّت بأقصى الغرب منزلة شَحْطَا',
                  'كأن نجومَ الهقعة الزُّهر هودج لها عن ذوي الحرف المناخة قد حَطَّا',
                  'كأن رِشاء الدَّلو رشوةُ خاطبٍ لها جُعِلَ الأشراطُ في مهرِها شرطا',
                  'كأنَّ السُّها قد دقَّ مِن فرطِ شَوقِهِ إليها كما قد دقَّقَ الكاتبُ النَّقْطا',
                  '',
                  '')),
            // الهنعة
            if (currentDate.isAfter(DateTime(2024, 7, 16)) &&
                currentDate.isBefore(DateTime(2024, 7, 29)))
              (StarText('الجوزاء', 'الهنعة',
                  "تشتد فيها حرارة الجو، ويبلغ الحر أشده")),
            if (currentDate.isAfter(DateTime(2024, 7, 16)) &&
                currentDate.isBefore(DateTime(2024, 7, 29)))
              (StarPeom(
                  'قال ابن الرومي',
                  'وكأنها في الكأس شمسٌ قارنتْ بُرْجَ الهلال فهلَّ بالأضواءِ',
                  'نظم الحبَابَ على شقائقِ أرضها نثرُ اللآلئ من ندى الأنواءِ',
                  'لَمْ أدْرِ هل أبدتْ حَبابًا زاهرًا أو عكسَ نورِ كواكب الجوزاءِ',
                  '',
                  '',
                  '')),
            // الذراع
            if (currentDate.isAfter(DateTime(2024, 7, 29)) &&
                currentDate.isBefore(DateTime(2024, 8, 11)))
              (StarText('المرزم', 'الذراع', " يستمر فيها اشتداد الحر")),
            if (currentDate.isAfter(DateTime(2024, 7, 29)) &&
                currentDate.isBefore(DateTime(2024, 8, 11)))
              (StarPeom(
                  'قال ساجع العرب في صفته',
                  'إذا طلعت الذِّراع، حسرت الشَّمسُ القِناعْ، وأشعلت في الأفق الشُّعاعْ، وترقرق السَّرابُ بكل قاعْ',
                  '',
                  '',
                  '',
                  '',
                  '')),
            // النثرة
            if (currentDate.isAfter(DateTime(2024, 8, 11)) &&
                currentDate.isBefore(DateTime(2024, 8, 24)))
              (StarText('الكلبين', 'النثرة',
                  "تكثر فيها السحب غير الممطرة، الكاتمة للجو، والرافعة لدرجات الحرارة")),
            if (currentDate.isAfter(DateTime(2024, 8, 11)) &&
                currentDate.isBefore(DateTime(2024, 8, 24)))
              (StarPeom(
                  'تقول فيه العرب',
                  'إذا طلعت النَّثْرة، قنأت البسرة، وجني النخل بكرة، وآوت المواشي حجرة، ولم تترك في ذات درٍّ قطرة، وأصابك من السِّحر حسرة، ويوشك أن تظهر الخضرةْ',
                  '',
                  '',
                  '',
                  '',
                  '')),
            // الطرفة
            if (currentDate.isAfter(DateTime(2024, 8, 24)) &&
                currentDate.isBefore(DateTime(2024, 9, 6)))
              (StarText('سهيل', 'الطرفة',
                  "دخول الطرفة هو بداية فصل الخريف عند الفلاحين، وفيها يبرد آخر الليل, يرى نجم سهيل بالبصر")),
            if (currentDate.isAfter(DateTime(2024, 8, 24)) &&
                currentDate.isBefore(DateTime(2024, 9, 6)))
              (StarPeom(
                  'قال شهاب الدين الخلوف',
                  'سَقَا الطَّرْفُ وَادِي مِصْرَ طوفَانَ أدْمُعِي',
                  'وحَامَ عَلْيهَا نَوْءُ تَمِّ وَمُرْزِمِ',
                  'وَقَادَ إلَيْهَا الرّيحُ في كُلّ بُرْهَةٍ',
                  'نَجَائِبَ غَيْمٍ بَيْنَ بِكْرٍ وَأيِّمٍ',
                  '',
                  '')),

            SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.fromLTRB(280, 10, 25, 0),
              child: Container(
                child: Text(
                  'أحداث اليوم',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            Container(
              height: 150,
              child: EventPage(),
            ),
          ],
        ),
      ),

      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.black,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       GestureDetector(
      //         onTap: () => _onIconTapped(0),
      //         child: Container(
      //           padding: EdgeInsets.all(8),
      //           child: Image.asset(
      //             'IC/Community.png',
      //             width: 30,
      //             height: 30,
      //             color: _iconSelected[0] ? Colors.white : Colors.grey,
      //           ),
      //         ),
      //       ),
      //       GestureDetector(
      //         onTap: () => _onIconTapped(1),
      //         child: Container(
      //           padding: EdgeInsets.all(8),
      //           child: Image.asset(
      //             'IC/Planet.png',
      //             width: 30,
      //             height: 30,
      //             color: _iconSelected[1] ? Colors.white : Colors.grey,
      //           ),
      //         ),
      //       ),
      //       GestureDetector(
      //         onTap: () => _onIconTapped(2),
      //         child: Container(
      //           padding: EdgeInsets.all(8),
      //           child: Image.asset(
      //             'IC/Calendar.png',
      //             width: 24,
      //             height: 24,
      //             color: _iconSelected[2] ? Colors.white : Colors.grey,
      //           ),
      //         ),
      //       ),
      //       GestureDetector(

      //         child: Container(
      //           padding: EdgeInsets.all(8),
      //           child: Image.asset(
      //             'IC/Home.png',
      //             width: 24,
      //             height: 24,
      //             color: _iconSelected[3] ? Colors.white : Colors.grey,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

Container StarText(String petral, String star, String events) {
  return Container(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(245, 25, 20, 0),
          child: Container(
            child: Text(
              'نوء $petral',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(240, 10, 0, 0),
          child: Container(
            child: Text(
              'منزلة $star',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(220, 20, 45, 10),
          child: Container(
            child: Text(
              events,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF989898),
                fontSize: 14,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

Padding StarPeom(String? intro, String? first, String? second, String? third,
    String? forth, String? fifth, String? sixth) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
    child: Container(
      width: 328,
      height: 125, // was 150
      decoration: BoxDecoration(
        color: Color(0x3372b2ff),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xff72b2ff), // لون الحدود هنا
          width: 0.5, // سمك الحدود هنا
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(215, 15, 0, 10),
              child: Text(
                intro!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                first!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 25, 0),
              child: Text(
                second!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                third!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 40, 0),
              child: Text(
                forth!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(120, 0, 0, 5),
              child: Text(
                fifth!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 120, 5),
              child: Text(
                sixth!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//Events
class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('CP').get().asStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }

          List<Map<String, dynamic>> eventList =
              snapshot.data!.docs.map((document) {
            String eventName = document['Event'];
            String eventImageUrl = document['Image'];
            DateTime eventDate =
                DateFormat("yyyy-MM-dd").parse(document['DateTime']);
            String dn = document['Date'];

            return {
              'name': eventName,
              'imageUrl': eventImageUrl,
              'date': eventDate,
              'starName': dn,
            };
          }).toList();

          DateTime currentDate = DateTime.now();

          // Filter events that have the same date as the current date
          List<Map<String, dynamic>> currentEvents = eventList
              .where((eventMap) =>
                  (eventMap['name'] != "") &&
                  (eventMap['date'].day == currentDate.day) &&
                  (eventMap['date'].month == currentDate.month) &&
                  (eventMap['date'].year == currentDate.year))
              .toList();
          // Filter events that have a future date

          // Sort the current events by date
          currentEvents.sort((a, b) => a['date'].compareTo(b['date']));

          // Sort the future events by date

          // Combine the current and future events

          List<Widget> eventWidgets = currentEvents.map((eventMap) {
            String eventName = eventMap['name'];
            String eventImageUrl = eventMap['imageUrl'];
            DateTime eventDate = eventMap['date'];
            String dn = eventMap['starName'];

            Widget eventWidget = Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width: 350,
                height: 113,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(eventImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Text(
                        dn,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      right: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );

            return eventWidget;
          }).toList();

          return Stack(
            children: [
              Column(
                children: [
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: FractionalTranslation(
                  //     translation: Offset(-0.19, 0),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Text(
                  //         'الأحداث الفلكية',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 30,
                  //           fontWeight: FontWeight.bold,
                  //           fontFamily: 'Almarai',
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: eventWidgets.length,
                      itemBuilder: (context, index) {
                        return eventWidgets[index];
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
