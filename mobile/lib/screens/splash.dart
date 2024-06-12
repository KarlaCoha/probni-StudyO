import 'package:flutter/material.dart';
import 'package:studyo/screens/login.dart';

/// The `Splash` class represents a StatefulWidget for the splash screen of the application.
///
/// This widget is typically displayed when the application is launched and serves as
/// an introduction screen before navigating to the main content of the application.
///
/// To use this widget, simply instantiate it and navigate to it within your app.
///
/// Example:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => Splash()),
/// );
/// ```
class Splash extends StatefulWidget {
  /// Constructs a Splash widget.
  ///
  /// The [key] parameter is used to identify this widget in the widget tree.
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

/// The `_SplashState` class represents the State class for the Splash widget.
///
/// This class manages the state of the Splash widget and is responsible for building
/// the UI elements that make up the splash screen.
class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Navigates to the login screen after a delay of 3 seconds.
    Future.delayed(const Duration(seconds: 3), _routeUser);
  }

  /// Navigates to the login screen.
  void _routeUser() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const Login(),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Custom background painter to create a visually pleasing background.
          CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
            painter: BackgroundPainter(theme: Theme.of(context)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: Center(
                    child: Image.asset(
                      'images/logo.png',
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 30,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'images/pontis-logo.png',
                        width: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipOval(
                      child: Image.asset(
                        'images/mc2-logo.png',
                        width: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipOval(
                      child: Image.asset(
                        'images/tvz-logo.png',
                        width: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
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

    var pathPrimary = Path();
    pathPrimary.moveTo(0, 0);
    pathPrimary.lineTo(size.width, 0);
    pathPrimary.lineTo(size.width, size.height * 0.1);
    pathPrimary.quadraticBezierTo(
        size.width * 0.3, size.height * 0.2, 0, size.height * 0.3);
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

    final paintBlue = Paint()
      ..color = const Color.fromRGBO(61, 165, 217, 01)
      ..style = PaintingStyle.fill;
    var pathBlue = Path();
    pathBlue.moveTo(size.width, size.height);
    pathBlue.lineTo(size.width, size.height * 0.8);
    pathBlue.lineTo(size.width * 0.5, size.height);
    pathBlue.close();
    canvas.drawPath(pathBlue, paintBlue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
