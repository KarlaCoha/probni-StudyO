import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../entities/lesson.dart';

/// A service class to interact with the lesson data API.
///
/// This class provides methods to fetch lesson data from a remote API.
/// It requires a base URL and an API key for authentication.
class LessonService {
  /// Base URL of the lesson data API.
  final String baseUrl =
      dotenv.env['API_URL'] ?? 'https://studyo-api.azurewebsites.net';

  /// API key for authentication with the lesson data API.
  final String apiKey =
      dotenv.env['API_KEY'] ?? '9C8CD0E8-C9DA-4CAC-A5B9-E1C06E39B3E9';

  /// Retrieves lesson data from the API.
  ///
  /// This method sends an HTTP GET request to the lesson data API
  /// and returns the lesson data as a List<Lesson>.
  /// If the request fails or the response status code is not 200,
  /// an exception is thrown.
  Future<List<Lesson>> getLessons() async {
    final url = '$baseUrl/lesson';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-Api-Key': apiKey,
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> lessonsJson = json.decode(response.body);
      return lessonsJson.map((json) => Lesson.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to get lesson data. Status code: ${response.statusCode}, Response body: ${response.body}');
    }
  }
}
