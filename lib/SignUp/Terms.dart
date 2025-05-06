import 'package:flutter/material.dart';
import 'package:saifeetest/LoginPage/LoginPage.dart';

class TermsandCondition extends StatefulWidget {
  const TermsandCondition({super.key});

  @override
  State<TermsandCondition> createState() => _TermsandConditionState();
}

class _TermsandConditionState extends State<TermsandCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Loginpage()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('hello')],
        ),
      ),
    );
  }
}
