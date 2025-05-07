// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saifeetest/Screens/HomeScreen/HomePage.dart';
import 'package:saifeetest/Firebase/provider.dart';
import 'package:saifeetest/Firebase/reset.dart';
import 'package:saifeetest/Utils/Terms.dart';
import 'package:saifeetest/services/GoogleLogin/authg.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LogformState();
}

class _LogformState extends State<LoginForm> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isTermAccepted = false;
  bool _obscurePassword = true;
  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (!_isTermAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must accept the Terms and Conditions')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('login sucsess')));
    } on FirebaseAuthException catch (e) {
      // ignore: non_constant_identifier_names
      String Errmsg;

      if (e.code == 'user-not-found') {
        Errmsg = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        Errmsg = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        Errmsg = 'The email address is not valid.';
      } else if (e.code == 'user-disabled') {
        Errmsg = 'This user account has been disabled.';
      } else if (e.code == 'too-many-requests') {
        Errmsg = 'Too many login attempts. Try again later.';
      } else if (e.code == 'operation-not-allowed') {
        Errmsg = 'Email/password accounts are not enabled.';
      } else if (e.code == 'invalid-credential') {
        Errmsg = 'Invalid or expired login credentials. Try again.';
      } else {
        Errmsg = 'Login failed:${e.message}';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(Errmsg)));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child:
          isLoading
              ? CircularProgressIndicator(value: 30)
              : Column(
                children: [
                  // SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: screenwidth * .920,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(34, 26, 101, 1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.apple, size: 30),

                          Text(
                            'Login with Apple',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: screenwidth * .920,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(34, 26, 101, 1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final userCredential =
                            await _authService.signInWithGoogle();

                        if (userCredential != null) {
                          final displayName =
                              userCredential.user?.displayName ?? "User";

                          Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).setUserName(displayName);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Homepage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Google Login failed')),
                          );
                        }
                      },

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'Images/gicon.png',
                            height: 24,
                            width: 24,
                          ),
                          Text(
                            ' Login with Google',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'or continue with email',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: screenwidth * .920,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'you@example.com',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Color.fromRGBO(34, 26, 101, 1),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(34, 26, 101, 1),
                            width: 1,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      cursorColor: Color.fromRGBO(34, 26, 101, 1),
                    ),
                  ),

                  SizedBox(height: 15),
                  SizedBox(
                    height: 50,
                    width: screenwidth * .920,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,

                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'example@123',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(
                          Icons.key,
                          color: Color.fromRGBO(34, 26, 101, 1),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(34, 26, 101, 1),
                            width: 1,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                      ),
                      // keyboardType: TextInputType.,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      cursorColor: Color.fromRGBO(34, 26, 101, 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPass(),
                              ),
                            );
                          },
                          child: const Text("Forgot Password?"),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        activeColor: Color.fromRGBO(34, 26, 101, 1),

                        value: _isTermAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _isTermAccepted = value ?? false;
                          });
                        },
                        // controlAffinity: ListTileControlAffinity.leading,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'I agreed to the Terms and Conditions',
                          style: TextStyle(
                            color: Color.fromRGBO(34, 26, 101, 1),
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TermsandCondition(),
                                    ),
                                  );
                                },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    height: 45,
                    width: 180,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(34, 26, 101, 1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: loginUser,
                      child: Text('Login', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
    );
  }
}
