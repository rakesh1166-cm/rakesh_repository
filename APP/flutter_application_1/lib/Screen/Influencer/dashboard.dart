import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Influencer/filtertask.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../../view_modal/influencer_view_model.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with NavigationMixin<DashboardScreen> {
  bool _isLoggedIn = false;
  String? _email;

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
        Provider.of<InfluencerViewModel>(context, listen: false).fetchOrder(email);
      }
    });
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  void _navigateToInfluencerFilterTask() {
    if (_email != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FilterTask(email: _email!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final influencerViewModel = Provider.of<InfluencerViewModel>(context);
    final taskSummary = influencerViewModel.taskSummary;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This line removes the back arrow
        backgroundColor: Colors.blue, // Set the background color to blue
        centerTitle: true,
        title: Text('Wizbrand', style: TextStyle(color: Colors.white)), // Set the title text color to white
      ),
      body: Stack(
        children: [
          buildBaseScreen(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              children: <Widget>[
  _buildDashboardItem(
      Icons.assignment, 
      'Total Order', 
      Colors.red, 
      taskSummary?.totalOrderCount.toString() ?? '-'
  ),
  _buildDashboardItem(
      Icons.assignment_late, 
      'No of Pending Order', 
      Colors.blue, 
      (taskSummary?.totalOrderCount != null && taskSummary?.completeOrder != null) 
          ? (taskSummary!.totalOrderCount - taskSummary.completeOrder).toString() 
          : '-'
  ),
  _buildDashboardItem(
      Icons.assignment_turned_in, 
      'No of Complete Order', 
      Colors.green, 
      taskSummary?.completeOrder.toString() ?? '-'
  ),
  _buildDashboardItem(
      Icons.monetization_on, 
      'Completed Payment', 
      Colors.red, 
      taskSummary?.completedSum.toString() ?? '-'
  ),
],
              ),
            ),
            currentIndex: 0, // Set the current index accordingly
            title: 'Dashboard',
          ),
          Positioned(
            bottom: 66.0,
            left: MediaQuery.of(context).size.width / 2 - 100, // Center the button
            child: FloatingActionButton.extended(
              onPressed: _navigateToInfluencerFilterTask,
              label: Text(
                'Filter Publisher Task',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(IconData icon, String title, Color color, String value) {
    String displayTitle = '$title ($value)';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Add navigation or other actions here
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 40.0,
                color: color,
              ),
              SizedBox(height: 8.0),
              Text(
                displayTitle,
                style: TextStyle(
                  fontSize: 14.0, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ],
          ),
        ),
      ),
    );
  }
}