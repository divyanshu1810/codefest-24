import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class MeetingPage extends StatefulWidget {
  final String meetingCode;
  final String name;

  MeetingPage({required this.meetingCode, required this.name});

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  late InAppWebViewController? webView;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  void _requestPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  @override
  Widget build(BuildContext context) {
    String url = "https://clocktantra-sockets-production.up.railway.app/room.html?room=${widget.meetingCode}&name=${widget.name}";

    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting Page'),
      ),
      body: Container(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(url)),
          onWebViewCreated: (InAppWebViewController controller) {
            webView = controller;
          },


          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
          },
        ),
      ),
    );
  }
}
