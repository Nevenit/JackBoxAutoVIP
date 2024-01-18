import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyWebViewWidget extends StatefulWidget {
  final String roomCode;
  final String username;

  const MyWebViewWidget({super.key, required this.roomCode, required this.username});

  @override
  _MyWebViewWidget createState() => _MyWebViewWidget();
}

class _MyWebViewWidget extends State<MyWebViewWidget> {
  InAppWebViewController? webController;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse('https://jackbox.tv/'))),
      onWebViewCreated: (InAppWebViewController controller) {
        webController = controller;
      },
      onLoadStop: (controller, url) async {
        // Input the room code into the text box
        await controller.evaluateJavascript(source: 'document.getElementById("roomcode").value = "${widget.roomCode}";');

        // Send a input event to the textbox to force it to update
        await controller.evaluateJavascript(source: 'document.getElementById("roomcode").dispatchEvent(new Event(\'input\', { bubbles: true }));');

        await controller.evaluateJavascript(source: 'document.getElementById("username").value = "${widget.username}";');
        while (await controller.evaluateJavascript(source: 'document.getElementById("button-join").disabled') == true)
          {
            sleep(const Duration(milliseconds: 100));
            //await controller.evaluateJavascript(source: 'document.getElementById("button-join").click()');
            print("trying to connect");
          }
        await controller.evaluateJavascript(source: 'document.getElementById("button-join").click()');
      },
    );
  }

}