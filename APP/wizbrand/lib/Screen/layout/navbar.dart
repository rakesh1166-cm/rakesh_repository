import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Auth/loginscreen.dart';
import 'package:wizbrand/Screen/Influencer/createorg.dart';
import 'package:wizbrand/Screen/Influencer/dashboard.dart';
import 'package:wizbrand/Screen/Influencer/organizationScreen.dart';
import 'package:wizbrand/view_modal/Login_view_model.dart';

class CommonHeader extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const CommonHeader({required this.title, this.actions, this.leading});

  @override
  _CommonHeaderState createState() => _CommonHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CommonHeaderState extends State<CommonHeader> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool isLoggedIn = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if the user is logged in by checking the secure storage
  Future<void> _checkLoginStatus() async {
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    setState(() {
      isLoggedIn = email != null && password != null;
      isLoading = false; // Loading is complete
    });
  }

  // Logout function that clears secure storage and navigates to LoginScreen
  void _logout() async {
    await secureStorage.delete(key: 'email');
    await secureStorage.delete(key: 'password');
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    loginViewModel.logout(context).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  // Navigate to the Create Org screen if the user is logged in
  void _navigateToDashboard() {
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  // Navigate to the Organization screen
  void _navigateToOrganizationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrganizationScreen()),
    );
  }

  // Building the AppBar with a PopupMenuButton
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        if (!isLoading) // Show the popup menu only when loading is complete
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Create_Org':
                  _navigateToDashboard();
                  break;
                case 'Organization':
                  _navigateToOrganizationScreen();
                  break;
                case 'Logout':
                  _logout();
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Create_Org',
                  child: Text('Create Org'),
                ),
                PopupMenuItem<String>(
                  value: 'Organization',
                  child: Text('Organization'), // New option for Organization screen
                ),
                if (isLoggedIn) // Show 'Logout' if logged in
                  PopupMenuItem<String>(
                    value: 'Logout',
                    child: Text('Logout'),
                  ),
              ];
            },
          ),
        if (widget.actions != null) ...widget.actions!,
      ],
      leading: widget.leading,
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}
