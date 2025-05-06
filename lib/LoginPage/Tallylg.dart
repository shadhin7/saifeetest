import 'package:flutter/material.dart';
import 'package:saifeetest/Homep/Loading.dart';

class Loginbuton extends StatefulWidget {
  const Loginbuton({super.key});

  @override
  State<Loginbuton> createState() => _LoginbutonState();
}

class _LoginbutonState extends State<Loginbuton> {
  bool isLoading = false;
  Future<void> loading() async {
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(height: screenheight * 0.20),
        isLoading
            ? CircularProgressIndicator()
            : SizedBox(
              height: screenheight * 0.06,
              width: screenwidth * 0.85,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SplashTransitionScreen(),
                    ),
                  );
                },
                child: Text(
                  'Tally Cloud Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
      ],
    );
  }
}
