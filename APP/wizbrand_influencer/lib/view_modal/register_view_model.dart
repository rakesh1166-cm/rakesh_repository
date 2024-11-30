import 'package:flutter/foundation.dart';

class RegisterViewModel with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> register(String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      // Here you can add your registration logic, e.g., calling an API
      // For demonstration, let's use a dummy delay
      await Future.delayed(Duration(seconds: 2));

      // Assume registration is successful if no exceptions are thrown
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setErrorMessage(e.toString());
    }
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }
}