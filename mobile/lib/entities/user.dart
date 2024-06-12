/// The `User` class encapsulates user data including their personal information
/// such as first name, last name, gender, birth date, grade, special needs,
/// username, password, and email.
class MyUser {
  final String? id;

  /// The first name of the user.
  final String? firstName;

  /// The last name of the user.
  final String? lastName;

  /// The gender of the user.
  String? gender;

  /// The birth date of the user.
  String? birthDate;

  /// The grade level of the user.
  int? grade;

  /// Indicates whether the user has special needs.
  final int? specialNeed;

  /// The username of the user.
  final String? username;

  /// The password of the user.
  final String? password;

  /// The email address of the user.
  final String? email;

  /// The points accumulated by the user.
  int points;
  final String? token;

  /// Constructs a new instance of the `User` class.
  ///
  /// All parameters are optional and have default values.
  ///
  /// - Parameters:
  ///   - id: The unique identifier for the user.
  ///   - firstName: The first name of the user.
  ///   - lastName: The last name of the user.
  ///   - gender: The gender of the user.
  ///   - birthDate: The birth date of the user.
  ///   - grade: The grade level of the user.
  ///   - specialNeed: Indicates whether the user has special needs.
  ///   - username: The username of the user.
  ///   - password: The password of the user.
  ///   - email: The email address of the user.
  ///   - points: The points accumulated by the user, default value is 0.
  MyUser(
      {this.id,
      this.firstName,
      this.lastName,
      this.gender,
      this.birthDate,
      this.grade,
      this.specialNeed,
      this.username,
      this.password,
      this.email,
      this.points = 0,
      this.token 
      });

  /// Constructs a `User` instance from a JSON map.
  ///
  /// This factory method creates a `User` object by parsing a JSON map.
  /// It expects the JSON map to have keys corresponding to user properties.
  ///
  /// - Parameters:
  ///   - json: A JSON map containing the user data.
  /// - Returns: A `User` instance populated with the data from the JSON map.
  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
        id: json['userId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gender: json['gender'],
        birthDate: json['dateOfBirth'],
        grade: json['schoolClassId'],
        specialNeed: json['specialNeedsId'] ?? 0,
        username: json['username'],
        password: json['password'],
        email: json['email'],
        points: json['points'] ?? 0,
        token: json['token'] 
        );
  }

  /// Converts the `User` object to a JSON map.
  ///
  /// This method converts the `User` object into a JSON map representation.
  /// It returns a map with keys corresponding to user properties.
  ///
  /// - Returns: A JSON map containing the user data.
  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': birthDate,
      'schoolClassId': grade,
      'specialNeedsId': specialNeed,
      'username': username,
      'password': password,
      'email': email,
      'points': points,
      'token': token
    };
  }

  /// Returns a string representation of the `User` object.
  ///
  /// This method overrides the default `toString` method to provide a
  /// string representation of the user with selected properties.
  ///
  /// - Returns: A string representation of the `User` object.
  @override
  String toString() {
    return 'User { id: $id, firstName: $firstName, lastName: $lastName, email: $email, username: $username, gender: $gender, grade: $grade, birthDate: $birthDate, points: $points}';
  }
}
