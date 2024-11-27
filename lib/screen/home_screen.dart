import 'package:book_uploading/book_list_by_genre/book_screen.dart';
import 'package:book_uploading/book_recommendation/book_recommendation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[100]!, // Dark blue
              Colors.blue[900]!, // Light blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/books.jpg"),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookRecommendationScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 182, 193), // Light pink color
                  minimumSize: const Size(255, 55),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Less curve
                  ),
                ),
                child: const Text("Get Book Recommendation",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 182, 193), // Light pink color
                  minimumSize: const Size(255, 55),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Less curve
                  ),
                ),
                child: const Text("Browse By Genre", style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              const SizedBox(height: 50),
              const Text(
                "I do believe something very magical can happen when you read a good book.",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 167, 189),
        title: const Text(
          "Book Recommendation App",
          style: TextStyle(fontWeight: FontWeight.bold, ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
