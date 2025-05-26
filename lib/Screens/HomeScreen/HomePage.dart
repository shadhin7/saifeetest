// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saifeetest/FireBase/Provider.dart';
import 'package:saifeetest/Screens/Loginscreen/LoginPage.dart';
import 'package:saifeetest/Utils/splashLoading.dart';
import 'package:saifeetest/detials/TallySingleUser.dart';
import 'package:saifeetest/detials/products.dart';
import 'package:saifeetest/services/GoogleLogin/authg.dart';
import 'package:url_launcher/url_launcher.dart';

class NewHomePage extends StatelessWidget {
  NewHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<UserProvider>(context).userName;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/Logo.png', height: 100, width: 100),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color.fromRGBO(34, 26, 101, 1)),
              child: ListTile(
                title: CircleAvatar(radius: 40),
                subtitle: Text(
                  '     Hola $userName',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              title: Text('Tally Cloud Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SplashTransitionScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Saifee computers'),
              onTap: () {
                launch(
                  'https://www.saifeecomputers.com/',
                  enableJavaScript: true,
                  forceWebView: true,
                );
              },
            ),
            ListTile(
              title: Text('Tally.ae'),
              onTap: () {
                launch(
                  'https://tally.ae/',
                  enableJavaScript: true,
                  forceWebView: true,
                );
              },
            ),
            TextButton(
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text("Confirm Logout"),
                        content: Text("Do you really want to sign out?"),
                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          TextButton(
                            child: Text("Sign Out"),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      ),
                );

                if (shouldLogout ?? false) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Center(child: CircularProgressIndicator()),
                  );

                  try {
                    await AuthService().signOut();
                    Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).clearUserName();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => Loginpage()),
                      (route) => false,
                    );
                  } catch (e) {
                    Navigator.pop(context); // close the loader
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Logout failed: ${e.toString()}")),
                    );
                  }
                }
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
        ),
      ),
      body: SingleChildScrollView(child: ProductsTally()),
    );
  }
}
