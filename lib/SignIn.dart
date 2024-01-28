import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:suhail_project/EventPage.dart';
import 'package:suhail_project/ForgetPassword.dart';
import 'package:suhail_project/HomePage.dart';
import 'package:suhail_project/Navbar.dart';
import 'package:suhail_project/SignUp.dart';
import 'package:suhail_project/main.dart';
import 'package:suhail_project/EventPage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool valid = false;
  String? mtoken = '';
  @override
  void dispose() {
    _EmailController.dispose();
    _PasswordController.dispose();
    super.dispose();
  }

Widget build(context) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
    ),
    home: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: double.infinity,
            height: 890,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("IM/BCKSTARS.png"), // تعديل: استبدل بمسار الصورة الخاصة بك
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 0, right: 10, bottom:40,left: 10 ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                  decoration: const BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, right: 0, bottom:20,left: 246 ),
                    child: Text(
                      "مرحبًا !",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  
                ),

                 Container(

decoration: const BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, right: 0,bottom:40,left: 150 ),
                    child: Text(
                     " نسعد بعودتك الى سُهَيْل",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontFamily: 'Almarai',
                        
                      ),
                    ),
                ),),
                  
                  
                        // تعديل: أضف هذا السطر لإضافة مسافة بين النص والحقول الأخرى
                  SuhailField(
                    _EmailController,
                    "البريد الإلكتروني",
                    emailError,
                    false,
                    () {
                      setState(() {
                        emailError = null;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  SuhailField(
                    _PasswordController,
                    "كلمة المرور",
                    passwordError,
                    true,
                    () {
                      setState(() {
                        passwordError = null;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 21),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'هل نسيت كلمة السر؟',
                            style: TextStyle(
                              color: Color(0xff72b2ff),
                              fontSize: 13,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      width: 328,
                      height: 57,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Color(0xff72b2ff),
                        onPressed: () async {
                          await check();
                          await Login();
                          getToken();
                          if (valid &&
                              _EmailController.text.replaceAll(" ", "") ==
                                  'suhailcontentprovider@gmail.com') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => Events(),
                              ),
                            );
                          } else if (valid) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => BottomNavBar(),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ليس لديك حساب؟',
                        style: TextStyle(
                          color: Color.fromARGB(255, 190, 190, 192),
                          fontFamily: 'Almarai',
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => SignUp(),
                            ),
                          );
                        },
                        child: const Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            color: Color(0xff72b2ff),
                            fontFamily: 'Almarai',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

  Future<void> check() async {
    if (_EmailController.text.replaceAll(" ", "").isEmpty &&
        _PasswordController.text.replaceAll(" ", "").isEmpty) {
      setState(() {
        emailError = 'الرجاء إدخال البريد الإلكتروني';
        passwordError = 'الرجاء إدخال كلمة المرور';
      });
    }
    if (_EmailController.text.replaceAll(" ", "").isEmpty) {
      setState(() {
        emailError = 'الرجاء إدخال البريد الإلكتروني';
      });
      return;
    } else if (!EmailValidator.validate(
        _EmailController.text.replaceAll(" ", ""))) {
      setState(() {
        emailError = 'البريد الإلكتروني غير صالح';
      });
      return;
    }

    if (_PasswordController.text.replaceAll(" ", "").isEmpty) {
      setState(() {
        passwordError = 'الرجاء إدخال كلمة المرور';
      });
      return;
    }
  }

  Future<void> Login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _EmailController.text.replaceAll(" ", ""),
        password: _PasswordController.text.replaceAll(" ", ""),
      );
      valid = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          emailError = "لا يوجد مستخدم مسجل بهذا البريد الالكتروني";
        });
        return;
      } else if (e.code == 'wrong-password') {
        setState(() {
          passwordError = "كلمة المرور غير صحيحة";
        });
        return;
      }
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print('tokem is $mtoken');
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String? username;
    try {
      DocumentSnapshot documentSnapshot = await firestore
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      username =
          documentSnapshot.exists ? documentSnapshot['Username'] : "null";
    } catch (e) {}
    await FirebaseFirestore.instance
        .collection('userTokens')
        .doc(username)
        .set({
      'token': token,
    });
  }
}

Container SuhailField(
  TextEditingController controller,
  String label,
  String? error,
  bool isPassword,
  FieldValueChangedCallback? onChanged,
) {
  return Container(
    width: 328,
    //height: 46,

    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Almarai',
        ),
        decoration: InputDecoration(
          errorText: error,
          errorStyle: TextStyle(fontFamily: 'Almarai'),
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Color(0xff72b2ff),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color:Color(0xff72b2ff),
              width: 1.0,
            ),
          ),
          label: Text(
            label,
            style: const TextStyle(
              color: Color.fromARGB(255, 190, 190, 192),
              fontSize: 12,
            ),
          ),
          fillColor: Colors.black,
          filled: true,
        ),
        onChanged: (value) {
          if (onChanged != null) {
            onChanged();
          }
        },
      ),
    ),
  );
}
/*TextFormField SuhailField(contrroler, String lable, error, bool ispass) {
  return TextFormField(
    textDirection: TextDirection.rtl,
    controller: contrroler,
    obscureText: ispass,
    enableSuggestions: !ispass,
    autocorrect: !ispass,
    style: const TextStyle(color: Colors.white),
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
          fontSize: 20,
        ),
      ),
      fillColor: const Color.fromARGB(255, 28, 28, 30),
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 99, 136, 255),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 99, 136, 255),
          width: 2.0,
        ),
      ),
    ),
  );
} */