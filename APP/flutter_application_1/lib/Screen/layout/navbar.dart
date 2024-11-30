import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Auth/loginscreen.dart';
import 'package:flutter_application_1/Screen/Influencer/cart.dart';
import 'package:flutter_application_1/Screen/Influencer/influencer_work_detail.dart';
import 'package:flutter_application_1/Screen/Influencer/influencerscreen.dart';
import 'package:flutter_application_1/Screen/Influencer/dashboard.dart';
import 'package:flutter_application_1/Screen/Influencer/myorder.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/view_modal/Login_view_model.dart';

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
bool _isLoggedIn = false;
  String? _email;
  @override
 


  @override
  void initState() {
    super.initState();
      Future.microtask(() async {
      Map<String, String?> credentials = await _getCredentials();
      String? email = credentials['email'];
      String? password = credentials['password'];
      if (email != null && password != null) {
        setState(() {
          _isLoggedIn = true;
          _email = email;
        });
        Provider.of<InfluencerViewModel>(context, listen: false).fetchWorkdetail(email);
      }
    });
    _checkLoginStatus();
  }
  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
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

  // Navigate to a screen if the user is logged in
 // Refactor _navigateIfLoggedIn to return a Future<void>
Future<void> _navigateIfLoggedIn(Widget screen) async {
  if (isLoggedIn) {
    // If logged in, navigate to the screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  } else {
    // If not logged in, navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

    void _navigateToInfluencerScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InfluencerScreen()),
      );
    }

    void _navigateToDashboard() {
      _navigateIfLoggedIn(DashboardScreen());
    }

    void _navigateToCartScreen() {
      _navigateIfLoggedIn(CartScreen());
    }

    void _navigateToMyOrderScreen() {
      _navigateIfLoggedIn(MyOrderScreen());
    }

void _navigateToTaskBoardScreen() {
  _navigateIfLoggedIn(MyInfluncerWork()); // Navigate first, then trigger a refresh on return
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
        if (!isLoading) // Show the popup menu only when the loading is complete
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                 case 'Search Influencer':
                _navigateToInfluencerScreen();
                break;
              case 'Dashboard':
                _navigateToDashboard();
                break;
              case 'Cart':
                _navigateToCartScreen();
                break;
              case 'My Order':
                _navigateToMyOrderScreen();
                break;
              case 'Influencer Work Detail':
                _navigateToTaskBoardScreen();
                break;
                case 'Logout':
                  _logout();
                  break;
                case 'Login':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                value: 'Search Influencer',
                child: Text('Search Influencer'),
              ),
              PopupMenuItem<String>(
                value: 'Dashboard',
                child: Text('Dashboard'),
              ),
              PopupMenuItem<String>(
                value: 'Cart',
                child: Text('Cart'),
              ),
              PopupMenuItem<String>(
                value: 'My Order',
                child: Text('My Order'),
              ),
              PopupMenuItem<String>(
                value: 'Influencer Work Detail',
                child: Text('Influencer Work Detail'),
              ),
                isLoggedIn
                    ? PopupMenuItem<String>(
                        value: 'Logout',
                        child: Text('Logout'),
                      )
                    : PopupMenuItem<String>(
                        value: 'Login',
                        child: Text('Login'),
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