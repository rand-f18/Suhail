import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:suhail_project/EventPage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:ui' as ui;
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(NewEvent());
}

class NewEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ar');
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ar'),
        const Locale('ar'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyForm(),
    );
  }
}

class SuhailField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? error;

  const SuhailField({
    required this.controller,
    required this.label,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    intl.DateFormat();
    initializeDateFormatting('ar');

    return Container(
      width: 328,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: controller,
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
            fillColor: Colors.black,
            filled: true,
          ),
        ),
      ),
    );
  }
}

class SuhailDateField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController con;
  final String label;
  final String? error;

  SuhailDateField({
    required this.controller,
    required this.label,
    this.error,
    required this.con,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 328,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: controller,
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
            labelText: label,
            labelStyle: const TextStyle(
              color: Color.fromARGB(255, 190, 190, 192),
              fontSize: 12,
            ),
            fillColor: Colors.black,
            filled: true,
            prefixIcon: Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
          ),
          onTap: () async {
            final DateTime? picked = await showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 300.0,
                  width: 400,
                  color: Color(0xff72b2ff),
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                          color: Colors.white, // Text color
                          fontFamily: 'Almarai',
                          fontSize: 13, // Font size
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: DateTime.now(),
                      minimumYear: 2000,
                      maximumYear: 2100,
                      onDateTimeChanged: (DateTime newDateTime) {
                        // Do something with the selected date
                        final arabicDateFormat =
                            intl.DateFormat('EEEE, d MMMM, yyyy', 'ar');
                        final EFormat = intl.DateFormat('yyyy-MM-dd', 'en');

                        final formattedDate =
                            '${arabicDateFormat.format(newDateTime)} ';
                        controller.text = formattedDate;
                        con.text = '${EFormat.format(newDateTime)} ';
                      },
                      backgroundColor: Color(0xff72b2ff),
                    ),
                  ),
                );
              },
            );

            if (picked != null) {
              controller.text = picked.toString();
              con.text = picked.toString();
            }
          },
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController notificationNameController =
      TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController con = TextEditingController();

  DateTime? selectedDate;
  String? imageFilePath;
  String? eventNameError;
  String? notificationNameError;
  String? selectedDateError;
  String? imageError;
  bool dialogVisible = false;
  bool? shareImage;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300.0,
          width: 400,
          color: Color(0xff72b2ff),
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Almarai',
                  fontSize: 13,
                ),
              ),
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumYear: 2000,
              maximumYear: 2100,
              onDateTimeChanged: (DateTime newDateTime) {
                final arabicDateFormat =
                    intl.DateFormat('EEEE, d MMMM, yyyy', 'ar');

                final formattedDate =
                    '${arabicDateFormat.format(newDateTime)} ';
                dateController.text = formattedDate;
              },
              backgroundColor: Color(0xff72b2ff),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedDateError = null;
        con.text = picked.toString();
      });
    }
  }

  Future<String?> _uploadImageToFirebaseStorage() async {
    if (imageFilePath == null || shareImage == false) {
      return null;
    }

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    firebase_storage.UploadTask uploadTask = ref.putFile(File(imageFilePath!));

    firebase_storage.TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() {});

    String? downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  void _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() async {
        imageFilePath = pickedFile.path;
        imageError = null;
        shareImage = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero, // إزالة الحشو الداخلي للمحتوى
              title: Text(
                "إرفاق صورة",
                style: TextStyle(
                  fontFamily: 'Almarai',
                  color: Color(0xFF1C1C1E),
                ),
                textAlign: TextAlign.center, // محاذاة النص في الوسط
              ),
              content: Container(
                // تحديد عرض الحاوية
                height: 250, // تحديد ارتفاع الحاوية
                child: Center(
                  child: Image.file(File(imageFilePath!)),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // محاذاة العناصر في اليمين واليسار
                  children: [
                    TextButton(
                      child: Text(
                        "إلغاء",
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          color: Color(0xFF1C1C1E),
                        ),
                      ),
                      onPressed: () {
                        if (imageFilePath != null && shareImage == true) {
                          Navigator.of(context).pop(true);
                        } else {
                          Navigator.of(context).pop(false);
                        }
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                         Color(0xff72b2ff),
                        ),
                      ),
                      onPressed: () {
                        // Pass the main dialog context to uploadImage
                        Navigator.of(context).pop(true);
                        _validateimage();
                      },
                      child: const Text(
                        "إرفاق الصورة",
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      });
    }
  }

  void _ivalidu() {
    if (imageFilePath != null && shareImage == true) {
      return Navigator.of(context).pop(true);
    } else {
      return Navigator.of(context).pop(false);
    }
  }

  void _validateimage() {
    if (imageFilePath != null || shareImage == true) {
      setState(() {
        shareImage = true;
        imageError = null;
      });
    }
  }

  void _validateForm() async {
    setState(() {
      // تحقق من صحة الحقول وتعيين رسائل الخطأ إذا لزم الأمر
      eventNameError = eventNameController.text.isEmpty ||
              eventNameController.text.replaceAll(" ", "").length > 20
          ? 'الرجاء إدخال اسم الحدث وأن لا يزيد عن 20 حرفًا'
          : null;

      notificationNameError = notificationNameController.text.isEmpty ||
              notificationNameController.text.replaceAll(" ", "").length > 30
          ? 'الرجاء إدخال وصف للحدث وأن لا يزيد عن 30 حرفًا'
          : null;

      selectedDateError =
          dateController.text.isEmpty ? 'الرجاء اختيار تاريخ' : null;

      if (imageFilePath == null || shareImage == false) {
        Text(textAlign: TextAlign.right, imageError = 'الرجاء اختيار صورة');
      } else {
        imageError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("IM/BCKSTARS.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 40, ),
                        child: Text(
                          "حدث جديد",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Almarai',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SuhailField(
                    controller: eventNameController,
                    label: 'اسم الحدث',
                    error: eventNameError,
                  ),
                  SizedBox(height: 16),
                  SuhailField(
                    controller: notificationNameController,
                    label: 'وصف الحدث',
                    error: notificationNameError,
                  ),
                  SizedBox(height: 16),
                  SuhailDateField(
                    controller: dateController,
                    label: "التاريخ",
                    error: selectedDateError,
                    con: con,
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 55,
                    width: 325,
                    decoration: BoxDecoration(
                      color: Colors.black, // لون الخلفية الرمادي
                      border: Border.all(
                        color:
                            imageError != null ? Colors.red : Color(0xff72b2ff),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                      onPressed: () => _selectImage(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible:
                                imageFilePath == null || shareImage == false,
                            child: Icon(
                              Icons
                                  .cloud_upload, // الأيقونة التي تحمل الشكل "تحميل"
                              color: Colors.white, // لون الأيقونة الأبيض
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 8),

                          // المسافة بين الأيقونة والنص
                          Text(
                            imageFilePath == null || shareImage == false
                                ? 'اختر صورة'
                                : 'تم اختيار الصورة',
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 12,
                              color: Color.fromARGB(255, 190, 190, 192),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (imageError != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 230),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          imageError!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontFamily: 'Almarai',
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      _validateForm();
                      if (eventNameError == null &&
                          notificationNameError == null &&
                          selectedDateError == null &&
                          imageError == null) {
                        String? imageUrl =
                            await _uploadImageToFirebaseStorage();
                        await FirebaseFirestore.instance.collection('CP').add({
                          'Event': eventNameController.text,
                          'Notification': notificationNameController.text,
                          'Date': dateController.text,
                          'Image': imageUrl,
                          'DateTime': con.text,
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Events(),
                          ),
                        );

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(
                                'تم إضافة الحدث بنجاح',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Almarai'),
                              ),
                            );
                          },
                        );
                      }
                    },
                    // ...بقية الشفرة
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff72b2ff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: Size(328, 52),
                    ),
                    child: const Text(
                      'إضافة',
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
