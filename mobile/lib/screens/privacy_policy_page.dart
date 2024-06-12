import 'package:flutter/material.dart';
import '../styles/themes.dart'; // Assuming themes are defined here

/// A StatefulWidget representing the Privacy Policy page.
///
/// This page displays the privacy policy information to the user. It includes
/// information about data collection, usage, and protection. The page is designed
/// to inform users about their privacy rights and reassure them about the
/// confidentiality of their data.
class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

/// The State class for the PrivacyPolicyPage widget.
///
/// This class manages the state of the PrivacyPolicyPage widget. It builds
/// the UI and handles user interactions, such as navigating back from the page.
class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    // Determine the theme based on the brightness of the current theme
    ThemeData theme = Theme.of(context).brightness == Brightness.dark
        ? darkTheme
        : lightTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background painter for visual appeal
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        // Back button to navigate to the previous page
                        IconButton(
                          icon:
                              Icon(Icons.arrow_back, color: theme.primaryColor),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Spacer(),
                        // Application logo for branding
                        Image.asset(
                          'images/logo.png',
                          height: 100,
                          width: 150,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Text content describing the privacy policy
                    RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 21, 161, 133),
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Hello, StudyO Buddy!\n\n'),
                          TextSpan(
                            text:
                                'To improve your experience and StudyO itself, please share additional information about yourself. We use this data exclusively to customize quizzes and enhance the application. Your privacy is important to us and will be fully protected. Thank you for helping us make StudyO better for everyone!',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the background of the PrivacyPolicyPage.
///
/// This class defines a custom painter for the background of the PrivacyPolicyPage.
/// It creates a visually appealing background with gradient colors.
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
