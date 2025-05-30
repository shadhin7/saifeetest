import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:saifeetest/Screens/HomeScreen/HomePage.dart';
import 'package:saifeetest/Screens/HomeScreen/HomePage.dart';

class TallyLoginWebView extends StatefulWidget {
  const TallyLoginWebView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TallyLoginWebViewState createState() => _TallyLoginWebViewState();
}

class _TallyLoginWebViewState extends State<TallyLoginWebView> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(34, 26, 101, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NewHomePage()),
            );
          },
          icon: Icon(Icons.home, color: Colors.white),
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://cloud.saifeecomputers.com/login"),
        ),
        initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      ),
    );
  }
}
