import 'package:flutter/material.dart';
import 'package:saifeetest/Screens/Loginscreen/LoginForm.dart';
import 'package:saifeetest/Screens/signUpScreen/signupform.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40),
              Image.asset('assets/images/Logo.png', width: 150, height: 100),
              SizedBox(height: 20),
              Text(
                'Hola!!!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(height: 20),
              TabBar(
                labelStyle: TextStyle(fontSize: 20),

                indicatorColor: Color.fromRGBO(34, 26, 101, 1),
                labelColor: Color.fromRGBO(34, 26, 101, 1),
                unselectedLabelColor: Colors.grey,
                tabs: [Tab(text: 'Login'), Tab(text: 'Sign Up')],
              ),
              SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(child: LoginForm()),
                    Center(child: SignUpForm()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
