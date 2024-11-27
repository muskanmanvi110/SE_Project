import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  Future<List<Map<String, String>>> fetchBooksByGenre(String genre) async {
    final url = 'https://openlibrary.org/subjects/$genre.json?limit=30';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Map<String, String>> books = [];
        for (var item in data['works']) {
          books.add({
            'title': item['title'] ?? 'No Title',
            'author': item['authors'] != null
                ? item['authors'].map((author) => author['name']).join(', ')
                : 'Unknown Author',
            'cover_image': item['cover_id'] != null
                ? 'https://covers.openlibrary.org/b/id/${item['cover_id']}-M.jpg'
                : '',
            'id': item['key'] ?? '',
          });
        }
        return books;
      } else {
        throw Exception('Failed to load books');
      }
    } catch (error) {
      throw Exception('Failed to load books: $error');
    }
  }

  Future<Map<String, String>> fetchBookDetails(String bookId) async {
    final url = 'https://openlibrary.org$bookId.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final description = data['description'] != null
            ? (data['description'] is String
                ? data['description']
                : data['description']['value'])
            : 'No Description available.';

        return {
          'title': data['title'] ?? 'No Title',
          'author': data['authors'] != null
              ? data['authors'].map((author) => author['name']).join(', ')
              : 'Unknown Author',
          'description': description,
          'cover_image': data['covers'] != null
              ? 'https://covers.openlibrary.org/b/id/${data['covers'][0]}-M.jpg'
              : '',
        };
      } else {
        throw Exception('Failed to load book details');
      }
    } catch (error) {
      throw Exception('Failed to load book details: $error');
    }
  }
}
