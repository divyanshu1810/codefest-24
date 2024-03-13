import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class LoginServices {
  static Future<Map<String, dynamic>> loginUser(String username, String password) async {

    //String? fcmToken = await FirebaseMessaging.instance.getToken();
   // print('FCM Token: $fcmToken');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, String> body = {
      'email': username,
      'password': password,
      'deviceToken': '123',
    };

    try {
      print(body);
      final http.Response response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/auth/login'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Store token and role in shared preferences
        await _storeTokenAndRole(responseData['data']['token'], responseData['data']['role'], responseData['data']['name'], responseData['data']['email'], '123');

        return {'success': true, 'data': responseData};
      } else {
        print(response.body);
        // Unsuccessful login
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return {'success': false, 'error': errorData['error']};
      }
    } catch (e) {
      // Error during the HTTP request
      return {'success': false, 'error': 'Failed to connect to the server.'};
    }
  }

  static Future<void> _storeTokenAndRole(String token, String role, String name, String email , String fcmToken) async {
    try {
      print ('Token: $token');
      print ('Role: $role');
      print ('Name: $name');
      print ('Email: $email');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setString('role', role);
      prefs.setString('name', name);
      prefs.setString('email', email);
      prefs.setString('deviceToken', fcmToken);
      print("its done");
    } catch (error) {
      print('Error storing token and role: $error');
    }
  }

  static Future<Map<String, dynamic>> logoutUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? fcmToken = prefs.getString('fcmToken');


      if (token != null) {
        final Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };
        final Map<String, dynamic> body = {
          'deviceToken': fcmToken,
        };

        final http.Response response = await http.post(
          Uri.parse('${Constants.apiBaseUrl}/auth/logout'),
          headers: headers,
          body: jsonEncode(body)
        );

        if (response.statusCode == 200) {
          // Clear local storage on successful logout
          await prefs.clear();
          return {'success': true};
        } else {
          await prefs.clear();
          return {'success': true};

          // Unsuccessful logout
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          return {'success': false, 'error': errorData['error']};
        }
      } else {
        // No token found, consider the user as logged out
        return {'success': true};
      }
    } catch (e) {
      // Error during the HTTP request
      return {'success': false, 'error': 'Failed to connect to the server.'};
    }
  }
}
