import 'package:flutter/material.dart';
import 'package:studyo/screens/select_quiz.dart';
import '../main.dart';
import '../entities/question.dart';
import '../entities/answer.dart';
import 'homepage.dart';
import '../services/answer_service.dart';
import '../providers/user_provider.dart';
import '../services/user_service.dart';
import 'package:provider/provider.dart'; // Dodajte ovaj import

/// A screen widget representing the second page of the quiz.
///
/// This page displays the user's quiz score, correct and wrong answers,
/// and provides an option to review the answers to each question.
class SecondPage extends StatefulWidget {
  /// The total score obtained by the user in the quiz.
  final int score;

  /// The number of correctly answered questions.
  final int correctAnswers;

  /// The number of incorrectly answered questions.
  final int wrongAnswers;

  /// The list of questions answered by the user.
  final List<Question> questions;

  /// An instance of [AnswerService] to manage fetching answers from the database.
  final AnswerService answerService =
      AnswerService(); // Initialize AnswerService

  /// Constructs a SecondPage widget.
  ///
  /// The [score], [correctAnswers], [wrongAnswers], and [questions] parameters are required.
  SecondPage({
    Key? key,
    required this.score,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.questions,
  }) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

/// The State class for the SecondPage widget.
///
/// This class manages the state of the SecondPage widget, including fetching answers
/// and building the UI to display quiz results and answer review.
class _SecondPageState extends State<SecondPage> {
  /// A list containing answers for each question.
  late List<List<Answer>> answers = [];

  /// A flag indicating whether data is still being fetched.
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAnswers();
  }

  /// Fetches answers for each question asynchronously.
  void fetchAnswers() async {
    List<List<Answer>> fetchedAnswers = [];
    for (var question in widget.questions) {
      List<Answer> questionAnswers =
          await widget.answerService.getAnswers(question.questionId);
      fetchedAnswers.add(questionAnswers);
    }
    if (mounted) {
      setState(() {
        answers = fetchedAnswers;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: BackgroundPainter(theme: theme),
            ),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Image.asset(
                      'images/quiz_finish.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Čestitam!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.hintColor,
                        fontSize: 46,
                      ),
                    ),
                    Text(
                      'Tvoj broj bodova je:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.hintColor,
                        fontSize: 35,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${widget.correctAnswers}',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColorLight),
                    ),
                    const SizedBox(height: 30),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: MenuTile(
                              title: Row(
                                children: [
                                  Text(
                                    'Pogledaj odgovore!',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: theme.primaryColorLight),
                                  )
                                ],
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 223, 223, 223),
                                  Color.fromARGB(255, 223, 223, 223),
                                ],
                              ),
                              children: [
                                for (var i = 0;
                                    i < widget.questions.length;
                                    i++)
                                  Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          '${i + 1}. ${widget.questions[i].questionText}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: theme.primaryColorLight),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (answers.isNotEmpty &&
                                                answers.length > i)
                                              Text(
                                                'Točan odgovor: ${_getCorrectAnswer(answers[i], i)}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: theme.hintColor,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${_getanswerDescription(answers[i], i)}',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 45),
                    SizedBox(
                      height: 60,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          UserProvider userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          String? userId = userProvider.userId;

                          int currentPoints = userProvider.user?.points ?? 0;
                          int newPoints = currentPoints + widget.correctAnswers;

                          if (userId != null) {
                            UserService().updateUserPoints(userId, newPoints);
                            print('Prošli bodovi korisnika: $currentPoints');
                            print('Novi bodovi korisnika: $newPoints');
                          } else {
                            print('Korisnik nije prijavljen.');
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                        ),
                        child: const Text(
                          'OK!',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 45),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Retrieves the correct answer for the given question index.
  String _getCorrectAnswer(List<Answer> answerList, int questionIndex) {
    for (var answer in answerList) {
      if (answer.questionId == widget.questions[questionIndex].questionId &&
          answer.correctAnswer) {
        return answer.answerText;
      }
    }
    return '';
  }

  /// Retrieves the description of the answer for the given question index.
  String _getanswerDescription(List<Answer> answerList, int questionIndex) {
    for (var answer in answerList) {
      if (answer.questionId == widget.questions[questionIndex].questionId &&
          answer.correctAnswer) {
        return answer.answerDescription;
      }
    }
    return '';
  }
}
