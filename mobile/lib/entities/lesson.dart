/// The `Lesson` class encapsulates lesson data including lesson ID, lesson name,
/// lesson description, and subject ID.
class Lesson {
  /// The unique identifier for the lesson.
  final int lessonId;

  /// The name of the lesson.
  final String lessonName;

  /// A description of the lesson.
  final String lessonDescription;

  /// The identifier of the subject to which this lesson belongs.
  final int subjectId;

  /// Constructs a new instance of the `Lesson` class.
  ///
  /// All parameters are required.
  ///
  /// - Parameters:
  ///   - lessonId: The unique identifier for the lesson.
  ///   - lessonName: The name of the lesson.
  ///   - lessonDescription: A description of the lesson.
  ///   - subjectId: The identifier of the subject to which this lesson belongs.
  Lesson({
    required this.lessonId,
    required this.lessonName,
    required this.lessonDescription,
    required this.subjectId,
  });

  /// Constructs a `Lesson` instance from a JSON map.
  ///
  /// This factory method creates a `Lesson` object by parsing a JSON map.
  /// It expects the JSON map to have keys corresponding to lesson properties.
  ///
  /// - Parameters:
  ///   - json: A JSON map containing the lesson data.
  /// - Returns: A `Lesson` instance populated with the data from the JSON map.
  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lessonId'],
      lessonName: json['lessonName'],
      lessonDescription: json['lessonDescription'],
      subjectId: json['subjectId'],
    );
  }

  /// Converts the `Lesson` object to a JSON map.
  ///
  /// This method converts the `Lesson` object into a JSON map representation.
  /// It returns a map with keys corresponding to lesson properties.
  ///
  /// - Returns: A JSON map containing the lesson data.
  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'lessonName': lessonName,
      'lessonDescription': lessonDescription,
      'subjectId': subjectId,
    };
  }
}
