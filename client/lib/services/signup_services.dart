import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class SignUpServices {
  static Future<Map<String, dynamic>> signUpUser(String name, String email, String password, String role) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $fcmToken');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, String> body = {
      'name': name,
      'password': password,
      'email': email,
      'role': role.toLowerCase(),
      'deviceToken': fcmToken!,
    };

    try {
      print(body);
      final http.Response response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/auth/signup'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("works till here 200");
        // Successful signup
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData['data']);
        // Store the token and role in shared preferences
        await _saveUserDataToPreferences(
          responseData['data']['token'],
          responseData['data']['role'],
          responseData['data']['name'],
          responseData['data']['email']
        );

        return {'success': true, 'role': responseData['data']['role']};
      } else {
        // Unsuccessful signup
        print(response.body);
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return {'success': false, 'error': errorData['error']};
      }
    } catch (e) {
      print(e);
      return {'success': false, 'error': 'Failed to connect to the server.'};
    }
  }

  static Future<void> _saveUserDataToPreferences(String token, String role, String name, String email) async {
    print('Token: $token');
    print('Role: $role');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('role', role);
    prefs.setString('name', name);
    prefs.setString('email', email);
  }

}
