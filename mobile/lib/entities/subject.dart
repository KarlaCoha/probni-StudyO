/// The `Subject` class encapsulates subject data including subject ID, subject name,
/// grade, and class ID.
class Subject {
  /// The unique identifier for the subject.
  final int subjectId;

  /// The name of the subject.
  final String subjectName;

  /// The grade level of the subject.
  final int grade;

  /// The identifier of the class to which this subject belongs.
  final int classId;

  /// Constructs a new instance of the `Subject` class.
  ///
  /// All parameters are required.
  ///
  /// - Parameters:
  ///   - subjectId: The unique identifier for the subject.
  ///   - subjectName: The name of the subject.
  ///   - grade: The grade level of the subject.
  ///   - classId: The identifier of the class to which this subject belongs.
  Subject({
    required this.subjectId,
    required this.subjectName,
    required this.grade,
    required this.classId,
  });

  /// Constructs a `Subject` instance from a JSON map.
  ///
  /// This factory method creates a `Subject` object by parsing a JSON map.
  /// It expects the JSON map to have keys corresponding to subject properties.
  ///
  /// - Parameters:
  ///   - json: A JSON map containing the subject data.
  /// - Returns: A `Subject` instance populated with the data from the JSON map.
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],
      grade: json['grade'],
      classId: json['classId'],
    );
  }

  /// Converts the `Subject` object to a JSON map.
  ///
  /// This method converts the `Subject` object into a JSON map representation.
  /// It returns a map with keys corresponding to subject properties.
  ///
  /// - Returns: A JSON map containing the subject data.
  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
      'grade': grade,
      'classId': classId,
    };
  }
}
