import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A service class for interacting with the OpenAI GPT-3 API.
///
/// This class provides methods to generate quiz questions based on given text
/// using the OpenAI GPT-3 model.
class OpenAIService {
  /// API key for authentication with the OpenAI API.
  final String apiKey = dotenv.env['OpenAiApiKey'] ??
      'There is a problem with the API key.'; // Replace with your API key

  /// Endpoint URL for the OpenAI API.
  final String apiUrl =
      'https://api.openai.com/v1/chat/completions'; // Updated endpoint

  /// Generates quiz questions based on the provided text.
  ///
  /// This method sends a POST request to the OpenAI GPT-3 API
  /// to generate quiz questions from the given text. It specifies the number
  /// of questions to generate, the difficulty level, and the language of the text.
  /// The response from the API contains the generated quiz question.
  Future<String> generateQuiz(
      String text, int numberOfQuestions, String difficulty) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content':
                'You are a helpful assistant that generates quiz questions.'
          },
          {
            'role': 'user',
            'content':
                'Stvori kviz od $numberOfQuestions pitanja na hrvatskom iz ovog teksta:\n$text. Ponudi 4 odgovora za svako pitanje i neka samo jedan od tih odgovora bude točan, a nakon svakog odgovora stavi oznaku točnosti - [0] ako je netočan ili [1] ako je dogovor točan. Neka težina pitanja bude $difficulty.'
          },
        ],
        'max_tokens': 1000,
        'temperature': 0.5,
        'n':
            1, // Specifies the number of completions to generate for each prompt
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'].trim();
    } else {
      final errorData = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(
          'Failed to generate quiz: ${errorData['error']['message']} (status code: ${response.statusCode})');
    }
  }
}
