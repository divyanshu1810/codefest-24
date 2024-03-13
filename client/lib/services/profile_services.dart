import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:authenticheck/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileServices {
  static Future<Map<String, dynamic>> saveProfile({
    required File? passportImage,
    required File? governmentIdImage,
    required File? resumeFile,
    required String? addressLine1,
    required String? addressLine2,
    required String? phoneNumber,
  }) async {
    try {
      final Uri saveProfileUrl = Uri.parse('https://l4g60t5x-5501.inc1.devtunnels.ms/api/user/addprofile');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };

      final http.MultipartRequest request = http.MultipartRequest('POST', saveProfileUrl);
      request.headers.addAll(headers);

      if (passportImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'passportImage', passportImage.path,
            contentType: MediaType('image', 'jpeg')));
      }

      if (governmentIdImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'governmentIdImage', governmentIdImage.path,
            contentType: MediaType('image', 'jpeg')));
      }

      if (resumeFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'resume', resumeFile.path,
            contentType: MediaType('application', 'pdf')));
      }

      request.fields['addressLine1'] = addressLine1 ?? '';
      request.fields['addressLine2'] = addressLine2 ?? '';
      request.fields['phoneNumber'] = phoneNumber ?? '';

      final http.Response response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        print('Profile saved successfully');
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {'success': true, 'data': responseData};
      } else {
        print(response.body);
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return {'success': false, 'error': errorData['error']};
      }
    } catch (e) {
      print('Error saving profile: $e');
      return {'success': false, 'error': 'Failed to connect to the server.'};
    }
  }
}