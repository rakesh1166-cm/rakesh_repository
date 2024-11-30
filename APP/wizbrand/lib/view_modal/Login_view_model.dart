import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wizbrand/Service/Influencer/organization_service.dart';
import 'package:wizbrand/model/search_influencer.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';


class LoginViewModel with ChangeNotifier {
  final OrganizationAPI api;
  final OrganizationViewModel influencerViewModel;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool isLoading = false;
  bool isLoggedIn = false;
  String? errorMessage;
  List<SearchInfluencer> influencers = [];

  LoginViewModel({required this.api, required this.influencerViewModel});

  Future<void> login(String email, String password) async {
   
    if (!_isValidEmail(email)) {
      errorMessage = "Invalid email address";
      notifyListeners();
      return;
    }

    if (!_isValidPassword(password)) {
      errorMessage = "Password must be at least 6 characters";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      bool success = await api.login(email, password);
      if (success) {
        errorMessage = null;
        isLoggedIn = true;
        await _saveCredentials(email, password); // Save credentials
      } else {
        errorMessage = "Invalid email or password";
      }
    } catch (e) {
      errorMessage = "An error occurred";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await secureStorage.delete(key: 'email');
    await secureStorage.delete(key: 'password');
    await secureStorage.delete(key: 'orgRoleId'); // Delete orgRoleId
    await secureStorage.delete(key: 'orgUserId'); // Delete orgRoleId
    await secureStorage.delete(key: 'orgUserorgId'); // Delete orgRoleId
    await secureStorage.delete(key: 'userName'); // Delete orgRoleId
   
       
    isLoggedIn = false;
    notifyListeners();
   
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged out successfully')),
    );
    Navigator.pushReplacementNamed(context, '/'); // Redirect to main screen
  }

  Future<void> checkLoginStatus() async {
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    if (email != null && password != null) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailRegExp.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  Future<void> _saveCredentials(String email, String password) async {
    try {
      await secureStorage.write(key: 'email', value: email);
      await secureStorage.write(key: 'password', value: password);
    } catch (e) {
      throw Exception("Failed to save credentials");
    }
  }
}