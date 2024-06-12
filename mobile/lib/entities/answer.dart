/// The `Answer` class represents an answer to a question in a quiz or survey system.
class Answer {
  /// The unique identifier for the answer.
  final int answerId;

  /// The main text of the answer.
  final String answerText;

  /// A more detailed description of the answer.
  final String answerDescription;

  /// The identifier of the question to which this answer belongs.
  final int questionId;

  /// A boolean flag indicating whether this answer is correct.
  final bool correctAnswer;

  /// Initializes a new instance of the `Answer` class with the given properties.
  ///
  /// - Parameters:
  ///   - answerId: The unique identifier for the answer.
  ///   - answerText: The main text of the answer.
  ///   - answerDescription: A more detailed description of the answer.
  ///   - questionId: The identifier of the question to which this answer belongs.
  ///   - correctAnswer: A boolean flag indicating whether this answer is correct.
  Answer({
    required this.answerId,
    required this.answerText,
    required this.answerDescription,
    required this.questionId,
    required this.correctAnswer,
  });

  /// Creates an `Answer` instance from a JSON map.
  ///
  /// - Parameters:
  ///   - json: A JSON map containing the answer data.
  /// - Returns: An `Answer` instance populated with the data from the JSON map.
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerId: json['answerId'],
      answerText: json['answerText'],
      answerDescription: json['answerDescription'],
      questionId: json['questionId'],
      correctAnswer: json['correctAnswer'] == 1,
    );
  }

  /// Converts the `Answer` instance to a JSON map.
  ///
  /// - Returns: A JSON map containing the answer data.
  Map<String, dynamic> toJson() {
    return {
      'answerId': answerId,
      'answerText': answerText,
      'answerDescription': answerDescription,
      'questionId': questionId,
      'correctAnswer': correctAnswer ? 1 : 0,
    };
  }
}
