/*import 'package:suhail_project/CongratulationPage.dart';

import 'question.dart ';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'Quiz.dart';
import 'blank.dart';

class QuizBrain {
  int questionNumber = 0;

  List<Question> questionBank = [
    Question(q: 'يمكن للضوء الهروب من الثقوب السوداء', a: false),
    Question(q: 'يمكن للمجرات الاندماج مع بعضها البعض', a: true),
    Question(q: 'القمر لايدور حول محوره الخاص', a: true),
  ];

  void nextQuestion(context) {
    if (questionNumber == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CongratulationPage(),
        ),
      );
    }
  }

  String? getQuestionText() {
    if (questionNumber < 3) {
      print('text $questionNumber');
      return questionBank[questionNumber].questionText;
    }
    return '';
  }

  bool? getQuestionAnswer() {
    if (questionNumber <= 3) {
      print(' QN ${questionNumber - 1}');
      print(' answer ${questionBank[questionNumber - 1].questionAnswer}');
      return questionBank[questionNumber - 1].questionAnswer;
    }
    print('${questionNumber}');
    print('${questionBank[questionNumber - 1].questionAnswer}');
    return null;
  }

  int getQuestionNumber() {
    return questionNumber;
  }
}



// code before changing

 
//   int _questionNumber = 0;

// List<Question> _questionBank = [
//  Question(q: 'q1', a: true),
//  Question(q: 'q2', a: true),
//  Question(q: 'q3', a: true),
// ];

// void nextQuestion(context){
//   if (_questionNumber == 3){
//      Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(),),);
//   }
//   if (_questionNumber < _questionBank.length){
//    // setState(() {
//        _questionNumber++;
//          // });
    
//   }
// }


// String? getQuestionText (){
// return _questionBank[_questionNumber].questionText;
// }

// bool? getQuestionAnswer(){
//   return _questionBank[_questionNumber].questionAnswer;
// }

// int getQuestionNumber(){
//   return _questionNumber;
// }



//   if (questionNumber == 2){
//      Navigator.push(context, MaterialPageRoute(builder: (context) => blank(),),);
//   }
//   if (questionNumber < _questionBank.length){
//    //setState(() {
//       questionNumber++;
//        //  });
    
//  }*/
import 'package:suhail_project/quizQuestions.dart';

import 'question.dart';

class QuizBrain {
  int questionNumber = 0;

  List<Question> questionBank = [
    Question(q: 'يمكن للضوء الهروب من الثقوب السوداء', a: false),
    Question(q: 'يمكن للمجرات الاندماج مع بعضها البعض', a: true),
    Question(q: 'القمر لايدور حول محوره الخاص', a: true),
  ];

  void nextQuestion(context) {
    if (index < 3 && index != 2) {
      print('Fiiiiiiirssssttt $index');
      index++;
    }
    //  if (index == 2) {
    //  //print('Fiiiiiiirssssttt $index');
    //index = 0;
    //}

    // if (index == 2) {
    //   print('Secccoonnnddd $index');
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => blank(),
    //     ),
    //   );
    // }
  }

// String? getQuestionText (){

// if (questionNumber < 3) {
//  // print('text $questionNumber');
//       return questionBank[questionNumber].questionText;
//     }
//     return '';
// }

// bool? getQuestionAnswer(){

//   if (questionNumber <= 3) {
//    // print(' QN ${questionNumber-1}');
//     //print(' answer ${questionBank[questionNumber-1].questionAnswer}');
//       return questionBank[questionNumber-1].questionAnswer;
//     }
//    // print('${questionNumber}');
//    // print('${questionBank[questionNumber-1].questionAnswer}');
//     return null;
// }

// int getQuestionNumber(){
//   return questionNumber;
// }
}
