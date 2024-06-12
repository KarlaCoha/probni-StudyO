import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyo/providers/user_provider.dart';
import 'play_quiz.dart';
import 'homepage.dart';
import '../entities/user.dart';
import '../services/user_service.dart';
import '../entities/subject.dart';
import '../services/subject_service.dart';
import '../entities/lesson.dart';
import '../services/lesson_service.dart';

/// A function to fetch the list of subjects asynchronously.

Future<List<Subject>> getSubjects() async {
  SubjectService subjectService = SubjectService();
  try {
    return await subjectService.getSubjects();
  } catch (e) {
    throw Exception("Failed to fetch subjects data: $e");
  }
}

/// A function to fetch the list of lessons asynchronously.

Future<List<Lesson>> getLessons() async {
  LessonService lessonService = LessonService();
  try {
    return await lessonService.getLessons();
  } catch (e) {
    throw Exception("Failed to fetch lessons data: $e");
  }
}

/// Widget for selecting quizzes.

class SelectQuiz extends StatefulWidget {
  const SelectQuiz({Key? key}) : super(key: key);

  @override
  _SelectQuizState createState() => _SelectQuizState();
}

/// State class for the SelectQuiz widget.

class _SelectQuizState extends State<SelectQuiz> {
  Future<MyUser> getUserData() async {
    UserService userService = UserService();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String? userId = userProvider.user?.id;
    if (userId != null) {
      try {
        Map<String, dynamic> userData = await userService.getUserData(userId);
        return MyUser.fromJson(userData);
      } catch (e) {
        throw Exception("Failed to fetch user data: $e");
      }
    } else {
      throw Exception("User ID is null");
    }
  }

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _userGrade;
  List<Subject> _subjects = [];
  List<Lesson> _lessons = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _fetchData() async {
    try {
      MyUser user = await getUserData();
      List<Subject> subjects = await getSubjects();
      List<Lesson> lessons = await getLessons();

      setState(() {
        _userGrade = user.grade;
        _subjects =
            subjects.where((subject) => subject.grade == _userGrade).toList();
        _lessons = lessons;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: BackgroundPainter(theme: theme),
          ),
          _userGrade == null
              ? Center(
                  child: _errorMessage == null
                      ? const CircularProgressIndicator()
                      : Text('Error: $_errorMessage'),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Predmetni kvizovi',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: theme.hintColor,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Pretraži kviz ili predmet',
                            labelStyle: TextStyle(
                              color: theme.hintColor,
                            ),
                            filled: true,
                            fillColor: theme.primaryColorDark,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          cursorColor: theme.hintColor,
                          style: TextStyle(
                            color: theme.hintColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ..._subjects.map((subject) {
                      final String subjectName =
                          subject.subjectName.toLowerCase();
                      final List<Lesson> filteredLessons = _lessons
                          .where(
                              (lesson) => lesson.subjectId == subject.subjectId)
                          .where((lesson) =>
                              lesson.lessonName
                                  .toLowerCase()
                                  .contains(_searchQuery) ||
                              subjectName.contains(_searchQuery))
                          .toList();

                      if (filteredLessons.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return MenuTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              subject.subjectName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Icon(
                              _getIconForSubject(subject.subjectName),
                              color: Colors.white,
                              size: 40,
                            ),
                          ],
                        ),
                        gradient: _getGradientForSubject(subject.subjectName),
                        children: filteredLessons
                            .map<Widget>((lesson) => ListTile(
                                  title: Text(lesson.lessonName,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QuizPage(
                                              lessonId: lesson.lessonId)),
                                    );
                                  },
                                ))
                            .toList(),
                      );
                    }).toList(),
                    const SizedBox(height: 50),
                  ],
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Returns an icon corresponding to the subject name.

  IconData _getIconForSubject(String subjectName) {
    switch (subjectName.toLowerCase()) {
      case 'matematika':
        return Icons.calculate;
      case 'engleski':
        return Icons.translate;
      case 'hrvatski':
        return Icons.book;
      case 'kemija':
        return Icons.science;
      case 'fizika':
        return Icons.bolt;
      case 'biologija':
        return Icons.eco;
      case 'njemački jezik':
        return Icons.chat_bubble;
      case 'povijest':
        return Icons.auto_stories;
      case 'geografija':
        return Icons.public;
      case 'tehnička kultura':
        return Icons.build;
      default:
        return Icons.book;
    }
  }

  /// Returns a gradient corresponding to the subject name.

  LinearGradient _getGradientForSubject(String subjectName) {
    switch (subjectName.toLowerCase()) {
      case 'matematika':
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 2, 87, 232),
            Color.fromARGB(255, 171, 223, 247)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'engleski':
        return const LinearGradient(
          colors: [
            Color.fromRGBO(115, 191, 184, 1),
            Color.fromARGB(255, 192, 236, 230)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'hrvatski':
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 234, 128, 35),
            Color.fromARGB(255, 248, 218, 129)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'kemija':
        return const LinearGradient(
          colors: [
            Color.fromRGBO(254, 198, 1, 1),
            Color.fromARGB(255, 239, 231, 165)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'fizika':
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 82, 0, 189),
            Color.fromARGB(255, 213, 201, 246)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'biologija':
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 234, 128, 35),
            Color.fromARGB(255, 248, 218, 129)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'njemački jezik':
        return const LinearGradient(
          colors: [
            Color.fromRGBO(115, 191, 184, 1),
            Color.fromARGB(255, 192, 236, 230)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'povijest':
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 2, 87, 232),
            Color.fromARGB(255, 171, 223, 247)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'geografija':
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 82, 0, 189),
            Color.fromARGB(255, 213, 201, 246)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'tehnička kultura':
        return const LinearGradient(
          colors: [
            Color.fromRGBO(254, 198, 1, 1),
            Color.fromARGB(255, 239, 231, 165)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 2, 87, 232),
            Color.fromARGB(255, 171, 223, 247)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}

/// Widget for displaying a menu tile.

class MenuTile extends StatelessWidget {
  final Widget title;
  final Gradient gradient;
  final List<Widget> children;

  const MenuTile({
    Key? key,
    required this.title,
    required this.gradient,
    this.children = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: title,
          children: children,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          childrenPadding: const EdgeInsets.only(left: 20),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          iconColor: const Color.fromARGB(255, 236, 236, 236),
          collapsedIconColor: const Color.fromARGB(255, 236, 236, 236),
        ),
      ),
    );
  }
}
