import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:suhail_project/CongratulationPage.dart';
import 'package:suhail_project/firebase_options.dart';
import 'question.dart';
import 'quizBrain.dart';
import 'blank.dart';
import 'dart:async';
import 'fire_data.dart';
import 'data_model.dart';

QuizBrain quizBrain = QuizBrain();

int index = 0;

Color trueButtonColor = Colors.white;
Color falseButtonColor = Colors.white;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //model = await getData();
  // await getData();
  runApp(quizQuestions());
}

class quizQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("IM/BCKSTARS.png"), fit: BoxFit.cover)),
          child: QuizPage(),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
////////// time counter /////////////

  int _secondsElapsed = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }
  ////////////////////////////////////

  int correctAnswers = 0;
  int wrongAnswers = 0;

  List<Icon> ScoreKeeper = [];

  void CheckAnswer(String userPickedAnswer) {
    // bool? correctAnswer = quizBrain.getQuestionAnswer();
    String? correctAnswer = model?.answers[index];

    setState(() {
      if ((userPickedAnswer == correctAnswer) && index <= 2) {
        print('correct');
        ScoreKeeper.add(Icon(Icons.check, color: Colors.green));
        correctAnswers++;

        // المستخدم جاوب صح

        if (correctAnswer == 'T' && userPickedAnswer == 'T') {
          trueButtonColor = Colors.green;
          falseButtonColor = Colors.white;
        } else if (correctAnswer == 'F' && userPickedAnswer == 'F') {
          falseButtonColor = Colors.green;
          trueButtonColor = Colors.white;
        }

        // المستخدم جاوب غلط
      } else {
        print('wrong');
        ScoreKeeper.add(Icon(Icons.close, color: Colors.red));
        wrongAnswers++;

        if (correctAnswer == 'T' && userPickedAnswer == 'F') {
          trueButtonColor = Colors.white;
          falseButtonColor = Colors.red;
        } else if (correctAnswer == 'F' && userPickedAnswer == 'T') {
          falseButtonColor = Colors.white;
          trueButtonColor = Colors.red;
        }
      }

      quizBrain.nextQuestion(context);

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          trueButtonColor = Colors.white;
          falseButtonColor = Colors.white;
        });
      });
    });
  }

  int Qnum = 1;

//String? currentQuestion = quizBrain.getQuestionText();

  Widget build(BuildContext context) {
    // getData();

    int minutes = _secondsElapsed ~/ 60;
    int seconds = _secondsElapsed % 60;

    return Column(
      children: [
        Row(
          children: [
            // for timer and tracker

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 35, 0, 0),
              child: Icon(
                FlutterIcons.ios_hourglass_ion,
                size: 27,
                color: Colors.white,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 37, 0, 0),
              child: Text(
                '$minutes : $seconds',
                style: TextStyle(color: Colors.white, fontFamily: 'Almarai'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(200, 55, 30, 0),
              // tracker
              child: Row(children: ScoreKeeper),
            )
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(150, 100, 0, 0),
              child: Container(
                // question
                child: const Center(
                  child: Text(
                    'من  3',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Almarai',
                      color: Color(0xff72b2ff),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Container(
                // question
                child: Center(
                  child: Text(
                    ' $Qnum السؤال      ',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Almarai',
                      color: Color(0xff72b2ff),
                      //Color.fromRGBO(118, 110, 237, 0.591),
                      //Color.fromRGBO(60, 55, 200, 0.719),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 85, 0, 20),
          child: Container(
            // question
            child: Padding(
              padding: EdgeInsets.only(
                  right: 10), // تعيين القيمة المناسبة للـ padding هنا
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  model?.questions[index] ?? '',
                  style: const TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 20,
                      color: Color.fromARGB(219, 255, 255, 255),
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Container(
            width: 300,
            height: 50,
            child: Builder(
              builder: (context) => Container(
                color: trueButtonColor,
                child: ElevatedButton(
                  child: Text(
                    'صح',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(trueButtonColor),
                  ),
                  onPressed: () {
                    setState(() {
                      if (Qnum < 3) {
                        Qnum++;
                      }

                      if (index == 2) {
                        print('Secccoonnnddd $index');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CongratulationPage(
                                correctAnswers: correctAnswers),
                          ),
                        );
                        index = 0;
                      }
                      CheckAnswer('T');
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Container(
            width: 300,
            height: 50,
            child: Builder(
              builder: (context) => Container(
                color: falseButtonColor,
                child: ElevatedButton(
                  child: Text(
                    'خطأ',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(falseButtonColor),
                  ),
                  onPressed: () {
                    setState(() {
                      if (Qnum < 3) {
                        Qnum++;
                      }

                      if (index == 2) {
                        print('Secccoonnnddd $index');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CongratulationPage(
                                correctAnswers: correctAnswers),
                          ),
                        );
                        index = 0;
                      }
                      CheckAnswer('F');
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
