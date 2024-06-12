import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A service class to interact with the question data API.
///
/// This class provides methods to fetch question data from a remote API.
/// It requires a base URL and an API key for authentication.
class QuestionService {
  final String baseUrl =
      dotenv.env['API_URL'] ?? 'default_api_url_if_not_found';
  final String apiKey = dotenv.env['API_KEY'] ?? 'default_api_key_if_not_found';

  /// Retrieves question data from the API.
  ///
  /// This method sends an HTTP GET request to the question data API
  /// and returns the question data as a List of Map<String, dynamic>.
  /// If the request fails or the response status code is not 200,
  /// an exception is thrown.
  Future<List<Map<String, dynamic>>> getQuestions() async {
    final url = '$baseUrl/question';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'accept': '*/*',
        'X-Api-Key': apiKey,
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception(
          'Failed to get question data. Status code: ${response.statusCode}, Response body: ${response.body}');
    }
  }
}
