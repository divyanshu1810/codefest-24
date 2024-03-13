import 'package:authenticheck/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ScheduleServices {
  static Future<Map<String, dynamic>> scheduleInterview(
      DateTime selectedDate,
      TimeOfDay selectedTime,
      String intervieweeName,
      String intervieweeEmail,
      String roleApplied,
      String meetingTitle,
      String otherInterviewers,
      ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print(token);

      if (token == null) {
        // Token not found in shared preferences, handle accordingly
        return {'success': false, 'error': 'Token not available'};
      }

      final Uri scheduleUrl = Uri.parse('${Constants.apiBaseUrl}/schedule/create');

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        // Include any other headers you may need, such as authorization headers
      };

      final Map<String, dynamic> body = {
        'title': meetingTitle, // Assuming meetingTitle corresponds to the interview title
        'time': {
          '\$date': selectedDate.toUtc().toIso8601String(),
          // Format the date as required
        },
        'role': roleApplied,
        'intervieweeEmail': intervieweeEmail,
        'interviewerEmail': 'data',
        // Include any other parameters you need for scheduling
      };
      print(body);

      final http.Response response = await http.post(
        scheduleUrl,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print(response.body);
        print("works scheduled");
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {'success': true, 'data': responseData};
      } else {
        print(response.body);
        // Unsuccessful scheduling
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return {'success': false, 'error': errorData['error']};
      }
    } catch (e) {
      // Error during the HTTP request
      return {'success': false, 'error': 'Failed to connect to the server.'};
    }
  }
}
