import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../entities/user.dart';
import '../services/user_service.dart';

/// A service class to interact with the user-related functionalities of the API.
class UserService {
  /// The base URL for API endpoints. If not found in the environment variables, a default URL is used.
  final String baseUrl =
      dotenv.env['API_URL'] ?? 'default_api_url_if_not_found';

  /// The API key used for authentication. If not found in the environment variables, a default key is used.
  final String apiKey = dotenv.env['API_KEY'] ?? 'default_api_key_if_not_found';

  /// Method to login user and fetch user data if login is successful.
  Future<MyUser?> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/account/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': apiKey,
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("Response data: $data");
        if (data.containsKey('userId')) {
          print('uspjelo je izvući korisnika');
          return MyUser.fromJson(data);
        } else {
          print('Login failed: User not found or data incomplete');
          return null;
        }
      } else {
        print(
            'Failed to login. Status code: ${response.statusCode}. Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Došlo je do greške pri slanju zahtjeva: $e');
    }
  }

  Future<MyUser?> loginRegisteredUser(String email, String password) async {
    try {
      return await loginUser(email, password);
    } catch (e) {
      print(
          "Došlo je do greške prilikom dohvaćanja registriranog korisnika: $e");
      return null;
    }
  }

  Future<List<MyUser>> getUsers() async {
    final url = Uri.parse('$baseUrl/user');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Api-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((data) => MyUser.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  /// Retrieves user data from the API.
  Future<Map<String, dynamic>> getUserData(String userId) async {
    final url = Uri.parse('$baseUrl/user/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Api-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(
          'Failed to get user data. Status code: ${response.statusCode}. Response body: ${response.body}');
      throw Exception('Failed to load user data');
    }
  }

  /// Registers a new user.
  Future<bool> registerUser(MyUser user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': user.firstName,
        'lastName': user.lastName,
        'username': user.username,
        'birthDate': user.birthDate,
        'gender': user.gender,
        'grade': user.grade,
        'email': user.email,
        'password': user.password
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(
          'Failed to register. Status code: ${response.statusCode}. Response body: ${response.body}');
      return false;
    }
  }

  /// Verifies the email verification code.
  Future<bool> verifyEmail(String email, String verificationCode) async {
    final url = Uri.parse('$baseUrl/account/verifyemail');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': apiKey,
        },
        body: jsonEncode({
          'email': email,
          'code': verificationCode,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to verify email. Status code: ${response.statusCode}. Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('An error occurred while sending the request: $e');
      return false;
    }
  }

  Future<void> updateUserProfile(String userId,
      {String? gender, int? grade, String? birthDate}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'gender': gender,
        'grade': grade,
        'birthDate': birthDate
      }),
    );

    if (response.statusCode == 200) {
      print('User updated successfully');
    } else {
      print('Failed to update user: ${response.statusCode}');
    }
  }

  Future<void> updateUserToken(String userId, String token) async {
    final url = '$baseUrl/user/$userId';

    final headers = {
      'Content-Type': 'application/json',
      'X-Api-Key': apiKey,
    };

    final body = json.encode([
      {
        "operationType": 2,
        "path": "/DeviceToken",
        "op": "replace",
        "value": token,
      },
    ]);

    print('Sending PATCH request to URL: $url');
    print('Request headers: $headers');
    print('Request body: $body');

    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('User updated successfully');
    } else {
      print('Failed to update user: ${response.statusCode}');
    }
  }

  Future<void> updateUserPoints(String userId, int newPoints) async {
    final url = '$baseUrl/user/$userId';

    final headers = {
      'Content-Type': 'application/json',
      'X-Api-Key': apiKey,
    };

    final body = json.encode([
      {
        "operationType": 2,
        "path": "/points",
        "op": "replace",
        "value": newPoints,
      },
    ]);

    print('Sending PATCH request to URL: $url');
    print('Request headers: $headers');
    print('Request body: $body');

    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('User updated successfully');
    } else {
      print('Failed to update user: ${response.statusCode}');
    }
  }

  Future<void> updateUser(
      String userId, String gender, int schoolClassId, String birthDate) async {
    final url = '$baseUrl/user/$userId';

    final headers = {
      'Content-Type': 'application/json',
      'X-Api-Key': apiKey,
    };

    final body = json.encode([
      {
        "operationType": 2,
        "path": "/gender",
        "op": "replace",
        "value": gender,
      },
      {
        "operationType": 2,
        "path": "/schoolClassId",
        "op": "replace",
        "value": schoolClassId,
      },
      {
        "operationType": 2,
        "path": "/dateOfBirth",
        "op": "replace",
        "value": birthDate,
      },
    ]);

    print('Sending PATCH request to URL: $url');
    print('Request headers: $headers');
    print('Request body: $body');

    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('User updated successfully');
    } else {
      print('Failed to update user: ${response.statusCode}');
    }
  }

  /// Retrieves the school class ID based on the provided grade.
  Future<int?> getSchoolClassId(int grade) async {
    try {
      final url = Uri.parse('$baseUrl/schoolclass/grade/$grade');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is List && jsonData.isNotEmpty) {
          return jsonData[0]['schoolClassId'];
        } else {
          print('School class not found for grade: $grade');
          return null;
        }
      } else {
        print(
            'Failed to get school class. Status code: ${response.statusCode}. Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('An error occurred while fetching school class: $e');
      return null;
    }
  }

  /// Retrieves the class number associated with the provided school class ID.
  Future<int?> getClassNumber(int schoolClassId) async {
    final url = '$baseUrl/schoolclass/$schoolClassId';

    final headers = {
      'Content-Type': 'application/json',
      'X-Api-Key': apiKey,
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final classNumber = responseData['classNumber'] as int?;
        return classNumber;
      } else {
        print(
            'Failed to get class number. Status code: ${response.statusCode}. Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('An error occurred while sending the request: $e');
      return null;
    }
  }
}
