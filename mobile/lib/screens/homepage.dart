import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:studyo/entities/user.dart';
import 'package:studyo/providers/user_provider.dart';
import 'package:studyo/services/user_service.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Homepage extends StatefulWidget {
  /// Constructs a MainPage widget.
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

/// Homepage Widget
///
/// This widget represents the home screen of the application.
/// It displays various information such as user rankings, points, and daily goals.
class _HomepageState extends State<Homepage> {
  /// Fetches the list of users from the UserService.
  ///
  /// This function asynchronously retrieves a list of [MyUser] objects from the
  /// UserService. It throws an exception if the data fetching fails.
  Future<List<MyUser>> fetchData() async {
    UserService userService = UserService();

    try {
      return await userService.getUsers();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  /// Fetches the current user data from the UserService.
  ///
  /// This function retrieves the user ID from the UserProvider and uses it to
  /// fetch the corresponding user data from the UserService. It throws an exception
  /// if the user ID is null or if the data fetching fails.
  Future<MyUser> getUserData() async {
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

  /// Refreshes the user data by calling the [getUserData] function.
  ///
  /// This function triggers a state update to refresh the user data.
  Future<void> _refreshUserData() async {
    setState(() {
      getUserData();
    });
  }

  /// Builds a radial gauge widget to display user points.
  ///
  /// This function creates a radial gauge using the Syncfusion Flutter Gauges
  /// package. It takes a [MyUser] object as a parameter to display the user's
  /// points in the gauge.
  Widget buildRadialGauge(MyUser user) {
    return Container(
      width: 150,
      height: 150,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            axisLineStyle: AxisLineStyle(
              thickness: 0.3,
              color: Theme.of(context).hintColor.withOpacity(0.6),
              thicknessUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.bothFlat,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: ((user.points / 150) * 100),
                width: 0.3,
                color: Theme.of(context).hintColor,
                cornerStyle: CornerStyle.bothFlat,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 1500,
              )
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  positionFactor: 0.15,
                  angle: 90,
                  widget: Text(
                    '${user.points}/150',
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).hintColor),
                    textAlign: TextAlign.center,
                  ))
            ])
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshUserData,
      child: Scaffold(
        body: Stack(children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: BackgroundPainter(theme: Theme.of(context)),
          ),
          SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  FutureBuilder<List<MyUser>>(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final List<MyUser> users = snapshot.data!;
                        users.sort((a, b) => b.points.compareTo(a.points));

                        return Container(
                          height: 320,
                          child: buildLeaderboard(users, context),
                        );
                      }
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(children: [
                            Text(
                              'Moji bodovi',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Theme.of(context).primaryColorLight,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            FutureBuilder<MyUser>(
                              future: getUserData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    return buildRadialGauge(snapshot.data!);
                                  } else if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}",
                                        style:
                                            const TextStyle(color: Colors.red));
                                  }
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ]),
                          Column(
                            children: [
                              Text(
                                'Streak',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Theme.of(context).primaryColorLight,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Icon(
                                Icons.local_fire_department_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 80,
                              ),
                              Text(
                                '3',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800),
                              )
                            ],
                          )
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColorDark,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/editor.png',
                            width: MediaQuery.sizeOf(context).width * 0.25,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dnevni cilj rješenih kvizova',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.5,
                                child: SfLinearGauge(
                                  animateRange: true,
                                  animationDuration: 1500,
                                  minimum: 0,
                                  maximum: 3,
                                  showLabels: true,
                                  showTicks: false,
                                  interval: 1,
                                  axisLabelStyle: TextStyle(fontSize: 16),
                                  majorTickStyle: LinearTickStyle(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  axisTrackStyle: const LinearAxisTrackStyle(
                                      thickness: 10,
                                      color: Color.fromRGBO(234, 115, 23, 0.6),
                                      edgeStyle: LinearEdgeStyle.bothCurve),
                                  ranges: [
                                    LinearGaugeRange(
                                      color: Theme.of(context).primaryColor,
                                      startValue: 0,
                                      endValue: 2,
                                      position: LinearElementPosition.cross,
                                      startWidth: 10,
                                      midValue: 10,
                                      endWidth: 10,
                                      edgeStyle: LinearEdgeStyle.bothCurve,
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  )
                ],
              )),
        ]),
      ),
    );
  }

  /// Builds a leaderboard widget to display user rankings.
  ///
  /// This function creates a leaderboard using a list of [MyUser] objects.
  /// It takes the list of users and the build context as parameters to display
  /// the user rankings in a styled container.
  Widget buildLeaderboard(List<MyUser> users, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
      child: Container(
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).primaryColorDark,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Top lista',
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 70,
                        child: Text(
                          '${users[1].firstName} ${users[1].lastName}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          maxLines: 8,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        height: 125,
                        width: 70,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(254, 198, 1, 1),
                              Color.fromARGB(255, 245, 236, 156)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            '2',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        child: Text(
                          '${users[0].firstName} ${users[0].lastName}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          maxLines: 8,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        height: 190,
                        width: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              const Color.fromARGB(255, 253, 207, 147),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            '1',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        child: Text(
                          '${users[2].firstName} ${users[2].lastName}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          maxLines: 8,
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 70,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).hintColor,
                              const Color.fromARGB(255, 192, 236, 230),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            '3',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
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
      ..color = Color.fromARGB(116, 238, 123, 23)
      ..style = PaintingStyle.fill;

    final Paint paintTurquoise = Paint()
      ..shader = LinearGradient(
        colors: [
          theme.hintColor.withOpacity(0.9),
          Color.fromARGB(145, 214, 236, 238)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final Paint paintYellow = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color.fromARGB(179, 251, 247, 211),
          Color.fromRGBO(254, 199, 1, 0.599)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    var pathUpperLeft = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.01, 0)
      ..quadraticBezierTo(
          size.width * 0.55, size.height * 0.2, 0, size.height * 0.450)
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
      ..moveTo(size.width, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.55, size.width,
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
