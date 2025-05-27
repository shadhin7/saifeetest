import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saifeetest/Utils/commominpit.dart';

import '../../FireBase/Provider.dart';
import '../../Screens/HomeScreen/HomePage.dart';
import '../../Utils/Terms.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool agreeToTerms = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  Future<void> _registerUser() async {
    setState(() => isLoading = true);

    if (!_formKey.currentState!.validate()) {
      setState(() => isLoading = false);
      return;
    }

    if (!agreeToTerms) {
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

      final user = FirebaseAuth.instance.currentUser;
      await user?.updateDisplayName(nameController.text.trim());
      await user?.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;

      Provider.of<UserProvider>(
        context,
        listen: false,
      ).setUserName(updatedUser?.displayName ?? nameController.text.trim());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration Successful')));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => NewHomePage()),
        (route) => false,
      );

      _clearFormFields();
    } on FirebaseAuthException catch (e) {
      String error = switch (e.code) {
        'email-already-in-use' => 'This email is already registered.',
        'invalid-email' => 'Invalid email address.',
        'operation-not-allowed' => 'Email/password accounts not enabled.',
        'weak-password' => 'Password is too weak.',
        _ => 'Registration failed. Please try again.',
      };

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _clearFormFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CommonInputField(
                  controller: nameController,
                  labelText: 'Name',
                  prefixIcon: Icons.person,
                  validator:
                      (value) => value!.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 16),
                CommonInputField(
                  controller: emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter your email';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                      return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CommonInputField(
                  controller: passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  obscureText: obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed:
                        () =>
                            setState(() => obscurePassword = !obscurePassword),
                  ),
                  validator:
                      (value) =>
                          value!.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                ),
                const SizedBox(height: 16),
                CommonInputField(
                  controller: confirmPasswordController,
                  labelText: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed:
                        () => setState(
                          () =>
                              obscureConfirmPassword = !obscureConfirmPassword,
                        ),
                  ),
                  validator:
                      (value) =>
                          value != passwordController.text
                              ? 'Passwords do not match'
                              : null,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Checkbox(
                      value: agreeToTerms,
                      onChanged:
                          (value) =>
                              setState(() => agreeToTerms = value ?? false),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TermsandCondition(),
                          ),
                        );
                      },
                      child: const Text(
                        'I agree to the Terms and Conditions',
                        style: TextStyle(
                          color: Color.fromRGBO(34, 26, 101, 1),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: screenWidth * 0.5,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(34, 26, 101, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
  }
}
