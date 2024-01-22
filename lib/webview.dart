import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebView extends StatelessWidget {
  InAppWebViewController? webController;
  final String roomCode;
  final String username;

  WebView({required this.roomCode, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse('https://jackbox.tv/'))),
        onWebViewCreated: (InAppWebViewController controller) {
          webController = controller;
        },
        onLoadStop: (controller, url) async {
          while (await controller.evaluateJavascript(source: 'document.getElementById("button-join").disabled') == true)
          {
            // Input the room code into the text box
            await controller.evaluateJavascript(source: 'document.getElementById("roomcode").value = "$roomCode";');

            // Input the username into the text box
            await controller.evaluateJavascript(source: 'document.getElementById("username").value = "$username";');

            // Send a input event to the textbox to force it to update
            await controller.evaluateJavascript(source: 'document.getElementById("roomcode").dispatchEvent(new Event(\'input\', { bubbles: true }));');

            // Wait a bit
            sleep(const Duration(milliseconds: 100));

            print("trying to connect");
          }
          await controller.evaluateJavascript(source: 'document.getElementById("button-join").click()');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

}