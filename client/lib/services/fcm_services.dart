import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingService {
  late BuildContext _context;
  int notificationId = 1;

  void setContext(BuildContext context) {
    _context = context;
  }

  Future<void> configureFirebaseMessaging() async {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message!');
      print('Message data: ${message.data}');
    });

    // Rest of your Firebase Messaging configuration...

  }

  void handleData(Map<String, dynamic> messageData) {
    // Handle data when notification is received
  }

  void handleNavigation(Map<String, dynamic> messageData) {
    // Handle navigation logic based on message data
  }

  Stream<Map<String, dynamic>> get onMessageReceived {
    // Simulate an asynchronous operation by creating a Stream with a single value
    //final fakeData = {'result': 0}; // Replace this with your desired data

    // Return a Stream using Stream.fromIterable
    //return Stream.fromIterable([fakeData]);
    // Uncomment the line below when you want to use FirebaseMessaging.onMessage
    return FirebaseMessaging.onMessage.map((RemoteMessage message) => message.data);
  }
}
