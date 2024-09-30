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

  void showCreatorInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Creator Info'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: Arvind Jayan'),
              Text('Address: Bengaluru, India'),
              Text('Phone: +91 8589064433'),
              Text('Email: jayanarvind@gmail.com'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade900,
              ),
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
              if (result == 'Creator Info') {
                showCreatorInfo();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'Creator Info',
                child: Text('Creator Info'),
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

                  // Print each movie object to the console
                  print("Movie Data: $movie");

                  // Check if 'starring' exists and is not null or empty
                  String starring = movie['starring'] != null &&
                          movie['starring'].toString().isNotEmpty
                      ? movie['starring']
                      : 'N/A';

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Movie Poster
                            Image.network(
                              movie['poster'],
                              height: 100,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            // Movie details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Genre: ${movie['genre']}',
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Director: ${movie['director']}',
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Starring: $starring',
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${movie['duration'] != null ? '${movie['duration']} Mins' : 'N/A'} | ${movie['language']}',
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${movie['pageViews']} views | Voted by ${movie['voting']} People',
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle Watch Trailer
                                    },
                                    child: const Text('Watch Trailer'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.grey.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Voting section
                            Column(
                              children: [
                                const Icon(Icons.arrow_drop_up, size: 30),
                                Text(
                                  '${movie['voting']}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const Text('Votes'),
                                const Icon(Icons.arrow_drop_down, size: 30),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
