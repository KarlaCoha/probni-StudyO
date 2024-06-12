/// Dart library for handling JSON encoding/decoding and making HTTP requests.
import 'dart:convert';

/// HTTP client library for making requests.
import 'package:http/http.dart' as http;

/// Library for loading environment variables.
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Importing the Answer entity.
import '../entities/answer.dart';

/// A service class for managing operations related to answers.
class AnswerService {
  /// Base URL for the API. Defaults to a placeholder URL if not provided in the environment.
  final String baseUrl =
      dotenv.env['API_URL'] ?? 'https://studyo-api.azurewebsites.net';

  /// API key for accessing the API. Defaults to a placeholder key if not provided in the environment.
  final String apiKey =
      dotenv.env['API_KEY'] ?? '9C8CD0E8-C9DA-4CAC-A5B9-E1C06E39B3E9';

  /// Fetches a list of answers for a given question ID.
  ///
  /// Returns a list of Answer objects.
  ///
  /// Throws an Exception if the request fails.
  Future<List<Answer>> getAnswers(int questionId) async {
    // Construct the URL for fetching answers for the given question ID.
    final url = '$baseUrl/answer/question/$questionId';

    // Send an HTTP GET request to the API endpoint.
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'accept': '*/*',
        'X-Api-Key': apiKey,
      },
    );

    // Print status code and response body for debugging purposes.
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    // Check if the request was successful (status code 200).
    if (response.statusCode == 200) {
      // Decode the JSON response body into a list of dynamic objects.
      final List<dynamic> data = json.decode(response.body);
      // Map each JSON object to an Answer object and return as a list.
      return data.map((json) => Answer.fromJson(json)).toList();
    } else {
      // If the request failed, throw an exception with details.
      throw Exception(
        'Failed to get answer data. Status code: ${response.statusCode}, Response body: ${response.body}',
      );
    }
  }
}
