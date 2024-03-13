import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';


class MeetingPrepPage extends StatefulWidget {
  @override
  _MeetingPrepPageState createState() => _MeetingPrepPageState();
}

class _MeetingPrepPageState extends State<MeetingPrepPage> {
  @override
  void initState() {
    Permission.camera.request();
    Permission.microphone.request();
    super.initState();
    _startAlertTimer();
  }

  void _startAlertTimer() {
    const duration = Duration(seconds: 2000);
    Timer.periodic(duration, (Timer timer) {
      _showAlert();
    });
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('This is your alert message.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting Preparation'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 750,
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri('https://clocktantra-sockets-production.up.railway.app/room.html?room=48b6b8e9b', forceToStringRawValue: false),
                ),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    cacheEnabled: false,
                    transparentBackground: true,
                    useOnDownloadStart: true,

                  ),
                ),
                onLoadStart: (controller, url) {
                  // Add any logic you need when the page starts loading
                },
                onLoadStop: (controller, url) {
                  // Add any logic you need when the page finishes loading
                },
                onDownloadStart: (controller, url) async {
                  // Add any logic you need when a download starts
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}
