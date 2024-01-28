import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Drawer_menu.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlanteariumPage extends StatefulWidget {
  final String url;

  PlanteariumPage({required this.url});

  @override
  _PlanteariumState createState() => _PlanteariumState();
}

class _PlanteariumState extends State<PlanteariumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(),
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(60, 0, 22, 0),
            child: Text(
              textAlign: TextAlign.center,
              "القبة الفلكية",
              style: TextStyle(
                fontFamily: 'Almarai',
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
