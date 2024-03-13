import 'package:authenticheck/views/screens/feedback_page.dart';
import 'package:authenticheck/views/screens/meeting_page.dart';
import 'package:authenticheck/views/screens/meetingprep_page.dart';
import 'package:authenticheck/views/screens/profile_page.dart';
import 'package:authenticheck/views/screens/schedule_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:authenticheck/views/screens/login_page.dart';
import 'package:authenticheck/views/screens/signup_page.dart';
import 'package:authenticheck/views/screens/interviews_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance(); // Initialize shared preferences
  await Permission.camera.request(); // Request camera permission
  await Permission.microphone.request(); // Request microphone permission
  //Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuthentiCheck',
      home: FutureBuilder<bool>(
        future: checkIfLoggedIn(), // Check if the user is logged in
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Still waiting for the future to complete
            return CircularProgressIndicator();
          } else {
            if (snapshot.data == true) {
              // User is logged in, navigate to InterviewsPage
              return InterviewsPage();
            } else {
              // User is not logged in, navigate to LoginPage
              return LoginPage();
            }
          }
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/interviews': (context) => InterviewsPage(),
        '/schedule': (context) => SchedulePage(),
        '/meeting': (context) => MeetingPage(meetingCode: 'abcdef',name: 'vish'),
        '/meetingPrep': (context) => MeetingPrepPage(),
        '/profile': (context) => ProfilePage(),
        '/feedback' :(context) => FeedbackPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }

  Future<bool> checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('email');

    // Check if email is present in shared preferences
    if (userEmail != null && userEmail.isNotEmpty) {
      return true; // User is logged in
    } else {
      return false; // User is not logged in
    }
  }
}