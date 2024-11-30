import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Auth/register.dart';
import 'package:wizbrand/Screen/Influencer/createorg.dart';
import 'package:wizbrand/Screen/Influencer/organizationScreen.dart';
import 'package:wizbrand/Screen/Influencer/dashboard.dart';
import 'package:wizbrand/view_modal/Login_view_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true; // Make this a state variable

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrganizationScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email or Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),

                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword; // Toggle password visibility
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword, // Control text visibility
                    ),
                    
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (value) {}),
                        Text('Remember me.'),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text('Learn more', style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    loginViewModel.isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                             final email = emailController.text.trim(); // Trim extra spaces
                                final password = passwordController.text.trim(); // Trim extra spaces
                              await loginViewModel.login(email, password);
                              if (loginViewModel.errorMessage == null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                );
                              }
                            },
                            child: Text('Continue'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: Size(double.infinity, 50),
                            ),
                          ),
                    if (loginViewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          loginViewModel.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text(
                        'If you are not registered, click here to register',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
