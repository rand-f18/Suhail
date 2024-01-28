import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:suhail_project/ForgetPassword.dart';
import 'package:suhail_project/HomePage.dart';
import 'package:suhail_project/Navbar.dart';
import 'package:suhail_project/SignIn.dart';
import 'package:suhail_project/SignUp.dart';
import 'SettingsPage.dart';

class changeProviderPassword extends StatelessWidget {
  const changeProviderPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "changePassword UI",
      home: changePasswordPage(),
    );
  }
}

class changePasswordPage extends StatefulWidget {
  @override
  _changePasswordPageState createState() => _changePasswordPageState();
}

class _changePasswordPageState extends State<changePasswordPage> {
  var CPassword = TextEditingController();
  var ACPassword = TextEditingController();
  var NPassword = TextEditingController();
  var RNPassword = TextEditingController();
  bool showPassword1 = true;
  bool showPassword2 = true;
  bool showPassword3 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(2.0),
            child: Container(
              color: Colors.white,
              height: 0.1,
            ),
          ),
          backgroundColor: Colors.black,
          elevation: 1,
          leading: TextButton(
            onPressed: () {
              //اذا ضغظ الغاء

              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //       builder: (BuildContext context) => EventPage()),
              //);
              Navigator.of(context).pop();
            },
            child: const Text('إلغاء'),
            style: TextButton.styleFrom(
              textStyle: TextStyle(fontFamily: 'Almarai'),
              primary: Colors.white, // text color
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (await check()) {
                  var user = await FirebaseAuth.instance.currentUser!;
                  final cred = await EmailAuthProvider.credential(
                      email: user.email!, password: CPassword.text);
                  await user
                      .reauthenticateWithCredential(cred)
                      .then((value) async {
                    await user
                        .updatePassword(NPassword.text.replaceAll(' ', ''))
                        .then((_) async {
                      // await FirebaseFirestore.instance
                      //   .collection('Users')
                      // .doc(FirebaseAuth.instance.currentUser!.uid)
                      //.update(
                      //  {'Password': NPassword.text.replaceAll(' ', '')});
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            content: Text(
                              'تم تغيير كلمة المرور',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Almarai'),
                            ),
                          );
                        },
                      );
                      // اذا ضغط حفظ
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => EventPage()));
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      print(error);
                    });
                  }).catchError((err) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text(
                            ' كلمة المرور الحالية خاطئة',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Almarai'),
                          ),
                        );
                      },
                    );
                  });
                }
              },
              child: const Text('حفظ'),
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  fontFamily: 'Almarai',
                ),
                primary: Color(0xFF6288FF), // text color
              ),
            ),
          ],
          title: const Positioned(
            left: 500,
            top: 400,
            child: SizedBox(
              width: 800,
              height: 24,
              child: Text(
                'تغيير كلمة المرور',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                const Center(
                  child: Stack(),
                ),
                buildTextField1(CPassword, "كلمة المرور الحالية ", true),
                GestureDetector(
                  child: const Text(
                    textAlign: TextAlign.start,
                    'هل نسيت كلمة المرور؟',
                    style: TextStyle(
                      color: Color(0xFF6288FF),
                      fontFamily: 'Almarai',
                    ),
                  ),
                  onTap: () async {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    User? user = auth.currentUser;

                    if (user != null) {
                      try {
                        await auth.sendPasswordResetEmail(email: user.email!);
                        print('Password reset email sent to ${user.email}');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: Text(
                                'أرسلنا لك بريدًا لإعادة ضبط كلمة المرور , نرجو منك التحقق من بريدك الالكتروني',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Almarai'),
                              ),
                            );
                          },
                        );
                      } catch (e) {
                        print('Error sending password reset email: $e');
                      }
                    } else {
                      print('No user is currently signed in.');
                    }
                  },
                ),
                buildTextField2(NPassword, "كلمة المرور الجديدة", true),
                buildTextField3(RNPassword, "تأكيد كلمة المرور", true),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField1(
      var contro, String labelText, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: TextField(
        controller: contro,
        maxLength: 25,
        style: TextStyle(color: Colors.white, fontFamily: 'Almarai'),
        textAlign: TextAlign.right,
        obscureText: isPasswordTextField ? showPassword1 : false,
        decoration: InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword1 = !showPassword1;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          labelStyle: const TextStyle(
            decorationColor: Colors.white,
            fontSize: 20,
            color: Colors.white,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  Widget buildTextField2(
      var contro, String labelText, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 35.0,
        top: 15,
      ),
      child: TextField(
        controller: contro,
        maxLength: 25,
        style: TextStyle(color: Colors.white, fontFamily: 'Almarai'),
        textAlign: TextAlign.right,
        obscureText: isPasswordTextField ? showPassword2 : false,
        decoration: InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword2 = !showPassword2;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          labelStyle: const TextStyle(
            decorationColor: Colors.white,
            fontSize: 20,
            color: Colors.white,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  Future<bool> check() async {
    if (CPassword.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              "الرجاء إخال كلمة المرور الحالية",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Almarai'),
            ),
          );
        },
      );
      return false;
    } else if (NPassword.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              "الرجاء إخال كلمة المرور الجديدة",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Almarai'),
            ),
          );
        },
      );
      return false;
    } else if (RNPassword.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              "الرجاء تأكيد كلمة المرور ",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Almarai'),
            ),
          );
        },
      );
      return false;
    } else if (NPassword.text != RNPassword.text) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              " كلمة المرور غير متطابقة",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Almarai'),
            ),
          );
        },
      );
      return false;
    } else if (!NPassword.text.contains(RegExp(r'[0-9]'))) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Almarai'),
            ),
          );
        },
      );
      return false;
    } else if (!NPassword.text.contains(RegExp(r'[a-z]'))) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              'يجب أن تحتوي كلمة المرور على حرف صغير وحرف كبير ورقم واحد على الأقل',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Almarai'),
            ),
          );
        },
      );
      return false;
    } else if (!NPassword.text.contains(RegExp(r'[A-Z]'))) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              'يجب أن تحتوي كلمة المرور على حرف كبير حرف صغير ورقم واحد على الأقل',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Almarai'),
            ),
          );
        },
      );
      return false;
    } else if (NPassword.text.length < 8) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              'الرجاء إدخال كلمة مرور أطول من 8 حروف',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Almarai'),
            ),
          );
        },
      );
      return false;
    } else {
      return true;
    }
  }

  Widget buildTextField3(
      var contro, String labelText, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: contro,
        maxLength: 25,
        style: TextStyle(color: Colors.white, fontFamily: 'Almarai'),
        textAlign: TextAlign.right,
        obscureText: isPasswordTextField ? showPassword3 : false,
        decoration: InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword3 = !showPassword3;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          labelStyle: const TextStyle(
            decorationColor: Colors.white,
            fontSize: 20,
            color: Colors.white,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
