import 'package:flutter/material.dart';
import 'dart:async';
import 'package:studyo/styles/styles.dart';
import 'win_quiz.dart';
import '../entities/question.dart';
import '../services/question_service.dart';
import '../services/answer_service.dart';
import '../entities/answer.dart';

/// Widget for conducting quizzes.
///
/// This widget allows users to take quizzes associated with a specific lesson.
class QuizPage extends StatefulWidget {
  /// The ID of the lesson associated with the quiz.
  final int lessonId;

  /// Constructor for QuizPage widget.
  ///
  /// The [lessonId] parameter specifies the ID of the lesson.
  const QuizPage({Key? key, required this.lessonId}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

/// State class for the QuizPage widget.
///
/// Manages the state of the quiz, including questions, answers, timer, etc.
class _QuizPageState extends State<QuizPage> {
  int _counter = 0;
  String _timerText = '00:00';
  Timer? _timer;

  List<bool> _buttonTapped = [false, false, false, false];
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  bool _questionAnswered = false;

  List<Question> _questions = [];
  List<Answer> _currentAnswers = [];

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Fetches answers for the current question from the server.
  ///
  /// This method retrieves answers associated with the current question
  /// from the backend server and updates the UI accordingly.
  void _fetchAnswersForCurrentQuestion() async {
    if (_questions.isNotEmpty && _counter < _questions.length) {
      final answerService = AnswerService();
      final answers =
          await answerService.getAnswers(_questions[_counter].questionId);
      setState(() {
        _currentAnswers = answers;
      });
    }
  }

  /// Initializes the quiz.
  ///
  /// Retrieves questions associated with the lesson from the server and
  /// prepares the quiz for the user.
  void _initializeQuiz() async {
    final questionService = QuestionService();
    final questionsMapList = await questionService.getQuestions();

    final questions = questionsMapList
        .map((questionMap) => Question.fromJson(questionMap))
        .where((question) => question.lessonId == widget.lessonId)
        .take(10)
        .toList();

    setState(() {
      _questions = questions;
    });

    _fetchAnswersForCurrentQuestion();
  }

  /// Starts the timer for the quiz.
  ///
  /// This method initiates a timer that updates the UI every second to
  /// display the elapsed time of the quiz.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) return;
      setState(() {
        int minutes = timer.tick ~/ 60;
        int seconds = timer.tick % 60;
        _timerText =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      });
    });
  }

  /// Stops the timer for the quiz.
  ///
  /// This method cancels the timer when the quiz is completed or dismissed.
  void _stopTimer() {
    _timer?.cancel();
  }

  /// Handles the selection of an answer option.
  ///
  /// This method updates the UI to reflect the selected answer option and
  /// keeps track of the user's answer statistics.
  void _changeButtonColor(int index) {
    setState(() {
      _buttonTapped = [false, false, false, false];
      if (index >= 0) {
        _buttonTapped[index] = true;

        if (_currentAnswers[index].correctAnswer) {
          _correctAnswers++;
        } else {
          _wrongAnswers++;
        }
        _questionAnswered = true;
      }
    });
  }

  /// Moves to the next question in the quiz.
  ///
  /// This method advances the quiz to the next question and updates the UI
  /// accordingly. If all questions have been answered, it navigates to the
  /// score page.
  void _nextQuestion() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _counter++;
        _fetchAnswersForCurrentQuestion();
        _changeButtonColor(-1);
        _questionAnswered = false;

        if (_counter >= _questions.length) {
          _stopTimer();
          _navigateToScorePage(_questions);
        }
      });
    });
  }

  /// Navigates to the score page after completing the quiz.
  ///
  /// This method directs the user to the score page, where they can view
  /// their quiz score and performance details.
  void _navigateToScorePage(List<Question> questions) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondPage(
          score: _counter,
          correctAnswers: _correctAnswers,
          wrongAnswers: _wrongAnswers,
          questions: questions,
        ),
      ),
    );
  }

  /// Builds the UI for answer options.
  ///
  /// This method constructs the UI components representing answer options
  /// and handles user interaction such as tapping to select an answer.
  Widget _buildAnswerOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        4,
        (index) {
          if (index < _currentAnswers.length) {
            return GestureDetector(
              onTap: _questionAnswered
                  ? null
                  : () {
                      setState(() {
                        if (_buttonTapped[index]) {
                          _changeButtonColor(-1);
                        } else {
                          _changeButtonColor(index);
                        }
                      });
                      _nextQuestion();
                    },
              child: Container(
                height: 70.0,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: _buttonTapped[index]
                      ? (_currentAnswers[index].correctAnswer
                          ? Theme.of(context).hintColor
                          : Theme.of(context).primaryColor)
                      : Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(bottom: 15.0),
                child: Center(
                  child: Text(
                    _currentAnswers[index].answerText,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container(height: 70.0);
          }
        },
      ),
    );
  }

  /// Builds the UI for the quiz page.
  ///
  /// This method constructs the user interface for the quiz page, including
  /// the timer, question display, answer options, and progress indicators.
  /// It also handles user interactions such as selecting answer options.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: CustomPaint(
          size: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
          painter: BackgroundPainterOne(theme: Theme.of(context)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    '$_timerText',
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
                const SizedBox(height: 35.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    _questions.length,
                    (index) => Container(
                      width: 25.0,
                      height: 15.0,
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                        color: index < _counter
                            ? Theme.of(context).hintColor
                            : index == _counter
                                ? secondaryColor
                                : Colors.grey,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                (_questions.isEmpty || _counter >= _questions.length)
                    ? const CircularProgressIndicator()
                    : Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${_counter + 1}. ${_questions[_counter].questionText}',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ),
                const SizedBox(height: 40.0),
                _buildAnswerOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the background of the quiz page.
///
/// This class defines a custom painter for the background of the quiz page.
/// It creates a visually appealing background with gradient colors.
class BackgroundPainterOne extends CustomPainter {
  final ThemeData theme;

  /// Constructor for BackgroundPainterOne.
  ///
  /// The [theme] parameter specifies the theme data used for painting.
  BackgroundPainterOne({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paintPrimary = Paint()
      ..color = Color.fromARGB(155, 241, 120, 21)
      ..style = PaintingStyle.fill;

    final Paint paintTurquoise = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color.fromARGB(31, 23, 204, 168),
          Color.fromARGB(204, 214, 236, 238)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final Paint paintYellow = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color.fromARGB(255, 251, 247, 211),
          Color.fromARGB(169, 255, 225, 0)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    var pathUpperLeft = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.3, 0)
      ..quadraticBezierTo(
          size.width * 0.15, size.height * 0.15, 0, size.height * 0.15)
      ..close();
    canvas.drawPath(pathUpperLeft, paintPrimary);

    var pathLowerRight = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width, size.height * 0.85)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.9, size.width * 0.8, size.height)
      ..close();
    canvas.drawPath(pathLowerRight, paintPrimary);

    var pathMiddleRight = Path()
      ..moveTo(size.width, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.55, size.width,
          size.height * 0.65);
    canvas.drawPath(pathMiddleRight, paintYellow);

    var pathLowerLeft = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.8)
      ..quadraticBezierTo(
          size.width * 0.5, size.height * 0.8, size.width * 0.5, size.height)
      ..close();
    canvas.drawPath(pathLowerLeft, paintTurquoise);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
