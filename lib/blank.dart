import 'package:flutter/material.dart';

class blank extends StatelessWidget {
  const blank({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        'hello',
        style: TextStyle(color: Colors.black),
      )),
    );
  }
}
