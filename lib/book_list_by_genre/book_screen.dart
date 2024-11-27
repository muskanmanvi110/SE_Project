import 'package:flutter/material.dart';
import 'book_service.dart';


class BookScreen extends StatelessWidget {
  const BookScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text('Top Books by genre'),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)
        ) ,
        ),
      body: const BooksByGenreScreen(),
    );
  }
}

class BooksByGenreScreen extends StatefulWidget {
  const BooksByGenreScreen({super.key});
  @override
  BooksByGenreScreenState createState() => BooksByGenreScreenState();
}

class BooksByGenreScreenState extends State<BooksByGenreScreen> {
  final BookService bookService = BookService();
  List<Map<String, String>> books = [];
  String selectedGenre = 'fiction';
  final List<String> genres = ['fiction', 'mystery', 'fantasy', 'history', 'romance'];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      final fetchedBooks = await bookService.fetchBooksByGenre(selectedGenre);
      setState(() {
        books = fetchedBooks;
      });
    } catch (e) {
      print('Failed to load books: $e');
    }
  }
  void _showBookDetails(String bookId) async {
    try {
      final bookDetails = await bookService.fetchBookDetails(bookId);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(bookDetails['title'] ?? 'No Title'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bookDetails['cover_image'] != ''
                      ? Image.network(bookDetails['cover_image']!)
                      : const SizedBox(width: 100, height: 150),
                  const SizedBox(height: 10),
                  
                  const SizedBox(height: 10),
                  Text('Description: ${bookDetails['description']}'),
                ],
              ),
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
    } catch (e) {
      print('Failed to load book details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedGenre,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGenre = newValue!;
                  _fetchBooks();
                });
              },
              items: genres.map<DropdownMenuItem<String>>((String genre) {
                return DropdownMenuItem<String>(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: books.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return ListTile(
                        leading: book['cover_image'] != ''
                            ? Image.network(book['cover_image']!)
                            : const SizedBox(width: 50, height: 75),
                        title: Text(book['title']!),
                        subtitle: Text(book['author']!),
                        onTap: () {
                          _showBookDetails(book['id']!);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
