import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/createpagerank.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/model/page.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class PageRank extends StatefulWidget {
  final String orgSlug;

  PageRank({required this.orgSlug});

  @override
  _PageRankState createState() => _PageRankState();
}

class _PageRankState extends State<PageRank> with DrawerMixin, RoleMixin, NavigationMixin { 
  String _userRole = ''; // Variable to store the role for AppBar
     TextEditingController _searchController = TextEditingController();
     List<PageRanking> _filteredPageData = []; // List to hold filtered page data
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
      await organizationViewModel.getPageranking(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());
      _filteredPageData = organizationViewModel.my_page; // Initialize with full data
    }
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }
void _filterPageData(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final allPageData = organizationViewModel.my_page;

    setState(() {
      _filteredPageData = allPageData.where((pageData) {
        final projectNameLower = pageData.projectName?.toLowerCase() ?? '';
        final urlLower = pageData.url?.toLowerCase() ?? ''; // Adjust as needed for the URL field
        final queryLower = query.toLowerCase();

        return projectNameLower.contains(queryLower) || 
               urlLower.contains(queryLower);
      }).toList();
    });
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
                            _showCreatePageRankDialog(context);
                          },
                          child: Text('Create New Page Rank'),
                        ),
                        Padding(
  padding: const EdgeInsets.all(8.0),
  child: TextField(
    controller: _searchController,
    decoration: InputDecoration(
      labelText: 'Search by Project Name or URL',
      border: OutlineInputBorder(),
      prefixIcon: Icon(Icons.search),
    ),
    onChanged: (value) {
      _filterPageData(value); // Call filter method on text change
    },
  ),
),
                        SizedBox(height: 20),
                        Expanded(
                         child: _filteredPageData.isEmpty // Check filtered page data
                              ? Center(child: Text('No URLs found'))
                              : ListView.builder(
                                  itemCount: _filteredPageData.length,
                                itemBuilder: (context, index) {
                                  final pageRankData = _filteredPageData[index];

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
                                                    'ID: ${pageRankData.id ?? 'N/A'}',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Project Name: ${pageRankData.projectName ?? 'No Project Name'}',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            // Web URL
                                            GestureDetector(
                                              onTap: () {
                                                // Handle URL click if needed
                                              },
                                              child: Text(
                                                'Web URL: ${pageRankData.url ?? 'No URL'}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blue,
                                                  decoration: TextDecoration.underline),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Wrap(
                                              spacing: 6.0,
                                              runSpacing: 6.0,
                                              children: [
                                                _buildTag('Google Page Rank: ${pageRankData.pageRank ?? 'N/A'}'),
                                                _buildTag('Page Authority: ${pageRankData.authority ?? 'N/A'}'),
                                                _buildTag('Google S Page Placement: ${pageRankData.gSPlace ?? 'N/A'}'),
                                                _buildTag('B S Page Placement: ${pageRankData.bSPlace ?? 'N/A'}'),
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
                                                    _showEditPageRankDialog(context, pageRankData);
                                                  },
                                                  tooltip: 'Edit Page Rank Data',
                                                ),
                                                  if (_userRole != 'Manager' && _userRole != 'User') 
                                                IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () {
                                                    _showDeletePageRankDialog(context, pageRankData);
                                                  },
                                                  tooltip: 'Delete Page Rank Data',
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
                title: 'Pagerank', // Set the title as needed
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

  // Method to display a dialog for creating a Page Rank entry
  void _showCreatePageRankDialog(BuildContext context) async {
    final secureStorage = FlutterSecureStorage();
    final orgRoleId = await secureStorage.read(key: 'orgRoleId');
    final orgUserId = await secureStorage.read(key: 'orgUserId');
    final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreatePagerankDialog(
          orgSlug: widget.orgSlug,
          orgRoleId: orgRoleId!,
          orgUserId: orgUserId!,
          orgUserorgId: orgUserorgId!,
        ); // Passing the orgSlug
      },
    );
  }

  // Method to display a dialog for editing a Page Rank entry
 void _showEditPageRankDialog(BuildContext context, dynamic pageRankData) async {

  print("my pagerankdialog is coming");  
  
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
 
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreatePagerankDialog(
        orgSlug: widget.orgSlug,
        orgRoleId: orgRoleId!,
        orgUserId: orgUserId!,
        orgUserorgId: orgUserorgId!,      
        pageid: pageRankData.id.toString(),
        projectId: pageRankData.projectId.toString(),
        projectName: pageRankData.projectName,
        url: pageRankData.url,
         selectedUrlId: pageRankData.urlId.toString(), // Pass the selected URL ID
        pagerank: pageRankData.pageRank?.toString(),
        authority: pageRankData.authority?.toString(),
        gsplace: pageRankData.gSPlace?.toString(),
        bsplace: pageRankData.bSPlace?.toString(),
      );
    },
  );
}


  // Method to display a dialog for deleting a Page Rank entry
  void _showDeletePageRankDialog(BuildContext context, dynamic pageRankData) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Page Rank Data'),
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
       await organizationViewModel.deletePageRank(pageRankData.id.toString()); // Assuming deletePageRank method takes an ID
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