import 'dart:async';
import 'package:flutter/material.dart';
import 'package:studyo/screens/login.dart';
import '../styles/themes.dart';
import '../services/user_service.dart';
import '../entities/user.dart';
import 'register_code.dart';
import 'privacy_policy_page.dart';

/// Register Widget
///
/// Represents the registration page where users can sign up by providing their
/// email, username, and password.
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /* @override
  Widget build(BuildContext context) {
    return GameStats(
      emailController: _emailController,
      passwordController: _passwordController,
    );
  }*/

//final _formKey = GlobalKey<FormState>();
  //String? _selectedGender;
  //int? _selectedGrade;
  //DateTime? _selectedDate = DateTime.now();
  //f/inal TextEditingController _dateController = TextEditingController();

  String? _usernameErrorMessage;
  String? _emailErrorMessage;

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final userService = UserService();

      final user = MyUser(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      print(user);

      final success = await userService.registerUser(user);

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerificationPage(
                email: _emailController.text,
                password: _passwordController.text),
          ),
        );
      } else {
        setState(() {
          _usernameErrorMessage =
              'Korisničko ime već postoji. Molimo odaberite\ndrugo korisničko ime.';
          _emailErrorMessage =
              'E-mail već postoji. Molimo odaberite drugi\ne-mail.';
        });
      }
    }
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
              width: 330,
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
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Image.asset(
                            'images/logo.png',
                            height: 50,
                            width: 150,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextFormField(
                                cursorColor: theme.primaryColor,
                                controller: _firstNameController,
                                style: TextStyle(
                                    color: theme
                                        .primaryColorLight), 
                                decoration: InputDecoration(
                                  labelText: 'Ime',
                                  labelStyle: TextStyle(
                                      color: theme.hintColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
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
                                    return 'Molim unesite ime';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                cursorColor: theme.primaryColor,
                                controller: _lastNameController,
                                style: TextStyle(
                                    color: theme
                                        .primaryColorLight), 
                                decoration: InputDecoration(
                                  labelText: 'Prezime',
                                  labelStyle: TextStyle(
                                      color: theme.hintColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
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
                                    return 'Molimo unesite\nprezime';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        cursorColor: theme.primaryColor,
                        controller: _usernameController,
                        style: TextStyle(
                            color: theme
                                .primaryColorLight),
                        decoration: InputDecoration(
                          labelText: 'Korisničko ime',
                          labelStyle: TextStyle(
                              color: theme.hintColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
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
                          errorText: _usernameErrorMessage, 
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite korisničko ime';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        cursorColor: theme.primaryColor,
                        controller: _emailController,
                        style: TextStyle(
                            color: theme
                                .primaryColorLight), 
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: TextStyle(
                              color: theme.hintColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
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
                          errorText: _emailErrorMessage, 
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite e-mail';
                          }
                          if (!value.contains('@')) {
                            return 'Molimo unesite ispravnu e-mail adresu';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextFormField(
                                cursorColor: theme.primaryColor,
                                controller: _passwordController,
                                style: TextStyle(
                                    color: theme
                                        .primaryColorLight), 
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Lozinka',
                                  labelStyle: TextStyle(
                                      color: theme.hintColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
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
                                    return 'Molimo unesite\nlozinku';
                                  }
                                  if (value.length < 6) {
                                    return 'Lozinka mora imati\nminimalno 6 znakova';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                cursorColor: theme.primaryColor,
                                controller: _confirmPasswordController,
                                style: TextStyle(
                                    color: theme
                                        .primaryColorLight), 
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Potvrdite lozinku',
                                  labelStyle: TextStyle(
                                      color: theme.hintColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
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
                                  if (value != _passwordController.text) {
                                    return 'Lozinke se ne\npodudaraju!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              theme.primaryColor),
                        ),
                        onPressed: _registerUser,
                        child: const Text(
                          'Registriraj se!',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PrivacyPolicyPage()),
                          ); 
                        },
                        child: Text(
                          'Kako koristimo tvoje podatke?',
                          style: TextStyle(
                              color: theme.primaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          );
                        },
                        child: Text(
                          'Već imaš račun? Prijavi se!',
                          style: TextStyle(
                              color: theme.primaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
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

  /// Dispose method
  ///
  /// Overrides the `dispose` method to properly dispose of controller objects
  /// when the widget is removed from the widget tree.
  ///
  /// This method is called when the State object is removed from the tree permanently.
  /// It's used here to dispose of the TextEditingController objects used for email,
  /// username, password, and confirm password fields to free up resources.
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

/// BackgroundPainter Custom Painter
///
/// Paints the background with primary, yellow, and turquoise colors.
class BackgroundPainter extends CustomPainter {
  final ThemeData theme;

  BackgroundPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paintPrimary = Paint()
      ..color = theme.primaryColor
      ..style = PaintingStyle.fill;

    var pathPrimary = Path();
    pathPrimary.moveTo(0, 0);
    pathPrimary.lineTo(size.width, 0);
    pathPrimary.lineTo(size.width, size.height * 0.3);
    pathPrimary.quadraticBezierTo(
        size.width * 0.5, size.height * 0.4, 0, size.height * 0.5);
    pathPrimary.close();
    canvas.drawPath(pathPrimary, paintPrimary);

    final paintYellow = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    var pathYellow = Path();
    pathYellow.moveTo(size.width, 0);
    pathYellow.lineTo(size.width, size.height * 0.12);
    pathYellow.lineTo(size.width * 0.5, 0);
    pathYellow.close();
    canvas.drawPath(pathYellow, paintYellow);

    final paintTurquoise = Paint()
      ..color = const Color.fromARGB(163, 83, 213, 187)
      ..style = PaintingStyle.fill;
    var pathTurquoise = Path();
    pathTurquoise.moveTo(0, size.height);
    pathTurquoise.lineTo(size.width * 0.3, size.height);
    pathTurquoise.lineTo(0, size.height * 0.8);
    pathTurquoise.close();
    canvas.drawPath(pathTurquoise, paintTurquoise);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
