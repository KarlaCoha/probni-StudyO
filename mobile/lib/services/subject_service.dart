import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../entities/subject.dart';

/// A service class to interact with the subject data API.
///
/// This class provides methods to fetch subject data from a remote API.
/// It requires a base URL and an API key for authentication.
class SubjectService {
  final String baseUrl =
      dotenv.env['API_URL'] ?? 'https://studyo-api.azurewebsites.net';
  final String apiKey =
      dotenv.env['API_KEY'] ?? '9C8CD0E8-C9DA-4CAC-A5B9-E1C06E39B3E9';

  /// Retrieves subject data from the API.
  ///
  /// This method sends an HTTP GET request to the subject data API
  /// and returns the subject data as a List<Subject>.
  /// If the request fails or the response status code is not 200,
  /// an exception is thrown.
  Future<List<Subject>> getSubjects() async {
    final url = '$baseUrl/subject';
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
      List<dynamic> subjectsJson = json.decode(response.body);
    List<Subject> subjects = subjectsJson.map((json) => Subject.fromJson(json)).toList();
    
    subjects.forEach((subject) {
      print('Subject Name: ${subject.subjectName}');
    });
      return subjectsJson.map((json) => Subject.fromJson(json)).toList();
      
    } else {
      throw Exception(
          'Failed to get subject data. Status code: ${response.statusCode}, Response body: ${response.body}');
    }
  }
}
