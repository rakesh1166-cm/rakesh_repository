import 'package:flutter/material.dart';
import 'package:wizbrand_influencer/Screen/Auth/activation.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand_influencer/view_modal/influencer_view_model.dart'; // Replace with your actual view model import

import 'dart:async';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
  
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  Text('Remember me.'),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text('Learn more', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String name = _nameController.text.trim();
                    String email = _emailController.text.trim();
                    bool rememberMe = _rememberMe;

                    // Call your view model method to register the user
                    await Provider.of<InfluencerViewModel>(context, listen: false)
                        .registerUser(name, email, rememberMe);

                    // Display success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Check your email for activation link.'),
                      ),
                    );

                    // Optionally handle navigation or other UI updates after registration
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}