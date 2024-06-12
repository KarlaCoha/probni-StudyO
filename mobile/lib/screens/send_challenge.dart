import 'package:flutter/material.dart';
import 'package:studyo/services/challenge_service.dart';
import 'homepage.dart';
import '../services/user_service.dart';
import '../entities/user.dart';
import '../entities/subject.dart';
import '../entities/lesson.dart';
import '../services/subject_service.dart';
import '../services/lesson_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

/// A page for sending challenges to friends.
class SendChallengePage extends StatefulWidget {
  @override
  _SendChallengePageState createState() => _SendChallengePageState();
}

class _SendChallengePageState extends State<SendChallengePage> {
  List<MyUser> allFriends = [];
  List<MyUser> filteredFriends = [];
  late List<Subject> allSubjects;
  late List<Lesson> allLessons;
  late List<String> allQuizzes;
  late List<String> filteredQuizzes;
  // Controllers for name input and quiz search.

  late TextEditingController nameController;
  late TextEditingController quizController;
  String? selectedQuiz;
  String? selectedFriend;
  bool isLoading = false;
  String? challengedUserId;
  String? lessonId;

  @override
  void initState() {
    super.initState();
    // Initialize controllers.

    nameController = TextEditingController();
    quizController = TextEditingController();
    // Initialize lists.

    filteredQuizzes = [];
    allFriends = [];
    filteredFriends = [];
    allSubjects = [];
    allLessons = [];
    allQuizzes = [];
    filteredQuizzes = [];
    fetchFriends();
    fetchSubjectsAndLessons();
  }

  /// Filters quizzes based on user input.

  void filterQuizzes(String query) {
    setState(() {
      filteredQuizzes = query.isNotEmpty
          ? allQuizzes
              .where((quiz) => quiz.toLowerCase().contains(query.toLowerCase()))
              .toList()
          : allQuizzes;
    });
  }

  /// Fetches subjects and lessons.

  Future<void> fetchSubjectsAndLessons() async {
    try {
      List<Subject> subjects = await SubjectService().getSubjects();
      List<Lesson> lessons = await LessonService().getLessons();
      setState(() {
        allSubjects = subjects;
        allLessons = lessons;
        allQuizzes = lessons.map((lesson) => lesson.lessonName).toList();
        filteredQuizzes.addAll(allQuizzes);
      });
    } catch (e) {
      print('Failed to load subjects and lessons: $e');
    }
  }

  /// Fetches subjects.

  Future<void> fetchSubjects() async {
    try {
      List<Subject> subjects = await SubjectService().getSubjects();
      setState(() {
        allSubjects = subjects;
      });
    } catch (e) {
      print('Failed to load subjects: $e');
    }
  }

  /// Fetches lessons.

  Future<void> fetchLessons() async {
    try {
      List<Lesson> lessons = await LessonService().getLessons();
      setState(() {
        allLessons = lessons;
      });
    } catch (e) {
      print('Failed to load lessons: $e');
    }
  }

  /// Fetches user's friends.

  Future<void> fetchFriends() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserService userService = UserService();
      List<MyUser> users = await userService.getUsers();
      setState(() {
        allFriends = users;
        filteredFriends = users;
      });
    } catch (e) {
      print('Failed to load users: $e');
      // Handle error, show a message to the user, etc.
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    quizController.dispose();
    super.dispose();
  }

  /// Filters friends based on user input.

  void filterFriends(String query) {
    setState(() {
      filteredFriends = query.isNotEmpty
          ? allFriends
              .where((friend) =>
                  friend.username
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ??
                  false)
              .toList()
          : allFriends;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pošalji izazov!',
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: BackgroundPainter(theme: Theme.of(context)),
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: nameController,
                    onChanged: filterFriends,
                    decoration: InputDecoration(
                      labelText: 'Pretraži prijatelje!',
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).hintColor,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: filteredFriends
                                .map((friend) => buildFriendItem(friend))
                                .toList(),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: quizController,
                    onChanged: filterQuizzes,
                    decoration: InputDecoration(
                      labelText: 'Pretraži kvizove!',
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).hintColor,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: filteredQuizzes
                          .map((quiz) => buildQuizItem(quiz))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        sendChallenge();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        'Pošalji!',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a widget for displaying a friend.

  Widget buildFriendItem(MyUser friend) {
    bool isSelected = selectedFriend == friend.username;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFriend = friend.username;
            challengedUserId = friend.id;
          });
          print('Selected friend: $selectedFriend and id: $challengedUserId');
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSelected
                ? Color.fromARGB(255, 251, 229, 200)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                friend.username ?? 'unknown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Icon(
                Icons.person,
                color: isSelected ? Colors.orangeAccent : Colors.amber,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a widget for displaying a quiz.

  Widget buildQuizItem(String quiz) {
    bool isSelected = selectedQuiz == quiz;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedQuiz = quiz;
            lessonId = allQuizzes.indexOf(quiz).toString();
          });
          print('Selected quiz: $selectedQuiz and lesson id : $lessonId');
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSelected
                ? Color.fromARGB(255, 251, 229, 200)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                quiz,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Icon(
                Icons.list,
                color: isSelected ? Colors.orangeAccent : Colors.amber,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sends a challenge.

  void sendChallenge() async {
    MyUser? currentUser =
        Provider.of<UserProvider>(context, listen: false).user;

    if (currentUser != null && challengedUserId != null && lessonId != null) {
      Challenge challenge = Challenge(
        userId: currentUser.id!,
        challengedUserId: challengedUserId!,
        lessonId: lessonId!,
      );

      print('Current User ID: ${challenge.userId}');
      print('Challenged User ID: ${challenge.challengedUserId}');
      print('Lesson ID: ${challenge.lessonId}');

      try {
        await ChallengeService().sendChallenge(challenge);
      } catch (e) {
        print('Failed to send challenge: $e');
      }
    } else {
      print('User, challenged user, or lesson not selected');
    }
  }
}
