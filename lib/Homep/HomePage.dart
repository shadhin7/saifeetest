import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saifeetest/Firebase/provider.dart';
import 'package:saifeetest/LoginPage/LoginPage.dart';
import 'package:saifeetest/websites/Links.dart';
import 'package:saifeetest/LoginPage/Tallylg.dart';
import 'package:saifeetest/assets/images.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<UserProvider>(context).name;
    // double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(
        width: 250,

        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color.fromRGBO(34, 26, 101, 1)),
              child: Text('Drawer Header'),
            ),
            ListTile(title: const Text('Item 1'), onTap: () {}),
            ListTile(title: const Text('Item 2'), onTap: () {}),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,

        actions: [
          TextButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Loginpage()),
              );
            },
            child: Text(
              'SignOut',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(34, 26, 101, 1),
              ),
            ),
          ),
        ],
        title: Image.asset('Images/Logo.png', height: 100, width: 100),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenheight * 0.09),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome $userName',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          SizedBox(height: screenheight * 0.05),
          Logos(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Loginbuton()],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [Links()]),
        ],
      ),
    );
  }
}
