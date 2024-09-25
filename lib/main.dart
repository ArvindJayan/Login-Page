import 'package:assignment/pages/auth_page.dart';
import 'package:assignment/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth', // Set the initial route
      routes: {
        '/auth': (context) => AuthPage(),
        '/home': (context) => HomePage(currentUser: 'User'),
      },
    );
  }
}
