import 'package:flutter/material.dart';
import '../styles/themes.dart';
import '../services/user_service.dart';
import 'verification_questions.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';

/// EmailVerificationPage Widget
///
/// Represents the page for verifying the user's email address.
class EmailVerificationPage extends StatefulWidget {
  final String email; // Email address of the user
  final String password; // Password of the user

  const EmailVerificationPage(
      {Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

/// State class for the EmailVerificationPage widget.
class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _codeControllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed.
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Verifies the entered verification code.
  Future<void> _verifyCode() async {
    final userService = UserService();

    if (_formKey.currentState!.validate()) {
      // Concatenate the entered code from all text fields
      String verificationCode =
          _codeControllers.map((controller) => controller.text).join();
      // Call the method to verify the email address
      bool verificationSuccess =
          await userService.verifyEmail(widget.email, verificationCode);

      if (verificationSuccess) {
        // If verification is successful, attempt to log in the user
        bool loginSuccess =
            await loginUserAfterVerification(widget.email, widget.password);

        if (loginSuccess) {
          // If login is successful, update the user information and navigate to GameStats page
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.user =
              await userService.loginUser(widget.email, widget.password);

          // Print the user information
          print('User: ${userProvider.user}');

          // Navigate to GameStats page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameStats(),
            ),
          );
        } else {
          // If login is unsuccessful
          // Handle the situation
        }
      } else {
        // If verification is unsuccessful, show a snackbar with a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed. Please try again.')),
        );
      }
    }
  }

  /// Attempts to log in the user after email verification.
  Future<bool> loginUserAfterVerification(String email, String password) async {
    final userService = UserService();
    final user = await userService.loginUser(email, password);

    if (user != null) {
      // If login is successful
      return true;
    } else {
      // If login is unsuccessful
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the theme based on the brightness of the context
    ThemeData theme = Theme.of(context).brightness == Brightness.dark
        ? darkTheme
        : lightTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background CustomPaint widget for decoration
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
                    children: [
                      // Header section with back button and logo
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back,
                                color: theme.primaryColor),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Spacer(),
                          Image.asset(
                            'images/logo.png',
                            height: 100,
                            width: 150,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Text displaying the purpose of the verification code
                      Text(
                        'Verifikacijski kod',
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.hintColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 15),
                      // Text explaining the verification process
                      Text(
                        'Još samo malo i postat ćeš dio Studyja! \nUnesi 6-znamenkasti kod koji smo ti poslali na email. Brzo ćemo te verificirati!',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.hintColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 40,
                            height: 65,
                            child: TextFormField(
                              controller: _codeControllers[index],
                              decoration: InputDecoration(
                                counterText: '',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: theme.hintColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: theme.hintColor),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '';
                                }
                                return null;
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              theme.primaryColor),
                        ),
                        onPressed: _verifyCode,
                        child: const Text(
                          'Verificiraj me!',
                          style: TextStyle(color: Colors.white),
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
}

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
