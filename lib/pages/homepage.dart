import 'package:assignment/pages/company_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0; // 0 for Home and 1 for Company Info

  // Sign out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // Navigate to different pages
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Navigate to Home
    } else if (index == 1) {
      // Navigate to Company Info
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CompanyInfoPage()),
      );
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey.shade900,
      title: Container(
        child: Row(
          children: [
            // Home button
            TextButton(
              onPressed: () => _onItemTapped(0),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 30.0),
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: _selectedIndex == 0 ? Colors.blue : Colors.white,
                    fontSize: 18,
                    fontWeight: _selectedIndex == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
            // Company Info button
            TextButton(
              onPressed: () => _onItemTapped(1),
              child: Text(
                'Company Info',
                style: TextStyle(
                  color: _selectedIndex == 1 ? Colors.blue : Colors.white,
                  fontSize: 18,
                  fontWeight:
                      _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Log out button
        IconButton(
          onPressed: signUserOut,
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: buildAppBar(),
      body: const Center(
        child: Text(
          "Logged in.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
