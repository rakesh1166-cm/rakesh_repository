import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/createweb.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/model/webrating.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class WebScreen extends StatefulWidget {
  final String orgSlug;

  WebScreen({required this.orgSlug});

  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> with DrawerMixin, RoleMixin, NavigationMixin { 
  String _userRole = ''; // Variable to store the role for AppBar
 String _userName = ''; // Variable to store the user's name
  TextEditingController _searchController = TextEditingController();
List<WebRatings> _filteredWebData = []; // List to hold filtered web data
   Map<String, List<WebRatings>> memberDataMap = {};
  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch organization data when the screen initializes
  }

final List<String> teamMembers = [
"Alexa Global",
      "Alexa USA",
      "Domain",
      "Alexa India",
      "Backlinks",
      "Referring Domain"
];
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
      await organizationViewModel.getWebRating(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());
      _filteredWebData = organizationViewModel.my_website; // Initialize with full data
   _populateMemberDataMap();
    }
  }

void _populateMemberDataMap() {
  // Clear the existing data
  memberDataMap.clear();

  // Loop through the defined team members
  for (var member in teamMembers) {
    // Filter web data based on the project names that match the member
    memberDataMap[member] = _filteredWebData.where((data) {
      // Adjust this logic based on your requirements
      return data.projectName != null && data.projectName!.contains(member);
    }).toList();
  }
}
void _filterWebData(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final allWebData = organizationViewModel.my_website;

    setState(() {
      _filteredWebData = allWebData.where((webData) {
        final projectNameLower = webData.projectName?.toLowerCase() ?? '';
        final urlLower = webData.domain?.toLowerCase() ?? ''; // Adjust as needed for the URL field
        final queryLower = query.toLowerCase();

        return projectNameLower.contains(queryLower) || 
               urlLower.contains(queryLower);
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
                       
                                          Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search by Project Name or Domain',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        _filterWebData(value); // Call filter method on text change
                      },
                    ),
                  ),
                   if (_userRole != 'User') 
                        ElevatedButton(
                          onPressed: () {
                            _showCreateWebRankingDialog(context);
                          },
                          child: Text('Create New Web Ranking'),
                        ),
                        SizedBox(height: 20),
                         _buildDynamicButtons(), // Dynamic buttons for team members
                        Expanded(
                       child: _filteredWebData.isEmpty // Check filtered web data
                              ? Center(child: Text('No Web ranking found'))
                              : ListView.builder(
                                  itemCount: _filteredWebData.length,
                                itemBuilder: (context, index) {
                                  final webdata = _filteredWebData[index];

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
                                            // ID
                                            Text(
                                              'ID: ${webdata.id ?? 'N/A'}',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 8),
                                            
                                            // Date
                                            Text(
                                              'Date: ${webdata.createdAt ?? 'N/A'}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 8),

                                            // Project Name
                                            Text(
                                              'Project Name: ${webdata.projectName ?? 'No Project Name'}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 8),

                                            // Displaying Web Ranking details using Wrap to avoid overflow
                                            Wrap(
                                              spacing: 6.0,
                                              runSpacing: 6.0,
                                              children: [
                                                _buildTag('Domain Authority: ${webdata.domain ?? 'N/A'}'),
                                                _buildTag('Alexa Global: ${webdata.globalRank ?? 'N/A'}'),
                                                _buildTag('Alexa USA: ${webdata.usaRank ?? 'N/A'}'),
                                                _buildTag('Alexa India: ${webdata.indiaRank ?? 'N/A'}'),
                                                _buildTag('Backlinks: ${webdata.backlinks ?? 'N/A'}'),
                                                _buildTag('Referring Domains: ${webdata.refer ?? 'N/A'}'),
                                              ],
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
                                                    _showEditWebRankingDialog(context, webdata);
                                                  },
                                                  tooltip: 'Edit Web Ranking',
                                                ),
                                                  if (_userRole != 'Manager' && _userRole != 'User') 
                                                IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () {
                                                    _showDeleteWebRankingDialog(context, webdata);
                                                  },
                                                  tooltip: 'Delete Web Ranking',
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
            title: 'Webranking', // Set the title as needed


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
 // Method to build the dynamic buttons below the search bar
Widget _buildDynamicButtons() {
  _populateMemberDataMap(); // Call this to ensure the map is populated before displaying buttons

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: teamMembers.map((memberName) {
        return GestureDetector(
          onTap: () {
            _showDetailsDialog(memberName); // Call to show details dialog
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: EdgeInsets.only(right: 8), // Spacing between buttons
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              memberName,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

// Method to show details dialog for a selected project
void _showDetailsDialog(String memberName) {
  // Filter the data based on the selected member name
  List<WebRatings> filteredData = _filteredWebData.where((data) {
    // Check if the memberName matches any relevant fields in the web data
    switch (memberName) {
      case "Alexa Global":
        return data.globalRank != null; // Ensure that global rank is not null
      case "Alexa USA":
        return data.usaRank != null; // Ensure that USA rank is not null
      case "Domain":
        return data.domain != null; // Ensure that domain is not null
      case "Alexa India":
        return data.indiaRank != null; // Ensure that India rank is not null
      case "Backlinks":
        return data.backlinks != null; // Ensure that backlinks are not null
      case "Referring Domain":
        return data.refer != null; // Ensure that referring domains are not null
      default:
        return false; // No matching case
    }
  }).toList();

  // Create a dialog showing details for the selected member
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$memberName Details'),
        content: Container(
          width: double.maxFinite,
          height: 400, // Adjust the height based on your needs
          child: filteredData.isNotEmpty
              ? ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final data = filteredData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Project Name: ${data.projectName ?? 'N/A'}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Domain Authority: ${data.domain ?? 'N/A'}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Alexa Global: ${data.globalRank ?? 'N/A'}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Alexa USA: ${data.usaRank ?? 'N/A'}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Alexa India: ${data.indiaRank ?? 'N/A'}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Backlinks: ${data.backlinks ?? 'N/A'}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Referring Domains: ${data.refer ?? 'N/A'}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Divider(), // Divider between entries for better readability
                        ],
                      ),
                    );
                  },
                )
              : Center(child: Text('No data available for $memberName.')),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}
  // Method to show details dialog for a selected project
 
  // Method to display a dialog for creating a Web Ranking entry
  void _showCreateWebRankingDialog(BuildContext context) async {
    final secureStorage = FlutterSecureStorage();
    final orgRoleId = await secureStorage.read(key: 'orgRoleId');
    final orgUserId = await secureStorage.read(key: 'orgUserId');
    final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateWebDialog(
          orgSlug: widget.orgSlug,
          orgRoleId: orgRoleId!,
          orgUserId: orgUserId!,
          orgUserorgId: orgUserorgId!,
        ); // Passing the orgSlug
      },
    );
  }

void _showEditWebRankingDialog(BuildContext context, dynamic webData) async {
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateWebDialog(
        orgSlug: widget.orgSlug,
        orgRoleId: orgRoleId!,
        orgUserId: orgUserId!,
        orgUserorgId: orgUserorgId!,
        webid: webData.id.toString(),
        projectId: webData.projectId.toString(),
        projectName: webData.projectName,
        domain: webData.domain,
        globalRank: webData.globalRank?.toString(),
        usaRank: webData.usaRank?.toString(),
        indiaRank: webData.indiaRank?.toString(),
        backlinks: webData.backlinks?.toString(),
        referringDomains: webData.refer?.toString(),
      );
    },
  );
}

  // Method to display a dialog for deleting a Web Ranking entry
  void _showDeleteWebRankingDialog(BuildContext context, dynamic webdata) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Web Ranking'),
          content: Text('Are you sure you want to delete this web ranking entry?'),
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
       await organizationViewModel.deleteWeb(webdata.id.toString()); // Assuming deleteCompetitor method takes an ID
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