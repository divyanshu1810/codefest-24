import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:authenticheck/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterviewServices {
  static Future<List<Map<String, dynamic>>> getMeetings() async {
    try {
      final Uri meetingsUrl = Uri.parse('${Constants.apiBaseUrl}/schedule/get');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // Handle the case where the token is null, you may want to redirect to login or take appropriate action
        print('Error: Token is null');
        return [];
      }

      final http.Response response = await http.get(
        meetingsUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Meetings data: ${response.body}");
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> meetingsData = responseData['meetings'];
        print("meetings data $meetingsData");

        // Ensure each meeting is of type Map<String, dynamic>
        List<Map<String, dynamic>> typedMeetingsData = meetingsData
            .whereType<Map<String, dynamic>>()
            .toList();
        print("typed meetings data ${typedMeetingsData[0]}");

        return typedMeetingsData;
      } else {
        print('Error fetching meeting data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle network or other errors
      print('Error fetching meeting data: $e');
      return [];
    }
  }
}
