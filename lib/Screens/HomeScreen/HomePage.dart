import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saifeetest/Firebase/provider.dart';
import 'package:saifeetest/Screens/Loginscreen/LoginPage.dart';
import 'package:saifeetest/services/GoogleLogin/authg.dart';
import 'package:saifeetest/websites/Links.dart';
import 'package:saifeetest/websites/Tallylg.dart';
import 'package:saifeetest/Utils/images.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<UserProvider>(context).userName;
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
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 40),
                  SizedBox(height: 10),
                  Text(
                    'Hello $userName',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
