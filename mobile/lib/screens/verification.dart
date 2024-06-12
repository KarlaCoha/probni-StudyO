import 'package:flutter/material.dart';
import '../styles/themes.dart';

/// A screen widget for displaying the verification message.
///
/// The `VerificationScreen` widget displays a message informing the user
/// that an email has been sent for verification. It prompts the user to check
/// their email and click on the verification link. This screen is typically
/// shown after a user registration process where email verification is required.
class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

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
              width: 350,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('images/logo.png', height: 100, width: 150),
                  const SizedBox(height: 20),
                  Text(
                    'Poslali smo vam mail. Molimo kliknite na link u mailu kako biste se uspješno verificirali!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: theme.primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A custom painter for creating a visually appealing background.
///
/// The `BackgroundPainter` class creates a custom painter that draws
/// a background with gradient colors. It is used by widgets like `VerificationScreen`
/// to provide a visually appealing background. The gradient colors are determined
/// by the theme provided to the painter.
class BackgroundPainter extends CustomPainter {
  final ThemeData theme;

  /// Constructs a new [BackgroundPainter] instance.
  ///
  /// The [theme] parameter specifies the theme used to determine
  /// the colors of the background gradient.
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
