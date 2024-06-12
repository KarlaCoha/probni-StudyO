import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../screens/send_challenge.dart';

/// The `Challenge` class represents a challenge object.
///
/// It contains properties such as userId, challengedUserId, lessonId, and status.
class Challenge {
  final String userId;
  final String challengedUserId;
  final String lessonId;
  final String status;

  /// Constructs a Challenge object.
  ///
  /// The [userId], [challengedUserId], and [lessonId] parameters are required,
  /// while the [status] parameter is optional.
  Challenge({
    required this.userId,
    required this.challengedUserId,
    required this.lessonId,
    this.status = '',
  });

  /// Converts the Challenge object to a JSON format.

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'challengedUserId': challengedUserId,
      'lessonId': lessonId,
      'status': status,
    };
  }
}

/// The `ChallengeService` class provides methods for sending challenges.
///
/// This class handles the communication with the server for challenge-related operations.
class ChallengeService {
  final String baseUrl =
      dotenv.env['API_URL'] ?? 'default_api_url_if_not_found';
  final String apiKey = dotenv.env['API_KEY'] ?? 'default_api_key_if_not_found';

  /// Sends a challenge to the server.
  ///
  /// The [challenge] parameter represents the challenge object to be sent.
  ///
  /// Throws an exception if an error occurs during the process.
  Future<void> sendChallenge(Challenge challenge) async {
    try {
      print('OVO ŠALJEM NA ENDPOINT:');
      print('userId: ${challenge.userId}');
      print('challengedUserId: ${challenge.challengedUserId}');
      print('lessonId: ${challenge.lessonId}');
      print('status: ${challenge.status}');

      final url = Uri.parse('$baseUrl/user/send-challenge');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': apiKey,
        },
        body: jsonEncode(challenge.toJson()),
      );

      if (response.statusCode == 200) {
        print('Challenge sent successfully');
      } else {
        print(
            'Failed to send challenge. Status code: ${response.statusCode}. Response body: ${response.body}');
        throw Exception('Failed to send challenge');
      }
    } catch (e) {
      print('An error occurred while sending the challenge: $e');
      throw Exception('Failed to send challenge');
    }
  }
}
