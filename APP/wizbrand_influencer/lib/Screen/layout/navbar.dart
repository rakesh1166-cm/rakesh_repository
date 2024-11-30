import 'package:flutter/material.dart';
import 'package:wizbrand_influencer/Screen/Auth/loginscreen.dart';
import 'package:wizbrand_influencer/Screen/Influencer/Influencerscreen.dart';
import 'package:wizbrand_influencer/Screen/Influencer/influencerstatics.dart';
import 'package:wizbrand_influencer/view_modal/Login_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../Influencer/becomeinfluencer.dart';
import '../Influencer/dashboard.dart';
import '../Influencer/influencer_wallet.dart';
import '../Influencer/taskboard.dart';
import '../Influencer/taskstatus.dart';

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

  // Navigate to a screen if the user is logged in
  void _navigateIfLoggedIn(Widget screen) {
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  // Navigate to public profile regardless of login status
  void _navigateToPublicProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InfluencerScreen()),
    );
  }

  // Functions to navigate to different screens
  void _navigateToDashboard() {
    _navigateIfLoggedIn(DashboardScreen());
  }

  void _navigateToInfluecerstatics() {
    _navigateIfLoggedIn(InfluencerStatics());
  }

  void _navigateToBecomeInfluencer() {
    _navigateIfLoggedIn(TabScreen());
  }

  void _navigateToWorkStatus() {
    _navigateIfLoggedIn(MytaskScreen());
  }

  void _navigateToTaskBoard() {
    _navigateIfLoggedIn(TabDesign());
  }

  void _navigateToInfluencerWallet() {
    _navigateIfLoggedIn(Influencerwallet());
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
                case 'Dashboard':
                  _navigateToDashboard();
                  break;
                case 'Public Profile':
                  _navigateToPublicProfile();
                  break;
                case 'Influencer Statics':
                  _navigateToInfluecerstatics();
                  break;
                case 'Become Influencer':
                  _navigateToBecomeInfluencer();
                  break;
                case 'Work Status':
                  _navigateToWorkStatus();
                  break;
                case 'Task Board':
                  _navigateToTaskBoard();
                  break;
                case 'Influencer Wallet':
                  _navigateToInfluencerWallet();
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
                  value: 'Dashboard',
                  child: Text('Dashboard'),
                ),
                PopupMenuItem<String>(
                  value: 'Public Profile',
                  child: Text('Public Profile'),
                ),
                PopupMenuItem<String>(
                  value: 'Influencer Statics',
                  child: Text('Influencer Statics'),
                ),
                PopupMenuItem<String>(
                  value: 'Become Influencer',
                  child: Text('Become Influencer'),
                ),
                PopupMenuItem<String>(
                  value: 'Work Status',
                  child: Text('Work Status'),
                ),
                PopupMenuItem<String>(
                  value: 'Task Board',
                  child: Text('Task Board'),
                ),
                PopupMenuItem<String>(
                  value: 'Influencer Wallet',
                  child: Text('Influencer Wallet'),
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