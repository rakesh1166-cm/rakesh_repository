import 'package:flutter/material.dart';
import 'package:wizbrand_influencer/Screen/Influencer/filtertask.dart';
import 'package:wizbrand_influencer/Screen/layout/mixins.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand_influencer/view_modal/influencer_view_model.dart';

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
        Provider.of<InfluencerViewModel>(context, listen: false).fetchTask(email);
      }
    });
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  void _navigateToInfluencerFitertask() {
    print("data coming inside _navigateToInfluencerFitertask");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilterTask()),
    );
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
                  _buildDashboardItem(Icons.assignment, 'Total Tasks', Colors.red, taskSummary?.totalOrderCount.toString() ?? '-'),
                  _buildDashboardItem(Icons.assignment_late, 'Pending Tasks', Colors.blue, taskSummary?.pendingOrder.toString() ?? '-'),
                  _buildDashboardItem(Icons.assignment_turned_in, 'Completed Tasks', Colors.green, taskSummary?.completedSum.toString() ?? '-'),
                  _buildDashboardItem(Icons.monetization_on, 'Total Earning', Colors.red, taskSummary?.completedSum.toString() ?? '-'),
                  _buildDashboardItem(Icons.money_off, 'Pending Earning', Colors.blue, taskSummary?.pendingOrder.toString() ?? '-'),
                 _buildDashboardItem(
  Icons.person,
  'Profile',
  Colors.purple,
  '${taskSummary?.completionPercentage ?? '-'}%', // Display percentage
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
              onPressed: _navigateToInfluencerFitertask,
              label: Text(
                'Filter Influencer Task',
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
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
}