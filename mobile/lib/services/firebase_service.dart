import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// The `AuthService` class provides methods for user authentication and FCM token retrieval.
///
/// This class encapsulates Firebase Authentication and Firebase Cloud Messaging functionality.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Signs in a user using email and password.
  ///
  /// Returns a `User` object upon successful sign-in, or null if an error occurs.
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  /// Retrieves the FCM token for the device.
  ///
  /// Returns the FCM token string if successful, or null if an error occurs.
  Future<String?> getFCMToken() async {
    try {
      String? token = await _messaging.getToken();
      return token;
    } catch (e) {
      print("Error getting FCM token: $e");
      return null;
    }
  }

  /// Signs out the currently authenticated user.

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
