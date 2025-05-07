import 'package:flutter/material.dart';

class Logos extends StatelessWidget {
  const Logos({super.key});

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            Image.asset(
              'Images/TallyPrime.png',
              height: screenheight * 0.10,
              width: screenwidth * 0.30,
            ),
            Image.asset(
              'Images/sage.png',
              height: screenheight * 0.10,
              width: screenwidth * 0.30,
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'Images/odoo.png',
              height: screenheight * 0.10,
              width: screenwidth * 0.30,
            ),
            Image.asset(
              'Images/zoho.png',
              height: screenheight * 0.10,
              width: screenwidth * 0.30,
            ),
          ],
        ),
      ],
    );
  }
}
