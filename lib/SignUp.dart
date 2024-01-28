import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suhail_project/HomePage.dart';
import 'package:suhail_project/Navbar.dart';
import 'SignIn.dart';
import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  TextEditingController _FnameController = TextEditingController();
  TextEditingController _LnameController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _UsernameController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();
  TextEditingController _CpasswordController = TextEditingController();

  String? fnameError;
  String? lnameError;
  String? emailError;
  String? usernameError;
  String? passwordError;
  String? cpasswordError;

  bool valid = false;

  @override
  void dispose() {
    _FnameController.dispose();
    _LnameController.dispose();
    _EmailController.dispose();
    _UsernameController.dispose();
    _PasswordController.dispose();
    _CpasswordController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
    ),
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("IM/BCKSTARS.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60, right: 0, bottom:30,left: 246 ),
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
                    padding: const EdgeInsets.only(top: 0, right: 0,bottom:10,left: 125 ),
                    child: Text(
                     "نسعد بإنضمامك الى سُهَيْل ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontFamily: 'Almarai',
                        
                      ),
                    ),
                ),),
                Container(

decoration: const BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, right: 0,bottom:40,left: 50),
                    child: Text(
                      '  املأ الحقول التالية  للبدء في رحلتك الفلكية',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontFamily: 'Almarai',
                        
                      ),
                    ),
                ),),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SuhailField(
                          _FnameController,
                          "الاسم الأول",
                          fnameError,
                          false,
                          () {
                            setState(() {
                              fnameError = null;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        SuhailField(
                          _LnameController,
                          "الاسم الأخير",
                          lnameError,
                          false,
                          () {
                            setState(() {
                              lnameError = null;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        SuhailField(
                          _UsernameController,
                          "اسم المستخدم",
                          usernameError,
                          false,
                          () {
                            setState(() {
                              usernameError = null;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        SuhailField(
                          _CpasswordController,
                          "تأكيد كلمة المرور",
                          cpasswordError,
                          true,
                          () {
                            setState(() {
                              cpasswordError = null;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 328,
                          height: 57,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Color(0xff72b2ff),
                            onPressed: () async {
                              await check();
                              if (fnameError == null &&
                                  lnameError == null &&
                                  emailError == null &&
                                  usernameError == null &&
                                  passwordError == null &&
                                  cpasswordError == null) {
                                await newUser();
                              }
                              if (valid) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BottomNavBar(),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'تسجيل',
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لديك حساب بالفعل؟',
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
                                    builder: (BuildContext context) =>
                                        const SignIn(),
                                  ),
                                );
                              },
                              child: const Text(
                                'تسجيل الدخول',
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
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  Future<bool> isUsernameTaken(String username) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      QuerySnapshot querySnapshot =
          await users.where('Username', isEqualTo: username).get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors that might occur during the process
      print('Error checking username availability: $e');
      return true; // Assume error, so username is considered taken
    }
  }

  Future<bool> isEmailTaken(String e) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      QuerySnapshot querySnapshot =
          await users.where('Email', isEqualTo: e).get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors that might occur during the process
      print('Error checking username availability: $e');
      return true; // Assume error, so username is considered taken
    }
  }

  Future<void> check() async {
    if (_FnameController.text.isEmpty &&
        _LnameController.text.isEmpty &&
        _EmailController.text.isEmpty &&
        _UsernameController.text.isEmpty &&
        _PasswordController.text.isEmpty &&
        _CpasswordController.text.isEmpty) {
      setState(() {
        fnameError = 'الرجاء إدخال الاسم الأول';
        lnameError = 'الرجاء إدخال الاسم الأخير';
        emailError = 'الرجاء إدخال البريد الإلكتروني';
        usernameError = 'الرجاء إدخال اسم المستخدم';
        usernameError = 'الرجاء إدخال اسم المستخدم';
        passwordError = 'الرجاء إدخال كلمة المرور';
        cpasswordError = 'الرجاء تأكيد كلمة المرور';
      });
    }

    if (_FnameController.text.replaceAll(" ", "").isEmpty) {
      setState(() {
        fnameError = 'الرجاء إدخال الاسم الأول';
      });
      return;
    }

    if (_FnameController.text.replaceAll(" ", "").length > 25) {
      setState(() {
        fnameError = 'الرجاء إدخال اقل من 25 حرف';
      });
      return;
    }

    if (_LnameController.text.replaceAll(" ", "").isEmpty) {
      setState(() {
        lnameError = 'الرجاء إدخال الاسم الأخير';
      });
      return;
    }

    if (_LnameController.text.replaceAll(" ", "").length > 25) {
      setState(() {
        lnameError = 'الرجاء إدخال اقل من 25 حرف';
      });
      return;
    }

    if (_EmailController.text.replaceAll(" ", "").isEmpty) {
      setState(() {
        emailError = 'الرجاء إدخال البريد الإلكتروني';
      });
      return;
    }

    if (!EmailValidator.validate(_EmailController.text.replaceAll(" ", ""))) {
      setState(() {
        emailError = 'البريد الإلكتروني غير صالح';
      });
      return;
    }

    if (await isEmailTaken(_EmailController.text.replaceAll(" ", ""))) {
      setState(() {
        emailError = 'البريد الالكتروني مسجل بالفعل';
      });
    }

    if (_UsernameController.text.replaceAll(" ", "").isEmpty) {
      setState(() {
        usernameError = 'الرجاء إدخال اسم المستخدم';
      });
      return;
    }
    if (_UsernameController.text.replaceAll(" ", "").length > 25) {
      setState(() {
        usernameError = 'الرجاء إدخال اقل من 25 حرف';
      });
      return;
    }

    if (await isUsernameTaken(_UsernameController.text.replaceAll(" ", ""))) {
      setState(() {
        usernameError = 'اسم المستخدم موجود بالفعل، الرجاء اختيار اسم اخر';
      });
    }

    if (_PasswordController.text.replaceAll(" ", "").isEmpty) {
      setState(() {
        passwordError = 'الرجاء إدخال كلمة المرور';
      });
      return;
    }

    if (_PasswordController.text.replaceAll(" ", "").length < 8) {
      setState(() {
        passwordError = 'الرجاء إدخال كلمة مرور أطول من 8 حروف';
      });
      return;
    }

    if (_PasswordController.text.replaceAll(" ", "").length > 20) {
      setState(() {
        passwordError = 'الرجاء إدخال كلمة مرور أقل من 20 حرف';
      });
      return;
    }

    if (!_PasswordController.text.contains(RegExp(r'[A-Z]'))) {
      setState(() {
        passwordError =
            'يجب أن تحتوي كلمة المرور على أحرف كبيرة وصغيرة وأرقام ';
      });
      return;
    }

    if (!_PasswordController.text.contains(RegExp(r'[a-z]'))) {
      setState(() {
        passwordError = 'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل';
      });
      return;
    }

    if (!_PasswordController.text.contains(RegExp(r'[0-9]'))) {
      setState(() {
        passwordError = 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
      });
      return;
    }

    if (_CpasswordController.text.replaceAll(" ", "").isEmpty) {
      setState(() {
        cpasswordError = 'الرجاء تأكيد كلمة المرور';
      });
      return;
    } else if (_PasswordController.text != _CpasswordController.text) {
      setState(() {
        cpasswordError = 'كلمة المرور غير مطابقة';
      });
      return;
    }
  }

  Future<void> newUser() async {
    try {
      UserCredential resultaccount =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _EmailController.text.replaceAll(" ", ""),
        password: _PasswordController.text.replaceAll(" ", ""),
      );
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(resultaccount.user!.uid)
          .set({
        "Email": _EmailController.text.replaceAll(" ", ""),
        "First name": _FnameController.text.replaceAll(" ", ""),
        "Last name": _LnameController.text.replaceAll(" ", ""),
        //"Password": _PasswordController.text.trim(), no need to store it
        "Username": _UsernameController.text.replaceAll(" ", ""),
      });
      valid = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          passwordError = "كلمة المرور ضعيفة";
        });
        return;
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          emailError = "البريد الإلكتروني مسجل مسبقا";
        });
        return;
      }
    } catch (e) {
      print(e);
    }
  }
}

typedef void FieldValueChangedCallback();

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
          errorStyle: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 10,
          ),
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
              color: Color(0xff72b2ff),
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
          fillColor: Color.fromARGB(255, 0, 0, 0),
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
