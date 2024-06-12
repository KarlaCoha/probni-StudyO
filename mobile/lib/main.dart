import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:studyo/entities/user.dart';
import 'package:studyo/screens/homepage.dart';
import 'package:studyo/screens/login.dart';
import 'package:studyo/screens/play_challenge.dart';
import 'package:studyo/screens/splash.dart';
import 'package:studyo/providers/theme_provider.dart';
import 'package:studyo/services/user_service.dart';
import 'providers/user_provider.dart';
import 'screens/personalized_quiz.dart';
import 'screens/profile_page.dart';
import 'screens/quiz_challenge.dart';
import 'screens/homepage.dart';
import 'screens/select_quiz.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:provider/provider.dart';
import 'screens/settings.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';
import 'services/local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Main function to start the application.
///
/// This function serves as the entry point for the application.
/// It loads environment variables from a `.env` file using the `dotenv` package,
/// initializes providers for state management using `ChangeNotifierProvider`,
/// and runs the main application using the `runApp` function.
/// The main application widget (`MyApp`) is wrapped with `MultiProvider`
/// to provide multiple providers to its descendants.
final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

//  handle in terminated state
  var initialNotification =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    // LocalNotifications.onClickNotification.stream.listen((event) {
    Future.delayed(Duration(seconds: 5), () {
      // print(event);
      navigatorKey.currentState!.pushNamed('/another',
          arguments: initialNotification?.notificationResponse?.payload);
    });
  }

  //runApp(const MyApp());

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print("uspjelo s bazom");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  try {
    await dotenv.load(fileName: ".env");
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MyApp(),
      ),
    );
  } catch (e) {
    print("Error loading .env file: $e");
  }
}

/// Main Application Widget
///
/// This widget represents the main application entry point.
/// It constructs the root widget of the application, configuring its title,
/// theme, and initial screen.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      /// Prevents back button from exiting the app
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        title: 'Studyo',
        theme: themeProvider.currentTheme,
        home: const Splash(),
      ),
    );
  }
}

/// Main Page Widget
///
/// This widget represents the main screen of the application, which is a StatefulWidget.
/// It consists of a Scaffold containing an AppBar, a body section with an IndexedStack
/// to switch between different screens based on the selected index, an endDrawer
/// for navigation, and a bottomNavigationBar for navigation between different sections.
class MainPage extends StatefulWidget {
  /// Constructs a MainPage widget.
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

/// State class for the MainPage widget.
class _MainPageState extends State<MainPage> {
  Future<MyUser> getUserData() async {
    UserService userService = UserService();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    // Provjeravamo je li userId null prije nego što nastavimo
    String? userId = userProvider.user?.id;
    if (userId != null) {
      try {
        Map<String, dynamic> userData = await userService.getUserData(userId);
        return MyUser.fromJson(userData);
      } catch (e) {
        throw Exception("Failed to fetch user data: $e");
      }
    } else {
      // Upravljanje situacijom kada je userId null
      throw Exception("User ID is null");
    }
  }

  int _selectedIndex = 2;

  late List<Widget> _pages;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = Provider.of<UserProvider>(context, listen: false).user?.id;
    _pages = [
      const SelectQuiz(),
      const PQuiz(),
      Homepage(),
      const QChallenge(),
      if (_userId != null) Profile(userId: _userId!)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          centerTitle: false,
          titleSpacing: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Image.asset('images/logo.png',
                    width: 125, fit: BoxFit.contain),
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        endDrawer: const NavigationDrawer(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                blurRadius: 7,
                color: Theme.of(context).primaryColorDark,
              )
            ], borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: BottomNavigationBar(
                elevation: 10,
                type: BottomNavigationBarType.shifting,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor:
                    Theme.of(context).primaryColorLight.withOpacity(0.8),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'Kvizovi',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.auto_stories), label: 'Tvoj kviz'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Početna'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.quiz), label: 'Izazov'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Moj profil'),
                ],
                onTap: (index) => _onItemTapped(index),
                currentIndex: _selectedIndex,
                showUnselectedLabels: true,
              ),
            ),
          ),
        ));
  }
}

/// Navigation Drawer Widget
///
/// This widget represents the navigation drawer of the application,
/// providing a menu for navigating between different screens and options.
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  Future<MyUser> getUserData(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(context),
              FutureBuilder<MyUser>(
                future: getUserData(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red));
                  } else if (snapshot.hasData) {
                    return buildMenuItems(context, snapshot.data!);
                  } else {
                    return const Text("No user data available",
                        style: TextStyle(color: Colors.red));
                  }
                },
              ),
            ],
          ),
        ),
      );

  /// Builds the header section of the navigation drawer.
  Widget buildHeader(BuildContext context) => Container();

  /// Builds the menu items section of the navigation drawer.
  Widget buildMenuItems(BuildContext context, MyUser user) => Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          ListTile(
            leading: Icon(Icons.chevron_left_rounded,
                color: Theme.of(context).primaryColorLight),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
              leading: FluttermojiCircleAvatar(
                radius: 40,
                backgroundColor: Colors.amber[200],
              ),
              title: Text(
                "${user.username}",
                style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${user.grade}. razred",
                style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                // Preuzimanje user ID-a iz Provider-a
                final userId =
                    Provider.of<UserProvider>(context, listen: false).user?.id;
                if (userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(userId: userId)),
                  );
                } else {
                  // Ako userID nije dostupan, prikažite grešku ili poruku
                  print('User ID is not available.');
                }
              }),
          const SizedBox(
            height: 30,
          ),
          ListTile(
            leading: Icon(Icons.settings_rounded,
                color: Theme.of(context).primaryColorLight),
            title: Text("Postavke",
                style: TextStyle(color: Theme.of(context).primaryColorLight)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.quiz_rounded,
                color: Theme.of(context).primaryColorLight),
            title: Text("Izazovi",
                style: TextStyle(color: Theme.of(context).primaryColorLight)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PlayChallengePage()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.nights_stay_rounded,
              color: Theme.of(context).primaryColorLight,
            ),
            title: Text("Tamna tema",
                style: TextStyle(color: Theme.of(context).primaryColorLight)),
            trailing: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
              return Switch(
                value: themeProvider.darkMode,
                onChanged: (value) {
                  themeProvider.toggleDarkMode();
                },
                activeColor: Theme.of(context).primaryColor,
                inactiveTrackColor: Theme.of(context).primaryColorDark,
              );
            }),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: Colors.red,
            ),
            title: const Text(
              "Odjava",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Odjava',
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        'Jeste li sigurni da se želite odjaviti?',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
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
                                  color: Theme.of(context).primaryColorLight,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                              );
                            },
                            child: const Text(
                              'Odjavi se',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    );
                  });
            },
          ),
        ],
      );
}
