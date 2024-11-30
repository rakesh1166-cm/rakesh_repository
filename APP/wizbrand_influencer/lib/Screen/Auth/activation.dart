import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActivationScreen extends StatefulWidget {
  final String token;

  ActivationScreen({required this.token});

  @override
  _ActivationScreenState createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> activateUser(String token) async {
    var url = "YOUR_BACKEND_URL/api/activate";
    var body = jsonEncode({
      "token": token,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Activation successful!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Activation failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activate Account'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Click the button below to activate your account.'),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await activateUser(widget.token);
                },
                child: Text('Activate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}