import 'dart:async';
import 'package:flutter/material.dart';
import 'package:saifeetest/websites/webview.dart';

class SplashTransitionScreen extends StatefulWidget {
  const SplashTransitionScreen({super.key});

  @override
  State<SplashTransitionScreen> createState() => _SplashTransitionScreenState();
}

class _SplashTransitionScreenState extends State<SplashTransitionScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TallyLoginWebView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(), Text('Please wait..')],
        ),
      ),
    );
  }
}
