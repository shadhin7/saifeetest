import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Links extends StatelessWidget {
  const Links({super.key});

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    // double screenwidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TextButton(onPressed: () {}, child: Text('>Tally.ae')),
        // TextButton(onPressed: () {}, child: Text('>Saifee.com')),
        // TextButton(onPressed: () {}, child: Text('>Tally Programing')),
        SizedBox(height: screenheight * 0.02),
        RichText(
          text: TextSpan(
            text: '>Tally.ae',
            style: TextStyle(color: Colors.blue),
            recognizer:
                TapGestureRecognizer()
                  // ignore: deprecated_member_use
                  ..onTap = () {
                    // ignore: deprecated_member_use
                    launch(
                      'https://tally.ae/',
                      enableJavaScript: true,
                      forceWebView: true,
                    );
                  },
          ),
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(
            text: '>Saifee.com',
            style: TextStyle(color: Colors.blue),
            recognizer:
                TapGestureRecognizer()
                  // ignore: deprecated_member_use
                  ..onTap = () {
                    // ignore: deprecated_member_use
                    launch(
                      'https://www.saifeecomputers.com/',
                      enableJavaScript: true,
                      forceWebView: true,
                    );
                  },
          ),
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(
            text: '>Contact US',
            style: TextStyle(color: Colors.blue),
            recognizer:
                TapGestureRecognizer()
                  // ignore: deprecated_member_use
                  ..onTap = () {
                    // ignore: deprecated_member_use
                    launch(
                      'youtube.com',
                      enableJavaScript: true,
                      forceWebView: true,
                    );
                  },
          ),
        ),
      ],
    );
  }
}
