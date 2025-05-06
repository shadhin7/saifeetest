import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:saifeetest/Homep/HomePage.dart';
import 'package:saifeetest/Firebase/provider.dart';
import 'package:saifeetest/SignUp/Terms.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> registerUser() async {
    setState(() => isLoading = true);

    if (!_formKey.currentState!.validate()) {
      setState(() => isLoading = false);
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must agree to the Terms and Conditions'),
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseAuth.instance.currentUser?.updateDisplayName(
        nameController.text.trim(),
      );

      Provider.of<UserProvider>(
        context,
        listen: false,
      ).setName(nameController.text.trim());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration Successful')));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
        (route) => false,
      );

      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts not enabled.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak.';
          break;
        default:
          errorMessage = 'Registration failed. Please try again.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Name Field
                SizedBox(
                  height: 55,
                  width: screenwidth * 0.95,
                  child: TextFormField(
                    controller: nameController,
                    validator:
                        (value) => value!.isEmpty ? 'Enter your name' : null,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: const Icon(
                        Icons.person_2_outlined,
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
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(34, 26, 101, 1),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Email Field
                SizedBox(
                  height: 55,
                  width: screenwidth * 0.95,
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter your email';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                        return 'Invalid email';
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(
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
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(34, 26, 101, 1),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Field
                SizedBox(
                  height: 55,
                  width: screenwidth * 0.95,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    validator:
                        (value) =>
                            value!.length < 6
                                ? 'Password must be at least 6 characters'
                                : null,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color.fromRGBO(34, 26, 101, 1),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
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
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(34, 26, 101, 1),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm Password Field
                SizedBox(
                  height: 55,
                  width: screenwidth * 0.95,
                  child: TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    validator:
                        (value) =>
                            value != passwordController.text
                                ? 'Passwords do not match'
                                : null,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(
                        Icons.lock_outlined,
                        color: Color.fromRGBO(34, 26, 101, 1),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
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
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(34, 26, 101, 1),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Terms & Conditions
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: const Color.fromRGBO(34, 26, 101, 1),
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'I agree to the Terms and Conditions',
                        style: const TextStyle(
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
                const SizedBox(height: 30),

                // Sign Up Button
                SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(34, 26, 101, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: registerUser,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
  }
}
