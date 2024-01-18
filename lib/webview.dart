import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jackboxautovip/widgets/WebViewWidget.dart';

class WebView extends StatelessWidget {
  final String roomCode;
  final String username;

  WebView({required this.roomCode, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyWebViewWidget(
        roomCode: roomCode,
        username: username,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

}