import 'package:flutter/material.dart';
import 'homepage.dart';
import 'play_challenge.dart';
import 'send_challenge.dart';

/// QChallenge Widget
///
/// Represents the main page for selecting between sending challenges to friends
/// or playing challenges.
class QChallenge extends StatelessWidget {
  const QChallenge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen width for adjusting box width
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate the width of the box to be 80% of the screen width
    final boxWidth = screenWidth * 0.8;

    return Scaffold(
      body: Stack(
        children: [
          // Background CustomPaint widget for decoration
          CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
            painter: BackgroundPainter(theme: Theme.of(context)),
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 25),
                      // Container for sending challenges to friends
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SendChallengePage(),
                            ),
                          );
                        },
                        child: Container(
                          width: boxWidth,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('images/marketing.png', height: 150),
                              const SizedBox(height: 5),
                              Text(
                                'Izazovi prijatelja!',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Container for playing challenges
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PlayChallengePage(),
                            ),
                          );
                        },
                        child: Container(
                          width: boxWidth,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('images/message.png', height: 150),
                              const SizedBox(height: 5),
                              Text(
                                'Igraj izazove!',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
