import 'package:flutter/material.dart';
import 'package:studyo/screens/register.dart';
import '../styles/themes.dart';
import '../main.dart';
import '../services/user_service.dart';
import '../providers/user_provider.dart';
import '../entities/user.dart';
import '../services/local_notifications.dart';
import 'package:provider/provider.dart';

/// Login Screen Widget
///
/// This widget represents the login screen of the application.
/// It allows users to input their email and password for authentication.
/// If the user is not registered, they can navigate to the registration screen.
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _loginError;

  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }

  /// Listens to notification clicks.
  ///
  /// This function listens to click events on notifications and navigates to
  /// another screen when a notification is clicked.
  listenToNotifications() {
    print("Listening to notification");
    LocalNotifications.onClickNotification.stream.listen((event) {
      print(event);
      Navigator.pushNamed(context, '/another', arguments: event);
    });
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
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: BackgroundPainter(theme: theme),
          ),
          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 61, 34, 2).withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Image.asset(
                            'images/logo.png',
                            height: 100,
                            width: 150,
                          ),
                        ],
                      ),
                      TextFormField(
                        cursorColor: theme.primaryColor,
                        controller: _emailController,
                        style: TextStyle(color: theme.primaryColorLight),
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: TextStyle(
                            color: theme.hintColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.primaryColorDark,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.primaryColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite e-mail';
                          }
                          if (!value.contains('@') || value.length < 6) {
                            return 'Molimo unesite ispravnu e-mail adresu';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        cursorColor: theme.primaryColor,
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(color: theme.primaryColorLight),
                        decoration: InputDecoration(
                          labelText: 'Lozinka',
                          labelStyle: TextStyle(
                            color: theme.hintColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.primaryColorDark,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.primaryColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite lozinku';
                          }
                          if (value.length < 6) {
                            return 'Molimo unesite ispravnu lozinku';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _loginError ?? '',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 193, 13, 1),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                theme.primaryColor)),
                        onPressed: () {
                          _validateForm();
                          Future.delayed(const Duration(seconds: 5), () {
                            LocalNotifications.showSimpleNotification(
                                title: "StudyO",
                                body:
                                    "Zaigraj kviz i popni se na leaderboardu🏆 Izazovi prijatelje i pokaži svoje znanje!",
                                payload: "StudyO App");
                          });
                        },
                        child: const Text(
                          'Prijava',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        },
                        child: Text(
                          'Nemaš račun? Stvori ga!',
                          style: TextStyle(
                            color: theme.primaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Validates the login form.
  ///
  /// This function validates the email and password entered by the user.
  /// If the form is valid, it attempts to log in the user.
  void _validateForm() async {
    setState(() {
      _loginError = null;
    });
    if (_formKey.currentState!.validate()) {
      UserService userService = UserService();
      MyUser? user = await userService.loginUser(
          _emailController.text, _passwordController.text);
      if (user != null) {
        Provider.of<UserProvider>(context, listen: false).user = user;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
      } else {
        setState(() {
          _loginError = 'Pogrešan e-mail ili lozinka';
        });
      }
    }
  }

  /// Dispose method for cleaning up resources.
  ///
  /// This method is called when the widget is removed from the widget tree
  /// and is used to dispose of resources such as controllers, streams, or subscriptions.
  /// In this case, it disposes of the [_emailController] and [_passwordController]
  /// to release any resources they hold.
  /// It is essential to call `super.dispose()` to ensure that the parent class's
  /// dispose method is also invoked, releasing any additional resources it may hold.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

/// BackgroundPainter Custom Painter
///
/// This custom painter is responsible for painting the background of a canvas
/// with a decorative pattern based on the provided [theme].
/// It creates a visually pleasing background composed of primary, turquoise, and yellow colors.
class BackgroundPainter extends CustomPainter {
  final ThemeData theme;

  BackgroundPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paintPrimary = Paint()
      ..color = theme.primaryColor
      ..style = PaintingStyle.fill;

    final Paint paintTurquoise = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color.fromARGB(255, 23, 204, 168),
          Color.fromARGB(255, 214, 236, 238)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final Paint paintYellow = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color.fromARGB(255, 251, 247, 211),
          Color.fromARGB(255, 255, 225, 0)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    var pathUpperLeft = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.5, 0)
      ..quadraticBezierTo(
          size.width * 0.45, size.height * 0.2, 0, size.height * 0.40)
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
          size.width * 0.3, size.height * 0.8, size.width * 0.3, size.height)
      ..close();
    canvas.drawPath(pathLowerLeft, paintTurquoise);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
