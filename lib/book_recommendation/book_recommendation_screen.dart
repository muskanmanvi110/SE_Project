import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookRecommendationScreen extends StatefulWidget {
  const BookRecommendationScreen({super.key});

  @override
  BookRecommendationScreenState createState() =>
      BookRecommendationScreenState();
}

class BookRecommendationScreenState extends State<BookRecommendationScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _bookRecommendations = [];

  // Function to fetch recommendations
  Future<void> fetchRecommendations(String title) async {
    final url = Uri.parse('http://127.0.0.1:5000/recommendations?title=$title');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _bookRecommendations = data; // Assuming the response is a list of book recommendations
      });
    } else {
      setState(() {
        _bookRecommendations = []; // If the response fails, clear the recommendations list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Recommendations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text field for book title input
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Book Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                fetchRecommendations(_controller.text);
              },
              child: const Text('Get Recommendations'),
            ),
            const SizedBox(height: 20),

            // Displaying the list of recommendations
            _bookRecommendations.isEmpty
                ? const Text('Recommendations will be displayed here')
                : Expanded(
                    child: ListView.builder(
                      itemCount: _bookRecommendations.length,
                      itemBuilder: (ctx, index) {
                        var book = _bookRecommendations[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: <Widget>[
                                // Book Thumbnail
                                book['thumbnail'] != null
                                    ? Image.network(
                                        book['thumbnail'],
                                        width: 50,
                                        height: 75,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.book, size: 50),
                                const SizedBox(width: 15),
                                // Book Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        book['title'] ?? 'No Title',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Categories: ${book['categories'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Average Rating: ${book['average_rating'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Ratings Count: ${book['ratings_count'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
