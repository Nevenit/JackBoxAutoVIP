import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jackboxautovip/webview.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String roomCode = "";

  String serverIp = "";
  int serverPort = 0;

  Timer? pingTimer;
  TcpSocketConnection? socketConnection;

  void messageReceived(String msg) {
    setState(() {
      roomCode = msg;
    });
  }

  void getRoomCode() async {
    if (socketConnection != null) {
      socketConnection!.sendMessage('{"action": "getRoomCode"}');
    }
  }

  void initiateConnection() async {
    socketConnection = TcpSocketConnection(serverIp, serverPort);
    socketConnection!.enableConsolePrint(true);
    bool canConnect = await socketConnection!.canConnect(5000, attempts: 3);
    if (canConnect) await socketConnection!.connect(5000, messageReceived, attempts: 3);
    if (pingTimer != null) {
      pingTimer!.cancel();
    }
    pingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      getRoomCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Server IP',
              ),
              onChanged: (text) {
                serverIp = text;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Server Port',
              ),
              onChanged: (text) {
                serverPort = int.parse(text);
              },
            ),
            const Text(
              'The room code is:',
            ),
            Text(
              roomCode,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Webview()),
                  );
                },
                child: Text("Open Website")
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: initiateConnection,
        tooltip: 'Increment',
        child: const Icon(Icons.accessible_forward),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
