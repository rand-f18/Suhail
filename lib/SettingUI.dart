import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suhail_project/HomePage.dart';
import 'package:suhail_project/Navbar.dart';
import 'SettingsPage.dart';

class SettingsUI extends StatelessWidget {
  const SettingsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? Email = '';
  String? FirstName = '';
  String? LastName = '';
  String? Password = '';
  String? Username = '';
  var FName = TextEditingController();
  var LName = TextEditingController();
  var email = TextEditingController();
  var UName = TextEditingController();

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
          Email = Snapshot.data()!["Email"];
          FirstName = Snapshot.data()!["First name"];
          LastName = Snapshot.data()!["Last name"];
          Password = Snapshot.data()!["Password"];
          Username = Snapshot.data()!["Username"];
        });
      }
    });
    _getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    _getDataFromDatabase();

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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
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
                try {
                  WidgetsFlutterBinding.ensureInitialized();
                  await Firebase.initializeApp();

                  if (FName.value.text.isNotEmpty) {
                    if (checkNotEmpty(FName.text)) {
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update(
                              {'First name': FName.text.replaceAll(' ', '')});
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                              " الاسم الأول غير صالح ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Almarai'),
                            ),
                          );
                        },
                      );
                      return;
                    }
                  }
                  if (LName.value.text.isNotEmpty) {
                    if (checkNotEmpty(LName.text)) {
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update(
                              {'Last name': LName.text.replaceAll(' ', '')});
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                              " الاسم الأخير غير صالح ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Almarai'),
                            ),
                          );
                        },
                      );
                      return;
                    }
                  }
                  if (UName.value.text.isNotEmpty) {
                    if (await isUsernameTaken(UName.text.replaceAll(' ', ''))) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                              "اسم المستخدم موجود بالفعل، الرجاء اختيار اسم اخر",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Almarai'),
                            ),
                          );
                        },
                      );
                      return;
                    } else {
                      if (checkNotEmpty(UName.text)) {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update(
                                {'Username': UName.text.replaceAll(' ', '')});
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(
                                "اسم المستخدم غير صالح",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Almarai'),
                              ),
                            );
                          },
                        );
                        return;
                      }
                    }
                  }
                  if (email.value.text.isNotEmpty) {
                    if (EmailValidator.validate(email.text)) {
                      if (email.text ==
                          FirebaseAuth.instance.currentUser?.email) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(
                                'الرجاء أدخال بريد إلكتورني جديد',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Almarai'),
                              ),
                            );
                          },
                        );
                        return;
                      } else {
                        checkIfEmailInUse(email.text);
                        await FirebaseAuth.instance.currentUser!
                            .updateEmail(email.text);
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({'Email': email.text.replaceAll(' ', '')});
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                              ' البريد الإكتروني غير صالح',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Almarai'),
                            ),
                          );
                        },
                      );
                      return;
                    }
                  }
                  if (!mounted) return;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text(
                          'تم تحديث المعلومات',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Almarai'),
                        ),
                      );
                    },
                  );
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => BottomNavBar()));
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('حفظ'),
              style: TextButton.styleFrom(
                textStyle: TextStyle(fontFamily: 'Almarai'),
                primary: Colors.white, // text color
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
                'تحديث المعلومات الشخصية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(children: [
              const SizedBox(
                height: 15,
              ),
              buildTextField(FName, "الاسم الأول", FirstName!),
              buildTextField(LName, "الاسم الأخير", LastName!),
              buildTextField(UName, "اسم المستخدم", Username!),
              buildTextField(email, "البريد الإلكتروني", Email!),
              const SizedBox(
                height: 35,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future checkIfEmailInUse(String emailAddress) async {
    try {
      final list =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);
      if (list.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "البريد الإلكتروني مسجل مُسبقًا",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Almarai'),
              ),
            );
          },
        );
      }
    } catch (error) {
      return true;
    }
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

  checkNotEmpty(String name) {
    name = name.replaceAll(' ', '');
    if (name.isNotEmpty) {
      return true;
    } else
      return false;
  }

  Widget buildTextField(var contro, String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        maxLength: 25,
        controller: contro,
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white)),
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 19,
            ),
            contentPadding:
                const EdgeInsets.only(bottom: 3, right: 10, left: 5),
            labelText: labelText,
            labelStyle: const TextStyle(
              fontFamily: 'Almarai',
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decorationColor: Colors.white,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontFamily: 'Almarai',
              color: Colors.white,
            )),
      ),
    );
  }
}
