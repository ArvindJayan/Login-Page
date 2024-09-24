import 'package:assignment/pages/homepage.dart';
import 'package:assignment/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Checking if the user is logged in or not
          if (snapshot.hasData) {
            return Homepage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
