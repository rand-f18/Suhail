import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suhail_project/SignIn.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKeyIn = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  String? emailError;

  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> check() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        emailError = 'الرجاء إدخال البريد الإلكتروني';
      });
      return;
    } else if (!EmailValidator.validate(_emailController.text)) {
      setState(() {
        emailError = 'البريد الإلكتروني غير صالح';
      });
      return;
    }
  }

  bool isCorrect = false;

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      isCorrect = true;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        setState(() {
          emailError = "لا يوجد مستخدم مسجل بهذا البريد الالكتروني";
        });
        return;
      }

      //  if (error.message.toString() == "There is no user record corresrandponding to this identifier. The user may have been deleted.") {
      //   emailError = "هذا البريد الإلكتروني غير موجود";
      //   return;
      //  }

      //String emailError = "حدث خطأ ما حاول مجددًا في وقت لاحق";

      // switch (error.message.toString()) {
      // // case "Unable to establish connection on channel.":
      // //   emailError = "قم بتعبئة الحقل من فضلك";
      // //   break;
      // case "There is no user record corresrandponding to this identifier. The user may have been deleted.":
      //   emailError = "لا يوجد مستخدم مسجل بهذا البريد الالكتروني";
      //   break;

      //   default:
      //   emailError = "حدث خطأ ما حاول مجددًا في وقت لاحق";
      //   break;

      // case "The email address is badly formatted.":
      //   emailError = "تأكد من كتابة عنوان بريدك الإلكتروني بشكل صحيح";
      //   break;

      // }

      print(emailError);

      // showDialog(context: context, builder: (context){
      //   return AlertDialog(
      //     content: Text(emailError),
      //   );
      // },
      // );
    }
  }

@override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
    ),
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("IM/BCKSTARS.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 420,
              child: Container(
                decoration: const BoxDecoration(
                  
                ),
                child: const SizedBox(
                  width: 247,
                  height: 40,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0, right: 47),
                    child: Text(
                      'إعادة تعيين كلمة المرور',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(top: 37, right: 18, left: 14, bottom: 10),
              key: _formKeyIn,
              child: Column(
                children: <Widget>[
                  SuhailField(
                    _emailController,
                    "عنوان البريد الإلكتروني",
                    emailError,
                    false,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 312,
                    height: 24,
                    child: const Text(
                      'ستصلك رسالة على بريدك الالكتروني لتعيد ضبط كلمة المرور',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: 328,
                    height: 57,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color:  Color(0xff72b2ff),
                      onPressed: () {
                        check();
                        passwordReset();
                        if (isCorrect == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignIn(),
                            ),
                          );
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  'أرسلنا لك بريدًا لإعادة ضبط كلمة المرور , نرجو منك التحقق من بريدك الالكتروني',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Almarai'),
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: const Text(
                        'إرسال',
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Almarai',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  Container SuhailField(contrroler, String lable, error, bool ispass) {
    return Container(
      width: 328,
      //height: 46,

      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: contrroler,
          obscureText: ispass,
          enableSuggestions: !ispass,
          autocorrect: !ispass,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Almarai',
          ),
          decoration: InputDecoration(
            errorText: error,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            label: Text(
              lable,
              style: const TextStyle(
                color: Color.fromARGB(255, 190, 190, 192),
                fontSize: 12,
              ),
            ),
            fillColor: Colors.black,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color:  Color(0xff72b2ff),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Color(0xff72b2ff),
                width: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
