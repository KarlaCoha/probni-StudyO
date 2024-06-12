import 'package:flutter/material.dart';
import 'package:studyo/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

/// PlayChallengePage Widget
///
/// This widget represents the page for displaying challenges to the user. It is a StatefulWidget.
class PlayChallengePage extends StatefulWidget {
  const PlayChallengePage({super.key});

  @override
  _PlayChallengePageState createState() => _PlayChallengePageState();
}

/// State class for the PlayChallengePage widget.
class _PlayChallengePageState extends State<PlayChallengePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() async {
    // Request permissions and get FCM token

    _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );

    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
    // Listen for incoming messages

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message while in foreground: ${message.messageId}');
      if (message.notification != null) {
        _showMessageDialog(message.notification!);
        Map<String, dynamic> data = message.data;
        UserService userService = UserService();
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);

        String? userId = userProvider.user?.id;
        data["senderId"] = userId;
        _addNotificationToList(data);
      }
    });
    // Listen for when a message is clicked

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      if (message.notification != null) {
        _showMessageDialog(message.notification!);
        _addNotificationToList(message.data);
      }
    });
  }

  void _showMessageDialog(RemoteNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title ?? 'No Title'),
        content: Text(notification.body ?? 'No Body'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addNotificationToList(Map<String, dynamic> data) {
    setState(() {
      notifications.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Moji izazovi',
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: CustomPaint(
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Colors.amber,
                    size: 32,
                  ),
                  title: Text(
                    '${notifications[index]["firstName"]} ${notifications[index]["lastName"]} te izaziva na kviz ${notifications[index]["lessonName"]}!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
