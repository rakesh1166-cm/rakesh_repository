import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import '../../view_modal/organization_view_model.dart';

class DashboardScreen extends StatefulWidget {
  final String orgSlug;
  final int orgRoleId;
  final String orgUserId;
  final String orgUserorgId;

  DashboardScreen({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with NavigationMixin<DashboardScreen>, DrawerMixin<DashboardScreen> {
  bool _isLoggedIn = false;
  String? _email;
  String _userRole = ''; // To store the role (Admin, Manager, User)

  @override
  void initState() {
    super.initState();
    _fetchCredentials(widget.orgRoleId, widget.orgSlug, widget.orgUserId, widget.orgUserorgId);
  }

  Future<void> _fetchCredentials(int orgRoleId, String orgSlug, String orgUserId, String orgUserorgId) async {
    final credentials = await _getCredentials();
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'orgRoleId', value: orgRoleId.toString());
    await secureStorage.write(key: 'orgSlug', value: orgSlug);
    await secureStorage.write(key: 'orgUserId', value: orgUserId);
    await secureStorage.write(key: 'orgUserorgId', value: orgUserorgId);
    print('OrgRoleId saved: $orgRoleId');
    setState(() {
      _email = credentials['email'];
      _isLoggedIn = _email != null;
    });
    if (_email != null && widget.orgSlug.isNotEmpty) {
      _fetchData();
    }
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  Future<void> _fetchData() async {
     final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
  final credentials = await _getCredentials();
  final email = credentials['email'];
  final orgSlug = widget.orgSlug;
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');



    if (email != null && orgSlug.isNotEmpty) {
      await organizationViewModel.getCount(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());
      final result = await organizationViewModel.getUserFunction(email, orgSlug);
      setState(() {
        if (widget.orgRoleId == 1) {
          _userRole = 'Admin';
        } else if (widget.orgRoleId == 2) {
          _userRole = 'Manager';
        } else if (widget.orgRoleId == 3) {
          _userRole = 'User';
        } else {
          _userRole = 'Unknown Role';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context);
    final taskSummary = organizationViewModel.my_task_count;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Wizbrand - $_userRole',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: buildDrawer(context, orgSlug: widget.orgSlug),
   body: Stack(
  children: [
    buildBaseScreen(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: GridView.count(
             crossAxisCount: 2, // Change from 3 to 2 to provide more space for each item
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
           
            shrinkWrap: true, // Ensures the grid only takes up the necessary space
            physics: NeverScrollableScrollPhysics(), // Prevents inner scroll
            children: <Widget>[
              _buildDashboardItem(Icons.person, 'Manager', Colors.orange, taskSummary?.managerCount.toString() ?? '-'),
              _buildDashboardItem(Icons.people, 'Users', Colors.green, taskSummary?.userCount.toString() ?? '-'),
              _buildDashboardItem(Icons.task, 'All Tasks', Colors.red, taskSummary?.taskCount.toString() ?? '-'),
              _buildDashboardItem(Icons.link, 'URL', Colors.blue, taskSummary?.urlCount.toString() ?? '-'),
              _buildDashboardItem(Icons.star, 'Website Ranking', Colors.red, taskSummary?.websiteRanking.toString() ?? '-'),
              _buildDashboardItem(Icons.person_4, 'Team Rating', Colors.cyan, taskSummary?.teamRating.toString() ?? '-'),
              _buildDashboardItem(Icons.task, 'Total Projects', Colors.orange, taskSummary?.totalProjects.toString() ?? '-'),
              _buildDashboardItem(Icons.search, 'Keyword', Colors.purple, taskSummary?.keywordCount.toString() ?? '-'),
            ],
          ),
        ),
      ),
      currentIndex: 0,
      title: 'Dashboard',
    ),
  ],
),
    );
  }

Widget _buildDashboardItem(IconData icon, String title, Color color, String value) {
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
              size: 36.0, // Adjusted icon size for more space
              color: color,
            ),
            SizedBox(height: 6.0),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.0, // Slightly reduced font size
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1, // Limits text to one line
                overflow: TextOverflow.ellipsis, // Ensures text truncates with ellipsis if needed
              ),
            ),
            SizedBox(height: 4.0),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown, // Scales text to fit within the available space
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
