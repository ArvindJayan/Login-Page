import 'package:assignment/components/button.dart';
import 'package:assignment/components/square_tile.dart';
import 'package:assignment/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  // Sign up
  void signUserUp() async {
    // Loading dialog box
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: Colors.grey.shade900),
          );
        });

    // Try creating a user
    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Passwords don\'t match.'),
          );
        },
      );
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'invalid-email' || e.code == 'invalid-credential') {
        wrongLoginMessage();
      }
    }
  }

  // Wrong login credentials dialog
  void wrongLoginMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Invalid Credentials.'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          // SingleChildScrollView
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 69),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 40),

                // Welcome message
                Text(
                  'Welcome! Let\'s create a new account!',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),

                // Email text field
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 15),

                // Password text field
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                // Confirm password text field
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),

                // Sign up button
                MyButton(
                  onTap: signUserUp,
                  text: 'Sign up',
                ),
                const SizedBox(height: 60),

                // Or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Sign in with Google
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      imagePath: 'lib/images/google.png',
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                            color: Color.fromARGB(255, 33, 121, 243),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
