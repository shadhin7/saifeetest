import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saifeetest/Homep/HomePage.dart';
import 'package:saifeetest/Firebase/provider.dart';
import 'package:saifeetest/LoginPage/LoginPage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(create: (_) => UserProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final firebaseUser = snapshot.data!;
            final displayName = firebaseUser.displayName ?? 'User';
            Provider.of<UserProvider>(
              context,
              listen: false,
            ).setName(displayName);
            return Homepage();
          } else {
            return Loginpage();
          }
        },
      ),
    );
  }
}
