import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String currentUser;

  HomePage({required this.currentUser});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final url = Uri.parse('https://hoblist.com/api/movieList');
    final response = await http.post(
      url,
      body: {
        'category': 'movies',
        'language': 'kannada',
        'genre': 'all',
        'sort': 'voting',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        movies = data['result'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Logout the user
  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/auth'); // Redirect to auth page
  }

  void showCompanyInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Company Info'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Company: Geeksynergy Technologies Pvt Ltd'),
              Text('Address: Sanjayanagar, Bengaluru-56'),
              Text('Phone: XXXXXXXXX09'),
              Text('Email: XXXXXX@gmail.com'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movies',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey.shade900,
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: logOut,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String result) {
              if (result == 'Company Info') {
                showCompanyInfo();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'Company Info',
                child: Text('Company Info'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return ListTile(
                    title: Text(movie['title'],
                        style: TextStyle(color: Colors.grey.shade800)),
                    subtitle: Text('Votes: ${movie['voting']}',
                        style: TextStyle(color: Colors.grey.shade800)),
                  );
                },
              ),
      ),
    );
  }
}
