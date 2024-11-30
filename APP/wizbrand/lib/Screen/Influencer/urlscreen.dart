import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';
import 'package:wizbrand/Screen/Influencer/createurl.dart';

class UrlScreen extends StatefulWidget {
  final String orgSlug;

  UrlScreen({required this.orgSlug});

  @override
  _UrlScreenState createState() => _UrlScreenState();
}

class _UrlScreenState extends State<UrlScreen> with DrawerMixin, RoleMixin, NavigationMixin {
  String _userRole = ''; // Variable to store the role for AppBar
   String _userName = ''; // Variable to store the user's name
TextEditingController _searchController = TextEditingController();
List<dynamic> _filteredUrls = []; // List to hold filtered URLs
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
    // Fetch additional secure storage parameters
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
      await organizationViewModel.getUrl(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());
      _filteredUrls = organizationViewModel.my_urls; // Initialize with full data
    }
  }

void _filterUrls(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final allUrls = organizationViewModel.my_urls;

    setState(() {
      _filteredUrls = allUrls.where((urlData) {
        final urlLower = urlData.url?.toLowerCase() ?? '';
        final projectNameLower = urlData.projectName?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();

        return urlLower.contains(queryLower) || 
               projectNameLower.contains(queryLower);
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
          : buildBaseScreen(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  

                                        Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search by URL or Project Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          _filterUrls(value); // Call filter method on text change
                        },
                      ),
                    ),
                      if (_userRole != 'User')
                    ElevatedButton(
                      onPressed: () {
                        _showCreateUrlDialog(context);
                      },
                      child: Text('Create New URL'),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                     child: _filteredUrls.isEmpty // Check filtered URLs
                      ? Center(
                          child: Text('No URLs found for this organization'),
                        )
                      : ListView.builder(
                          itemCount: _filteredUrls.length,
                          itemBuilder: (context, index) {
                            final urlData = _filteredUrls[index];
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
                                        // URL
                                        Text(
                                          'Web URL:${urlData.url ?? 'No Url Name'}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Project Name: ${urlData.projectName ?? 'No Project Name'}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),

                                        // Row for edit and delete icons
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [

                                                if (_userRole != 'User') 
                                            IconButton(
                                              icon: Icon(Icons.edit, color: Colors.blue),
                                              onPressed: () {
                                                _showEditUrlDialog(context, urlData);
                                              },
                                              tooltip: 'Edit URL',
                                            ),
                                             if (_userRole != 'Manager' && _userRole != 'User') 
                                            IconButton(
                                              icon: Icon(Icons.delete, color: Colors.red),
                                              onPressed: () {
                                                _showDeleteUrlDialog(context, urlData);
                                              },
                                              tooltip: 'Delete URL',
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
              title: 'Url', // Set the title as needed
            ),
    );
  }

  // Method to display a dialog for creating a new URL
  void _showCreateUrlDialog(BuildContext context) async {
    final secureStorage = FlutterSecureStorage();
    final orgRoleId = await secureStorage.read(key: 'orgRoleId');
    final orgUserId = await secureStorage.read(key: 'orgUserId');
    final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateUrlDialog(
          orgSlug: widget.orgSlug,
          orgRoleId: orgRoleId!,
          orgUserId: orgUserId!,
          orgUserorgId: orgUserorgId!,
        ); // Passing the orgSlug
      },
    );
  }

void _showEditUrlDialog(BuildContext context, dynamic urlData) async {
  // Fetch secure storage data for necessary parameters
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateUrlDialog(
        orgSlug: widget.orgSlug, 
        orgRoleId: orgRoleId!, 
        orgUserId: orgUserId!, 
        orgUserorgId: orgUserorgId!, 
         urlid: urlData.id, // Prepopulate the URL field
        url: urlData.url, // Prepopulate the URL field
        selectedProject: urlData.projectId.toString(), // Prepopulate the selected project
      );
    },
  );

  // Refresh data after editing
  _fetchData();
}
  // Method to display a dialog for deleting a URL
  void _showDeleteUrlDialog(BuildContext context, dynamic urlData) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete URL'),
          content: Text('Are you sure you want to delete this URL?'),
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

    // If confirmed, delete the URL
    if (confirmed == true) {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
       await organizationViewModel.deleteUrl(urlData.id.toString());
      _fetchData(); // Refresh the data after deletion
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