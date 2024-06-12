import 'package:flutter/material.dart';
import '../entities/user.dart';
import 'package:intl/intl.dart';

/// A provider class for managing the user data.
///
/// This class uses the `ChangeNotifier` mixin to provide notification
/// capabilities to listeners when the user data changes.
class UserProvider with ChangeNotifier {
  MyUser? _user;
  String? _userId;

  /// Retrieves the current user.
  ///
  /// - Returns: A [User] object representing the current user, or null if no user is set.
  MyUser? get user => _user;

  /// Retrieves the current user ID.
  ///
  /// - Returns: A string representing the user ID, or null if no user ID is set.
  String? get userId => _userId;

  /// Sets the current user and updates the user ID.
  ///
  /// This method updates the internal user and user ID, and notifies all
  /// registered listeners about the change.
  ///
  /// - Parameters:
  ///   - newUser: A [User] object representing the new user.
  set user(MyUser? newUser) {
    _user = newUser;
    _userId = newUser?.id; 
    notifyListeners();
  }

  /// Updates the user's details and notifies listeners.
  ///
  /// This method updates the current user's gender, grade, and birth date,
  /// and notifies all registered listeners about the change.
  ///
  /// - Parameters:
  ///   - gender: An optional string representing the user's gender.
  ///   - grade: An optional integer representing the user's grade.
  ///   - birthDate: An optional [DateTime] representing the user's birth date.
  void updateUserDetails({String? gender, int? grade, DateTime? birthDate}) {
    if (_user != null) {
      _user = MyUser(
        id: _user!.id,
        firstName: _user!.firstName,
        lastName: _user!.lastName,
        email: _user!.email,
        username: _user!.username,
        password: _user!.password,
        gender: gender ?? _user!.gender,
        grade: grade ?? _user!.grade,
        birthDate: birthDate != null
            ? DateFormat('yyyy-MM-dd').format(birthDate)
            : _user!.birthDate,
      );
      _userId = _user!.id; 
      notifyListeners();
    }
  }

  /// Sets the user ID and notifies listeners.
  ///
  /// This method updates the internal user ID and notifies all registered
  /// listeners about the change.
  ///
  /// - Parameters:
  ///   - userId: A string representing the new user ID.
  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }
}
