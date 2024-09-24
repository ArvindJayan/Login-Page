import 'package:assignment/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanyInfoPage extends StatefulWidget {
  const CompanyInfoPage({super.key});

  @override
  State<CompanyInfoPage> createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends State<CompanyInfoPage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 1;

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey.shade900,
      title: Row(
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
                    fontWeight: _selectedIndex == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 18),
              ),
            ),
          ),
          // Company Info button
          TextButton(
            onPressed: () {},
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'lib/images/logo.png',
                height: 120,
              ),
              const SizedBox(height: 160), // Space between the image and text

              // Container for the text
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade800),
                    children: const [
                      TextSpan(
                        text: 'Company: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'Geeksynergy Technologies Pvt Ltd\n\n',
                      ),
                      TextSpan(
                        text: 'Address: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'Sanjayanagar, Bengaluru - 560066\n\n',
                      ),
                      TextSpan(
                        text: 'Phone: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'XXXXXXXX09\n\n',
                      ),
                      TextSpan(
                        text: 'Email: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'XXXXX@gmail.com\n',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
