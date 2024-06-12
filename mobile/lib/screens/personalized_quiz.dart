import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studyo/entities/answer.dart';
import 'package:studyo/entities/question.dart';
import 'package:studyo/screens/homepage.dart';
import 'package:studyo/screens/play_ai_quiz.dart';
import 'package:studyo/services/open_ai_service.dart';

/// PQuiz Widget
///
/// This widget represents the Personalized Quiz screen of the application, which is a StatefulWidget.
/// It allows users to create personalized quizzes by selecting question difficulty and providing
/// content for the quiz.
class PQuiz extends StatefulWidget {
  const PQuiz({super.key});

  @override
  _PQuizState createState() => _PQuizState();
}

/// State class for the PQuiz widget.
class _PQuizState extends State<PQuiz> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool hasQuizBeenGenerated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _difficultySliderValue = 1;
  int _numberOfQuestions = 10;

  final List<int> _numbersForDropdown = [5, 6, 7, 8, 9, 10];

  /// Returns a label for the given slider value.
  String _getLabelForSliderValue(double value) {
    switch (value.round()) {
      case 0:
        return 'Laka';
      case 1:
        return 'Srednja';
      case 2:
        return 'Teška';
      default:
        return '';
    }
  }

  final TextEditingController _textController = TextEditingController();
  final OpenAIService _openAIService = OpenAIService();
  String _quiz = '';

  /// Generates a quiz based on the user input text.

  void _generateQuiz() async {
    final text = _textController.text;
    if (text.isNotEmpty) {
      try {
        final quiz = await _openAIService.generateQuiz(
            text,
            _numberOfQuestions.toInt(),
            _getLabelForSliderValue(_difficultySliderValue));
        setState(() {
          _quiz = quiz;
          _numberOfQuestions;
          hasQuizBeenGenerated = true;
        });
      } catch (e) {
        setState(() {
          _quiz = 'Failed to generate quiz: $e';
          hasQuizBeenGenerated = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: BackgroundPainter(theme: Theme.of(context)),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Personalizirani kviz',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).hintColor,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Scrollbar(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Ovdje upiši gradivo',
                        hintStyle: TextStyle(
                            color: Theme.of(context).primaryColorLight),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColorLight,
                            width: 1.0,
                          ),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).primaryColorDark,
                      ),
                      cursorColor: Theme.of(context).hintColor,
                      style:
                          TextStyle(color: Theme.of(context).primaryColorLight),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 5,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(children: [
                  Text(
                    'Odaberi broj pitanja',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton<int>(
                    value: _numberOfQuestions,
                    hint: Text('Select a number'),
                    focusColor: Theme.of(context).primaryColor,
                    dropdownColor: Theme.of(context).primaryColorDark,
                    style:
                        TextStyle(color: Theme.of(context).primaryColorLight),
                    items: _numbersForDropdown.map((int number) {
                      return DropdownMenuItem<int>(
                        value: number,
                        child: Text(number.toString()),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _numberOfQuestions = newValue!;
                      });
                    },
                  ),
                ]),
                Text(
                  'Odaberi težinu pitanja',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                Slider(
                    value: _difficultySliderValue,
                    max: 2,
                    divisions: 2,
                    activeColor: Theme.of(context).primaryColor,
                    thumbColor: Theme.of(context).primaryColor,
                    label: _getLabelForSliderValue(_difficultySliderValue),
                    onChanged: (double value) {
                      setState(() {
                        _difficultySliderValue = value;
                      });
                    }),
                const SizedBox(height: 8),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          _generateQuiz();
                        },
                        child: const Text(
                          'Generiraj Kviz',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5);
                              }
                              return Theme.of(context).primaryColor;
                            },
                          ),
                        ),
                        onPressed: hasQuizBeenGenerated
                            ? () {
                                parseQuestionsAndAnswers(_quiz, context);
                              }
                            : null,
                        child: const Text(
                          'Zaigraj Kviz',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 227, 27, 12)),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Obriši kviz',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(
                                    'Ako kliknete "obriši kviz", izbrisat ćete kviz koji ste upravo generirali. Ovaj kviz je jedinstven i nigdje se ne sprema.',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Odustani',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _quiz = '';
                                          _textController.clear();
                                          hasQuizBeenGenerated = false;
                                        },
                                        child: const Text(
                                          'Obriši kviz',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                );
                              });
                        },
                        child: const Text(
                          'Obriši kviz',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        _quiz,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 70,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Parses the generated quiz string into questions and answers.
///
/// This function takes the generated quiz string as input and parses it into individual questions and answers.
/// It then creates Question and Answer objects and stores them in lists. Finally, it navigates to the quiz
/// page, passing the parsed questions and answers as arguments.
///
/// Parameters:
///   - input: The generated quiz string.
void parseQuestionsAndAnswers(String input, BuildContext context) {
  List<Question> questions = [];
  List<Answer> answers = [];

  int questionId = 1;
  int answerId = 1;
  int lessonId = 1;

  // Split the input string into individual questions
  List<String> questionBlocks = input.split('\n\n');

  for (String questionBlock in questionBlocks) {
    // Split the block into lines
    List<String> lines = questionBlock.split('\n');

    // The first line is the question text
    String questionText = lines[0].substring(3).trim();

    Question question = Question(
      questionId: questionId,
      questionText: questionText,
      lessonId: lessonId,
    );

    questions.add(question);

    // Process each answer
    for (int i = 1; i < lines.length; i++) {
      String line = lines[i];
      bool correctAnswer = line.endsWith('[1]');
      String answerText = line
          .substring(3, line.length - 4)
          .trim(); // Remove 'a. ' and ' [0]' or ' [1]'

      Answer answer = Answer(
        answerId: answerId,
        answerText: answerText,
        answerDescription: '',
        questionId: questionId,
        correctAnswer: correctAnswer,
      );

      answers.add(answer);
      answerId++;
    }

    questionId++;
  }

  // For this example, we'll print out the questions and answers to verify
  for (var question in questions) {
    print('Question ${question.questionId}: ${question.questionText}');
    var associatedAnswers =
        answers.where((a) => a.questionId == question.questionId);
    for (var answer in associatedAnswers) {
      print(
          '  Answer ${answer.answerId}: ${answer.answerText} (Correct: ${answer.correctAnswer})');
    }
  }

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PlayAIQuizPage(
                answers: answers,
                questions: questions,
              )));
}
