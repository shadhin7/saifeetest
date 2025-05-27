// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saifeetest/FireBase/Provider.dart';
import 'package:saifeetest/FireBase/ResetEmail.dart';
import 'package:saifeetest/Screens/HomeScreen/HomePage.dart';
import 'package:saifeetest/Utils/Terms.dart';
import 'package:saifeetest/services/GoogleLogin/authg.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LogformState();
}

class _LogformState extends State<LoginForm> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool _isTermAccepted = false;
  bool _obscurePassword = true;

  String getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'invalid-credential':
        return 'Invalid or expired login credentials. Try again.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isTermAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must accept the Terms and Conditions'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).setUserName(user.displayName ?? user.email ?? 'User');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NewHomePage()),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful')));
    } on FirebaseAuthException catch (e) {
      final errorMsg = getFirebaseErrorMessage(e.code);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildAppleButton(screenWidth),
                const SizedBox(height: 20),
                _buildGoogleButton(screenWidth),
                const SizedBox(height: 20),
                const Text(
                  'or continue with email',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                _buildEmailField(screenWidth),
                const SizedBox(height: 15),
                _buildPasswordField(screenWidth),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ResetPass(),
                            ),
                          );
                        },
                        child: const Text("Forgot Password?"),
                      ),
                    ],
                  ),
                ),
                _buildTermsCheckbox(),
                const SizedBox(height: 30),
                SizedBox(
                  height: 45,
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(34, 26, 101, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: loginUser,
                    child: const Text('Login', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.5),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildAppleButton(double width) {
    return SizedBox(
      height: 50,
      width: width * .92,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(34, 26, 101, 1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apple, size: 30),
            SizedBox(width: 10),
            Text('Login with Apple', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleButton(double width) {
    return SizedBox(
      height: 50,
      width: width * .92,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(33, 26, 101, 1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          setState(() => isLoading = true);

          final userCredential = await _authService.signInWithGoogle();
          if (userCredential != null) {
            final displayName = userCredential.user?.displayName ?? "User";

            Provider.of<UserProvider>(
              context,
              listen: false,
            ).setUserName(displayName);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => NewHomePage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Google Login failed')),
            );
          }

          setState(() => isLoading = false);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/gicon.png', height: 24, width: 24),
            const SizedBox(width: 10),
            const Text('Login with Google', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(double width) {
    return SizedBox(
      height: 50,
      width: width * .92,
      child: TextFormField(
        controller: emailController,
        decoration: _inputDecoration(
          label: 'Email Address',
          hint: 'you@example.com',
          icon: Icons.email_outlined,
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Email required';
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(double width) {
    return SizedBox(
      height: 50,
      width: width * .92,
      child: TextFormField(
        controller: passwordController,
        obscureText: _obscurePassword,
        decoration: _inputDecoration(
          label: 'Password',
          hint: 'example@123',
          icon: Icons.key,
        ).copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed:
                () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Password required';
          return null;
        },
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          activeColor: const Color.fromRGBO(34, 26, 101, 1),
          value: _isTermAccepted,
          onChanged:
              (value) => setState(() => _isTermAccepted = value ?? false),
        ),
        RichText(
          text: TextSpan(
            text: 'I agree to the Terms and Conditions',
            style: const TextStyle(color: Color.fromRGBO(34, 26, 101, 1)),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TermsandCondition(),
                      ),
                    );
                  },
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color.fromRGBO(34, 26, 101, 1)),
      filled: true,
      fillColor: Colors.grey[100],
      labelStyle: TextStyle(
        color: Colors.grey[700],
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(color: Colors.grey[400]),
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
        borderSide: const BorderSide(
          color: Color.fromRGBO(34, 26, 101, 1),
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    );
  }
}
