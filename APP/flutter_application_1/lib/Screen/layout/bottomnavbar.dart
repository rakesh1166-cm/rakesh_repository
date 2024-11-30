import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Auth/loginscreen.dart';
import 'package:flutter_application_1/Screen/Influencer/profilescreen.dart';
import 'package:flutter_application_1/view_modal/Login_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool isLoggedIn = false;
    bool _isLoggedIn = false;
  String? _email;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    setState(() {
      isLoggedIn = email != null && password != null;
    });
    if (email != null && password != null) {
      setState(() {
        _isLoggedIn = true;
        _email = email;
      });
     
    }
  }

  void _handleTap(int index, BuildContext context) {
    if (index == 1) { // Logout/Login section tapped
      if (isLoggedIn) {
        final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
        loginViewModel.logout(context).then((_) {
          setState(() {
            isLoggedIn = false;
          });
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } else if (index == 0) { // Profile section tapped
      if (isLoggedIn) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(userEmail: _email.toString())),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } else {
      widget.onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (index) => _handleTap(index, context),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      backgroundColor: Colors.blue,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
          label: isLoggedIn ? 'Logout' : 'Login',
        ),
      ],
    );
  }
}