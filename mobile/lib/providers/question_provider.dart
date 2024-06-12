import 'package:flutter/material.dart';
import '../entities/question.dart';

/// A provider class to manage question data.
///
/// This class uses the `ChangeNotifier` mixin to provide notification
/// capabilities to listeners when question data changes.
class QuestionProvider with ChangeNotifier {
  /// The internal list of questions.
  List<Question> _questions = [];

  /// Retrieves the list of questions.
  ///
  /// - Returns: A list of [Question] objects.
  List<Question> get questions => _questions;

  /// Sets the list of questions and notifies listeners.
  ///
  /// This method updates the internal list of questions and calls
  /// `notifyListeners` to inform all registered listeners about the change.
  ///
  /// - Parameters:
  ///   - newQuestions: A new list of [Question] objects.
  set questions(List<Question> newQuestions) {
    _questions = newQuestions;
    notifyListeners();
  }

  /// Adds a question to the list and notifies listeners.
  ///
  /// This method adds a new question to the internal list and calls
  /// `notifyListeners` to inform all registered listeners about the change.
  ///
  /// - Parameters:
  ///   - question: The [Question] object to add to the list.
  void addQuestion(Question question) {
    _questions.add(question);
    notifyListeners();
  }

  /// Removes a question from the list and notifies listeners.
  ///
  /// This method removes a question from the internal list and calls
  /// `notifyListeners` to inform all registered listeners about the change.
  ///
  /// - Parameters:
  ///   - question: The [Question] object to remove from the list.
  void removeQuestion(Question question) {
    _questions.remove(question);
    notifyListeners();
  }
}
