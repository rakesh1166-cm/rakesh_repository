import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/createsocialurl.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/model/socialrank.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';
import 'package:intl/intl.dart';

class SocialRank extends StatefulWidget {
  final String orgSlug;

  SocialRank({required this.orgSlug});

  @override
  _SocialRankState createState() => _SocialRankState();
}

class _SocialRankState extends State<SocialRank> with DrawerMixin, RoleMixin, NavigationMixin { 
  String _userRole = ''; // Variable to store the role for AppBar
TextEditingController _searchController = TextEditingController();
List<SocialRanking> _filteredSocialData = []; // List to hold filtered social data
String _userName = ''; // Variable to store the user's name
  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch organization data when the screen initializes
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
    final username = await secureStorage.read(key: 'userName');

setState(() {
    _userRole = determineUserRole(orgRoleId);
    _userName = username ?? 'User'; // Set the user name or default to 'User'
    print("my role is $_userRole");
  });


   if (email != null && orgSlug.isNotEmpty) {
      await organizationViewModel.getSocialranking(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());
      _filteredSocialData = organizationViewModel.my_social; // Initialize with full data
    }
  }
void _filterSocialData(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final allSocialData = organizationViewModel.my_social;

    setState(() {
      _filteredSocialData = allSocialData.where((socialData) {
        final projectNameLower = socialData.projectName?.toLowerCase() ?? '';
        final fbLikesLower = socialData.fbLikes?.toString().toLowerCase() ?? ''; // Adjust as needed
        final queryLower = query.toLowerCase();

        return projectNameLower.contains(queryLower) || 
               fbLikesLower.contains(queryLower); // Adjust as needed for other fields
      }).toList();
    });
}
  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  @override
  Widget build(BuildContext context) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
       '$_userName - $_userRole', // Display role dynamically in the AppBar
          style: TextStyle(color: Colors.white),
        ),

        actions: buildAppBarActions(context),
      ),
      drawer: buildDrawer(context, orgSlug: widget.orgSlug),
      body: organizationViewModel.isLoading
          ? Center(child: CircularProgressIndicator()) // Display loading indicator while fetching data
          : Stack(
              children: [
                buildBaseScreen(
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                         if (_userRole != 'User')
                        ElevatedButton(
                          onPressed: () {
                            _showCreateSocialRankDialog(context);
                          },
                          child: Text('Create New Social Rank'),
                        ),
                        SizedBox(height: 20),
                               Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Search by Project Name or Social Metrics',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              _filterSocialData(value); // Call filter method on text change
                            },
                          ),
                        ),
                        Expanded(
                           child: _filteredSocialData.isEmpty // Check filtered social data
                              ? Center(child: Text('No data available in table'))
                              : ListView.builder(
                                  itemCount: _filteredSocialData.length,
                                itemBuilder: (context, index) {
                                  final socialRankData = _filteredSocialData[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(color: Colors.grey[300]!),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'ID: ${socialRankData.id ?? 'N/A'}',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              Expanded(
                                            child: Text(
                                              'Date: ${_formatDate(socialRankData.createdAt.toString()) ?? 'N/A'}',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                           ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Project Name: ${socialRankData.projectName ?? 'No Project Name'}',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 8),
                                            Wrap(
                                              spacing: 6.0,
                                              runSpacing: 6.0,
                                              children: [
                                                _buildTag('FB Likes: ${socialRankData.fbLikes ?? 'N/A'}'),
                                                _buildTag('YT Subscribers: ${socialRankData.ytSubs ?? 'N/A'}'),
                                                _buildTag('Twitter Followers: ${socialRankData.twFollower ?? 'N/A'}'),
                                                _buildTag('Instagram Followers: ${socialRankData.instaFollower ?? 'N/A'}'),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                 if (_userRole != 'User')
                                                IconButton(
                                                  icon: Icon(Icons.edit, color: Colors.blue),
                                                  onPressed: () {
                                                    _showEditSocialRankDialog(context, socialRankData);
                                                  },
                                                  tooltip: 'Edit Social Rank Data',
                                                ),
                                                if (_userRole != 'Manager' && _userRole != 'User')
                                                IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () {
                                                    _showDeleteSocialRankDialog(context, socialRankData);
                                                  },
                                                  tooltip: 'Delete Social Rank Data',
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),

                  currentIndex: 0, // Set an appropriate index
                  title: 'Social Ranking', // Set the title as needed
                ),
              ],
            ),
    );
  }

  // Helper method to build tags
  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Method to display a dialog for creating a Social Rank entry
  void _showCreateSocialRankDialog(BuildContext context) async {
           final secureStorage = FlutterSecureStorage();
    final orgRoleId = await secureStorage.read(key: 'orgRoleId');
    final orgUserId = await secureStorage.read(key: 'orgUserId');
    final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateSocialrankDialog(
          orgSlug: widget.orgSlug,
          orgRoleId: orgRoleId!,
          orgUserId: orgUserId!,
          orgUserorgId: orgUserorgId!,
        ); // Passing the orgSlug
      },
    );
  }

void _showEditSocialRankDialog(BuildContext context, SocialRanking socialRankData) async {
  // Fetch the necessary parameters from secure storage
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateSocialrankDialog(
        orgSlug: widget.orgSlug, // Existing parameter
        orgRoleId: orgRoleId!,   // New parameter for role ID
        orgUserId: orgUserId!,   // New parameter for user ID
        orgUserorgId: orgUserorgId!, // New parameter for organization user ID
        projectName: socialRankData.projectName, // Existing project name
        fbLikes: socialRankData.fbLikes, // Existing Facebook likes
        ytSubscribers: socialRankData.ytSubs, // Existing YouTube subscribers
        twitterFollowers: socialRankData.twFollower, // Existing Twitter followers
        instagramFollowers: socialRankData.instaFollower, // Existing Instagram followers
        createdAt: socialRankData.createdAt.toString(), // Existing creation date
        id: socialRankData.id // Pass ID if needed
      );
    },
  );
}

  // Method to display a dialog for deleting a Social Rank entry
  void _showDeleteSocialRankDialog(BuildContext context, dynamic socialRankData) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Social Rank Data'),
          content: Text('Are you sure you want to delete this data entry?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel action
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm action
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      // await organizationViewModel.deleteSocialRank(socialRankData['id']); // Assuming deleteSocialRank method takes an ID
      _fetchData(); // Refresh the data after deletion
    }
  }
String? _formatDate(String? dateString) {
  if (dateString == null) return null;
  try {
    DateTime dateTime = DateTime.parse(dateString);
    // Format to include day as well: 'yyyy-MM-dd'
    return DateFormat('yyyy-MM-dd').format(dateTime);
  } catch (e) {
    print("Error parsing date: $e");
    return null; // Return null if there's an error
  }
}
Widget buildBaseScreen({required Widget body, required int currentIndex, required String title}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Column(
      children: [
        // Optionally, add a title if needed
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: body),
      ],
    ),
  );
}
}