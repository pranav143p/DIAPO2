import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NodeMCU Communication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String nodeMCUIpAddress = '192.168.4.172'; // Replace this with your NodeMCU IP
  final int nodeMCUPort = 80; // Replace this with your NodeMCU port

  Future<void> _sendRequest() async {
    try {
      final response = await http.get(Uri.parse('http://$nodeMCUIpAddress:$nodeMCUPort'));

      if (response.statusCode == 200) {
        // Successful response from NodeMCU
        print('Response from NodeMCU: ${response.body}');
        // Handle the response here as needed
      } else {
        // Failed to get response from NodeMCU
        print('Failed to get response from NodeMCU: ${response.statusCode}');
      }
    } catch (e) {
      // Error occurred while sending request
      print('Error sending request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NodeMCU Communication'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _sendRequest,
          child: Text('Send Request to NodeMCU'),
        ),
      ),
    );
  }
}
