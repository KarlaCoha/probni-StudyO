import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyo/providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/user_service.dart';
import '../entities/user.dart';
import '../providers/user_provider.dart';

/// The SettingsScreen class represents the screen where users can adjust various settings.
///
/// This screen allows users to toggle accessibility options, such as custom fonts
/// for users with special needs, adjust language preferences, enable/disable sound,
/// and access user details and privacy settings.
///
/// To use this screen, simply instantiate it and navigate to it within your app.
///
/// Example:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => SettingsScreen()),
/// );
/// ```
class SettingsScreen extends StatefulWidget {
  /// Constructs a SettingsScreen.
  ///
  /// The [key] parameter is used to identify this widget in the widget tree.
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isAccessibilityEnabled = false;
  bool isADHDEnabled = false;
  bool isDyslexiaEnabled = false;
  double textSize = 16.0;
  bool isSoundEnabled = true;
  bool isDarkMode = false;
  String selectedLanguage = 'HRV';

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Postavke',
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text(
              'Omogući prilagođavanja za korisnike sa posebnim potrebama',
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Uključi opcije kao što su prilagođeni fontovi',
              style: TextStyle(
                color: Theme.of(context).primaryColorLight.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            value: themeNotifier.isSpecialNeeds,
            onChanged: (bool value) {
              setState(() {
                isAccessibilityEnabled = value;
                themeNotifier.toggleSpecialNeeds();
              });
            },
            activeColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Theme.of(context).primaryColorDark,
          ),
          if (themeNotifier.isSpecialNeeds) ...[
            SwitchListTile(
              title: Text(
                'ADHD prilagodbe',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Prilagođeni fontovi i formatiranje za ADHD',
                style: TextStyle(
                  color: Theme.of(context).hintColor.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: isADHDEnabled,
              onChanged: (value) {
                setState(() {
                  isADHDEnabled = value;
                });
              },
              activeColor: Theme.of(context).primaryColor,
              inactiveTrackColor: Theme.of(context).primaryColorDark,
            ),
            SwitchListTile(
              title: Text(
                'Disleksija prilagodbe',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Prilagođeni fontovi i formatiranje za disleksiju',
                style: TextStyle(
                  color: Theme.of(context).hintColor.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: isDyslexiaEnabled,
              onChanged: (value) {
                setState(() {
                  isDyslexiaEnabled = value;
                  themeNotifier.toggleFont();
                });
              },
              activeColor: Theme.of(context).primaryColor,
              inactiveTrackColor: Theme.of(context).primaryColorDark,
            ),
          ],
          ListTile(
            title: Text(
              'Odaberite jezik',
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: DropdownButton<String>(
              value: selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue != null) {
                    selectedLanguage = newValue;
                  }
                });
              },
              items: <String>['HRV', 'ENG', 'DEU']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                );
              }).toList(),
            ),
          ),
          SwitchListTile(
            title: Text(
              'Omogući zvukove',
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            value: isSoundEnabled,
            onChanged: (bool value) {
              setState(() {
                isSoundEnabled = value;
              });
            },
            activeColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Theme.of(context).primaryColorDark,
          ),
          ListTile(
            title: Text(
              'Pojedinosti o korisniku',
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserDetailsScreen()));
            },
          ),
          ListTile(
            title: Text(
              'Provjera postavki privatnosti',
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrivacySettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}

/// The UserDetailsScreen class displays details about a user.
///
/// This screen fetches and displays information about the currently logged-in user,
/// such as username, first name, last name, grade, email, gender, birth date, special needs status,
/// and privacy settings. It also provides an option to reveal the user's password with a tap gesture.
///
/// To use this screen, simply instantiate it and navigate to it within your app.
///
/// Example:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => UserDetailsScreen()),
/// );
/// ```
class UserDetailsScreen extends StatefulWidget {
  /// Constructs a UserDetailsScreen.
  ///
  /// The [key] parameter is used to identify this widget in the widget tree.
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool _showPassword = false;

  /// Fetches user data from the server.
  ///
  /// This method uses the UserService to retrieve user data based on the user's ID.
  /// It throws an exception if the user ID is null or if there's an error fetching the data.
  Future<MyUser> getUserData() async {
    UserService userService = UserService();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    // Check if userId is null before proceeding
    String? userId = userProvider.user?.id;
    if (userId != null) {
      try {
        Map<String, dynamic> userData = await userService.getUserData(userId);
        return MyUser.fromJson(userData);
      } catch (e) {
        throw Exception("Failed to fetch user data: $e");
      }
    } else {
      // Handle the situation when userId is null
      throw Exception("User ID is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalji korisnika',
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<MyUser>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return buildUserDetails(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  /// Builds the user details layout.
  ///
  /// This method constructs a ListView containing various user details such as username,
  /// name, grade, email, etc. It also provides an option to reveal the user's password
  /// with a tap gesture.
  Widget buildUserDetails(MyUser user) {
    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        SizedBox(height: 15),
        Center(
          child: Text(
            user.username ?? '',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
        ),
        userDetailsTile("Ime", user.firstName),
        userDetailsTile("Prezime", user.lastName),
        userDetailsTile("Razred", user.grade.toString()),
        userDetailsTile("Email", user.email),
        userDetailsTile("Spol", user.gender),
        userDetailsTile("Datum rođenja", user.birthDate),
        userDetailsTile("Posebne potrebe", user.specialNeed == 1 ? "Da" : "Ne"),
        SizedBox(height: 20),
      ],
    );
  }

  /// Constructs a ListTile for user details.
  ///
  /// This method creates a ListTile widget with a title and a value.
  /// It provides an option to reveal the user's password if [isPassword] is true.
  Widget userDetailsTile(String title, dynamic value,
      {bool isPassword = false}) {
    String displayValue = value?.toString() ?? 'Nije dostupno';
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 0,
      //shadowColor: Colors.black.withOpacity(0.5),
      color: Color.fromARGB(174, 253, 197, 129),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor)),
        subtitle: GestureDetector(
          onTap: isPassword
              ? () => setState(() => _showPassword = !_showPassword)
              : null,
          child: Text(
            isPassword && !_showPassword
                ? '•' * (displayValue.length > 0 ? displayValue.length : 8)
                : displayValue,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        trailing: isPassword
            ? Icon(_showPassword ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColor)
            : null,
      ),
    );
  }
}

/// The PrivacySettingsScreen class displays privacy-related settings and information.
///
/// This screen presents various privacy-related options and provides detailed information
/// about privacy and security measures taken by the application. It also includes links
/// to read detailed privacy policies and guidelines.
///
/// To use this screen, simply instantiate it and navigate to it within your app.
///
/// Example:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => PrivacySettingsScreen()),
/// );
/// ```
class PrivacySettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Postavke privatnosti',
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              childAspectRatio: (1 / 2),
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              children: <Widget>[
                PrivacyCard(
                  imagePath: 'images/repair.png',
                  title: 'Tko može vidjeti moje rezultate?',
                  description:
                      'Tvoji prijatelji mogu vidjeti tvoje rezultate isključivo na leaderboardu i kviz-izazovu!',
                ),
                PrivacyCard(
                  imagePath: 'images/protection.png',
                  title: 'Savjeti za sigurnost vašeg računa',
                  description:
                      'Zaštiti svoj račun jakom lozinkom i ne dijeli svoje privatne informacije!',
                ),
                PrivacyCard(
                    imagePath: 'images/marketing.png',
                    title: 'Prava i zaštita djece',
                    description:
                        'Provjeri i upoznaj se sa svojim pravima na sigurnost i privatnost!',
                    onTapUrl:
                        'https://www.unicef.org/croatia/price/zastita-djecjih-prava-u-digitalnom-svijetu'),
                PrivacyCard(
                  imagePath: 'images/approved.png',
                  title: 'Tko može vidjeti moj profil?',
                  description:
                      'Detalje tvog profila mogu vidjeti samo tvoji prijatelji.',
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () => _launchUrl,
                child: Text(
                  'Pročitajte detaljna pravila o zaštiti i privatnosti',
                  style: TextStyle(
                      color: Theme.of(context).hintColor, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Vaša privatnost i sigurnost su nam od iznimne važnosti. Naša aplikacija koristi najsuvremenije sigurnosne mjere kako bi zaštitila vaše osobne podatke. Ne dijelimo vaše informacije s trećim stranama bez vašeg izričitog pristanka. \n\nZa djecu, posebno pazimo da stvorimo sigurno okruženje gdje se podaci obrađuju s najvećom pažnjom i sukladno zakonima o zaštiti prava djece u digitalnom svijetu. Roditelji mogu upravljati postavkama privatnosti svoje djece i imati uvid u aktivnosti unutar aplikacije kako bi osigurali njihovu sigurnost. \n\nPreporučujemo redovito pregledavanje vaših postavki privatnosti i kontaktiranje naše podrške ukoliko imate bilo kakvih pitanja ili zabrinutosti.',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The PrivacyCard class represents a card widget displaying privacy-related information.
///
/// This card widget is typically used within the PrivacySettingsScreen to present
/// various privacy-related options and information. It consists of an image, a title,
/// a description, and an optional URL that can be launched when tapped.
///
/// To use this widget, simply create an instance of PrivacyCard and provide the necessary
/// parameters. Optionally, you can specify a URL to launch when the card is tapped.
///
/// Example:
/// ```dart
/// PrivacyCard(
///   imagePath: 'images/repair.png',
///   title: 'Tko može vidjeti moje rezultate?',
///   description: 'Tvoji prijatelji mogu vidjeti tvoje rezultate isključivo na leaderboardu i kviz-izazovu!',
///   onTapUrl: 'https://www.example.com/privacy-policy',
/// );
/// ```
class PrivacyCard extends StatelessWidget {
  /// The path to the image displayed on the card.
  final String imagePath;

  /// The title of the privacy card.
  final String title;

  /// The description of the privacy card.
  final String description;

  /// The URL to be launched when the card is tapped (optional).
  final String? onTapUrl;

  /// Constructs a PrivacyCard.
  ///
  /// The [imagePath], [title], and [description] parameters are required.
  /// The [onTapUrl] parameter is optional.
  PrivacyCard({
    required this.imagePath,
    required this.title,
    required this.description,
    this.onTapUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 255, 247, 237),
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (onTapUrl != null) {
            _launchUrl();
          } else {
            print('Tap on $title');
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(imagePath, height: 100),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                description,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The URL to be launched when tapping on the PrivacyCard.
final Uri _url = Uri.parse(
    'https://www.unicef.org/croatia/price/zastita-djecjih-prava-u-digitalnom-svijetu');

/// Launches the URL when tapped on the PrivacyCard.
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
