import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchRecommendations(String title) async {
  final url = Uri.parse('http://127.0.0.1:5000/recommendations?title=$title');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print(data);
  } else {
    print('Failed to load recommendations');
  }
}