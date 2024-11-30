import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/createkeyword.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/model/keyword.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class KeywordScreen extends StatefulWidget {
  final String orgSlug;

  KeywordScreen({required this.orgSlug});

  @override
  _KeywordScreenState createState() => _KeywordScreenState();
}

class _KeywordScreenState extends State<KeywordScreen> with DrawerMixin, RoleMixin, NavigationMixin {
  String _userRole = ''; // Variable to store the role for AppBar
   String _userName = ''; // Variable to store the user's name


  TextEditingController _searchController = TextEditingController();
List<Keyword> _filteredKeywords = []; // List to hold filtered keywords

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch keyword data when the screen initializes
  }

  Future<void> _fetchData() async {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final credentials = await _getCredentials();
    final email = credentials['email'];
    final orgSlug = widget.orgSlug;
    // Fetch orgRoleId from secure storage and determine the role
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
      await organizationViewModel.getUserFunction(email, orgSlug);
      await organizationViewModel.getKeyword(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());      
      _filteredKeywords = organizationViewModel.my_keywords; // Initialize with full data
    }
    setState(() {}); // Rebuild the widget after fetching data
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

void _filterKeywords(String query) {
  final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
  final allKeywords = organizationViewModel.my_keywords;

  print("allkeywords are there");
  print(allKeywords);

  setState(() {
    _filteredKeywords = allKeywords.where((keyword) {
      final projectNameLower = keyword.projectName?.toLowerCase() ?? '';
      final urlLower = keyword.url?.toLowerCase() ?? '';
      final queryLower = query.toLowerCase();

      // Check if the projectName, url, or any keyword in the 'keyword' list matches the query
      final keywordListMatch = keyword.keyword?.any((k) => k.toLowerCase().contains(queryLower)) ?? false;

      return projectNameLower.contains(queryLower) ||
             urlLower.contains(queryLower) ||
             keywordListMatch;  // Include check for the 'keyword' list
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
          ? Center(child: CircularProgressIndicator())
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
                            _showCreateKeywordDialog(context);
                          },
                          child: Text('Create New Keyword'),
                        ),
                        SizedBox(height: 20),
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
      _filterKeywords(value); // Call filter method on text change
    },
  ),
),
                        Expanded(
                          child: _filteredKeywords.isEmpty
                              ? Center(
                                  child: Text('No keywords found for this organization'),
                                )
                              : ListView.builder(
                                  itemCount: _filteredKeywords.length,
          itemBuilder: (context, index) {
            final keyword = _filteredKeywords[index];

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
                                            // Displaying ID
                                            Text(
                                              'Id: ${keyword.id.toString()}',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 8),

                                            // Project Name
                                            Text(
                                              'Project Name: ${keyword.projectName ?? ''}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 8),

                                            // URL
                                            GestureDetector(
                                              onTap: () {
                                                // Handle URL click if needed
                                              },
                                              child: Text(
                                                'URL: ${keyword.url ?? ''}',
                                                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                              ),
                                            ),
                                            SizedBox(height: 8),

                                            // Displaying Keywords as tags
                                            Wrap(
                                              spacing: 6.0,
                                              runSpacing: 6.0,
                                              children: keyword.keyword != null
                                                  ? keyword.keyword!.map((kw) {
                                                      return Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                        decoration: BoxDecoration(
                                                          color: Colors.purple,
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        child: Text(
                                                          kw,
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      );
                                                    }).toList()
                                                  : [],
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
                                                    _showEditKeywordDialog(context, keyword);
                                                  },
                                                  tooltip: 'Edit Keyword',
                                                ),
                                                  if (_userRole != 'Manager' && _userRole != 'User') 
                                                IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () {
                                                    _showDeleteKeywordDialog(context, keyword);
                                                  },
                                                  tooltip: 'Delete Keyword',
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
            title: 'Keywords', // Set the title as needed

                ),
              ],
            ),
    );
  }

  void _showCreateKeywordDialog(BuildContext context) async {
    final secureStorage = FlutterSecureStorage();
    final orgRoleId = await secureStorage.read(key: 'orgRoleId');
    final orgUserId = await secureStorage.read(key: 'orgUserId');
    final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateKeywordDialog(
          orgSlug: widget.orgSlug,
          orgRoleId: orgRoleId!,
          orgUserId: orgUserId!,
          orgUserorgId: orgUserorgId!,
        );
      },
    );
  }

void _showEditKeywordDialog(BuildContext context, dynamic keyword) async {
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateKeywordDialog(
        orgSlug: widget.orgSlug,
        orgRoleId: orgRoleId!,
        orgUserId: orgUserId!,
        orgUserorgId: orgUserorgId!,
        keywordId: keyword.id.toString(), // Pass the keyword ID for editing
        existingKeywords: keyword.keyword, // Pass existing keywords for editing
        selectedProjectId: keyword.projectId.toString(), // Pass the selected project ID     
        selectedUrlname: keyword.url, // Pass the selected URL ID
        selectedUrlId: keyword.urlId.toString(), // Pass the selected URL ID
      );
    },
  );
}

  void _showDeleteKeywordDialog(BuildContext context, keyword) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Keyword'),
          content: Text('Are you sure you want to delete this keyword?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel action
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
 
 if (confirmed == true) {
      try {
        final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
   final response =   await organizationViewModel.deleteKeyword(context,keyword.id.toString()); // Assuming deleteUrl method takes an ID 
        if (response['success'] == true) {
            print("coming here success");
          _fetchData();
        } else {
          print("comingelse here");
         
        }
      } catch (error) {
       // await _showErrorDialog(context, 'An error occurred while deleting the project.');
      }
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