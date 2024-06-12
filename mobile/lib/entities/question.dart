/// The `Question` class encapsulates question data including question ID,
/// question text, and lesson ID.
class Question {
  /// The unique identifier for the question.
  final int questionId;

  /// The text of the question.
  final String questionText;

  /// The identifier of the lesson to which this question belongs.
  final int lessonId;

  /// Constructs a new instance of the `Question` class.
  ///
  /// All parameters are required.
  ///
  /// - Parameters:
  ///   - questionId: The unique identifier for the question.
  ///   - questionText: The text of the question.
  ///   - lessonId: The identifier of the lesson to which this question belongs.
  Question({
    required this.questionId,
    required this.questionText,
    required this.lessonId,
  });

  /// Constructs a `Question` instance from a JSON map.
  ///
  /// This factory method creates a `Question` object by parsing a JSON map.
  /// It expects the JSON map to have keys corresponding to question properties.
  ///
  /// - Parameters:
  ///   - json: A JSON map containing the question data.
  /// - Returns: A `Question` instance populated with the data from the JSON map.
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'],
      questionText: json['questionText'],
      lessonId: json['lessonId'],
    );
  }

  /// Converts the `Question` object to a JSON map.
  ///
  /// This method converts the `Question` object into a JSON map representation.
  /// It returns a map with keys corresponding to question properties.
  ///
  /// - Returns: A JSON map containing the question data.
  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'lessonId': lessonId,
    };
  }
}
