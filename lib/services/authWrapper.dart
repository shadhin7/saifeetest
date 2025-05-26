import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:saifeetest/Screens/HomeScreen/HomePage.dart';
import 'package:saifeetest/Screens/HomeScreen/HomePage.dart';
import 'package:saifeetest/Screens/Loginscreen/LoginPage.dart';
import 'package:saifeetest/FireBase/Provider.dart';
import 'package:saifeetest/Utils/splashscreen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;
          final displayName = user.displayName ?? 'User';
          Provider.of<UserProvider>(
            context,
            listen: false,
          ).setUserName(displayName);
          return NewHomePage();
        } else {
          return const Loginpage();
        }
      },
    );
  }
}
