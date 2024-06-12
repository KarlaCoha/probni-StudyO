import 'package:flutter/material.dart';
import '../entities/user.dart';
import '../services/user_service.dart';

/// The `UserDetailsScreen` class represents a screen widget to display the details of a user.
///
/// This widget fetches user details asynchronously and displays them in a structured manner,
/// providing information such as username, first name, last name, grade, email, gender, birth date,
/// and special needs status.
class UserDetailsScreen extends StatefulWidget {
  /// Constructs a UserDetailsScreen widget.
  ///
  /// The [key] parameter is used to identify this widget in the widget tree.
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

/// The `_UserDetailsScreenState` class represents the State class for the UserDetailsScreen widget.
///
/// This class manages the state of the UserDetailsScreen widget, including fetching user data
/// and building the UI to display user details.
class _UserDetailsScreenState extends State<UserDetailsScreen> {
  /// A Future containing the user data to be displayed.
  late Future<MyUser> futureUser;

  /// The primary color used for styling UI elements.
  final Color primaryColor = const Color.fromARGB(255, 190, 86, 17);
  final Color sectionTitleColor = const Color.fromARGB(255, 244, 200, 139);

  @override
  void initState() {
    super.initState();
    UserService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalji Korisnika',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<MyUser>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return buildUserDetails(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text("Greška: ${snapshot.error}");
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  /// Builds the user details UI.
  Widget buildUserDetails(MyUser user) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(user.username ?? '',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor)),
          const SizedBox(height: 20),
          userDetailsTile("Ime", user.firstName ?? ''),
          userDetailsTile("Prezime", user.lastName ?? ''),
          userDetailsTile("Razred", user.grade.toString()),
          userDetailsTile("Email", user.email ?? ''),
          userDetailsTile("Spol", user.gender ?? ''),
          userDetailsTile("Rođendan", user.birthDate ?? ''),
          userDetailsTile(
              "Specijalne potrebe", user.specialNeed == 1 ? "Da" : "Ne"),
        ],
      ),
    );
  }

  /// Builds a tile to display user details.
  ///
  /// The [title] parameter represents the title of the user detail.
  /// The [value] parameter represents the value of the user detail.
  Widget userDetailsTile(String title, String value) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
              fontSize: 18, color: primaryColor, fontWeight: FontWeight.bold)),
      subtitle: Text(value,
          style: const TextStyle(fontSize: 16, color: Colors.black)),
    );
  }
}
