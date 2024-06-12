import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:studyo/entities/user.dart';
import '../services/user_service.dart';
import 'select_quiz.dart';
import 'homepage.dart';
import '../styles/themes.dart';
import '../charts/line_chart.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

/// Profile Widget
///
/// Represents the user profile page, displaying user information and progress.
class Profile extends StatefulWidget {
  final String userId; 

  const Profile({Key? key, required this.userId})
      : super(key: key); 

  @override
  _ProfileState createState() => _ProfileState();
}

/// State class for the Profile widget.
class _ProfileState extends State<Profile> {
  /// Fetches user data asynchronously.
  Future<MyUser> getUserData() async {
    UserService userService = UserService();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    // Checking if userId is not null before proceeding
    String? userId = userProvider.user?.id;
    if (userId != null) {
      try {
        Map<String, dynamic> userData =
            await userService.getUserData(userId); 
        return MyUser.fromJson(userData);
      } catch (e) {
        throw Exception("Failed to fetch user data: $e");
      }
    } else {
      // Handling the scenario where userId is null
      throw Exception("User ID is null");
    }
  }

  /// Fetches the class number for the given school class ID.
  Future<int?> getClassNumber(int schoolClassId) async {
    final userService = UserService();
    return await userService.getClassNumber(schoolClassId);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context).brightness == Brightness.dark
        ? darkTheme
        : lightTheme;

    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            painter: BackgroundPainter(theme: theme),
            child: SizedBox.expand(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Moj profil',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<MyUser>(
                future: getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return buildUserProfile(snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}",
                          style: const TextStyle(color: Colors.red));
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the user profile UI according to the current user's info.
  Widget buildUserProfile(MyUser user) {
    return Column(
      children: [
        const SizedBox(height: 20),
        FluttermojiCircleAvatar(
            radius: 95, backgroundColor: Theme.of(context).hintColor),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(-10, -20),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.list, color: Colors.white),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SelectQuiz())),
                ),
              ),
            ),
            const SizedBox(width: 40),
            Transform.translate(
              offset: const Offset(0, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => showEditAvatarDialog(),
                ),
              ),
            ),
            const SizedBox(width: 40),
            Transform.translate(
              offset: const Offset(10, -20),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.people, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          user.username ?? '',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).hintColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        _buildSection(
          title: "Moj napredak u bodovima",
          child: WeeklyBarChart(),
          colors: [
            const Color.fromARGB(174, 230, 230, 230),
            const Color.fromARGB(176, 255, 255, 255)
          ],
        ),
        const SizedBox(height: 25),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: _buildInfoBox(
                      title: "Ime",
                      content: "${user.firstName}",
                      gradientColors: [
                    const Color.fromARGB(255, 2, 87, 232),
                    const Color.fromARGB(255, 171, 223, 247)
                  ])),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildInfoBox(
                      title: "Prezime",
                      content: user.lastName ?? '',
                      gradientColors: [
                    const Color.fromARGB(255, 254, 195, 1),
                    const Color.fromARGB(255, 239, 231, 165)
                  ])),
              const SizedBox(width: 10),
              Expanded(
                  child: FutureBuilder<int?>(
                future: getClassNumber(user.grade ?? 0),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return _buildInfoBox(
                        title: "Razred",
                        content: "${snapshot.data}",
                        gradientColors: [
                          Theme.of(context).hintColor,
                          const Color.fromARGB(255, 192, 236, 230)
                        ]);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )),
            ],
          ),
        ),
        const SizedBox(height: 70),
      ],
    );
  }

  /// Shows the dialog for editing avatar.
  void showEditAvatarDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FluttermojiCustomizer();
      },
      isScrollControlled: true,
    );
  }

  /// Builds a section with title, child widget, and background colors.
  Widget _buildSection(
      {required String title,
      required Widget child,
      required List<Color> colors,
      String? imagePath}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: colors.map((color) => color.withOpacity(0.85)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).hintColor)),
              if (imagePath != null) Image.asset(imagePath, height: 50),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

/// Builds an information box widget.
Widget _buildInfoBox(
    {required String title,
    required String content,
    double height = 130,
    required List<Color> gradientColors}) {
  return Container(
    height: height,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 131, 131, 131).withOpacity(0.5),
          spreadRadius: 0,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
