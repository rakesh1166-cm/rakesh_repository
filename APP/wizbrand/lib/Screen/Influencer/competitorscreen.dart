import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/createcompetitor.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/model/competitor.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CompetitorScreen extends StatefulWidget {
  final String orgSlug;

  CompetitorScreen({required this.orgSlug});

  @override
  _CompetitorScreenState createState() => _CompetitorScreenState();
}

class _CompetitorScreenState extends State<CompetitorScreen> with DrawerMixin, RoleMixin, NavigationMixin {
  String _userRole = ''; // Variable to store the role for AppBar
TextEditingController _searchController = TextEditingController();
 String _userName = ''; // Variable to store the user's name

List<Competitor> _filteredCompetitors = []; // List to hold filtered competitors
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
      await organizationViewModel.getCompetitor(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());
      _filteredCompetitors = organizationViewModel.my_competitors; // Initialize with full data
    }
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }


void _filterCompetitors(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final allCompetitors = organizationViewModel.my_competitors;

    setState(() {
      _filteredCompetitors = allCompetitors.where((competitor) {
        final competitorNameLower = competitor.name?.toLowerCase() ?? '';
        final competitorUrlLower = competitor.website?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();
        return competitorNameLower.contains(queryLower) || 
               competitorUrlLower.contains(queryLower);
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
          : buildBaseScreen(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                     if (_userRole != 'User')
                    ElevatedButton(
                      onPressed: () {
                        _showCreateCompetitorDialog(context);
                      },
                      child: Text('Add New Competitor URL'),
                    ),
                                      Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search by Competitor Name or URL',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        _filterCompetitors(value); // Call filter method on text change
                      },
                    ),
                  ),
                              SizedBox(height: 20),
                    Expanded(
                      child: _filteredCompetitors.isEmpty // Check filtered competitors
                          ? Center(child: Text('No Competitors found for this organization'))
                          : ListView.builder(
                              itemCount: _filteredCompetitors.length,
                          itemBuilder: (context, index) {
                            final competitorData = _filteredCompetitors[index];

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
                                        Text(
                                          'Competitor URL: ${competitorData.website?? 'No URL provided'}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Competitor Name: ${competitorData.name ?? 'No Name provided'}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                           SizedBox(height: 8),
                                        Text(
                                          'Project Name: ${competitorData.projectName ?? 'No Name provided'}',
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
                                            IconButton(
                          icon: Icon(Icons.visibility, color: Colors.green),
                          onPressed: () {
                            _showCompetitorDetailsDialog(competitorData); // View details
                          },
                          tooltip: 'View Details',
                        ),
                                    if (_userRole != 'User')
                                            IconButton(
                                              icon: Icon(Icons.edit, color: Colors.blue),
                                              onPressed: () {
                                                _showEditCompetitorDialog(context, competitorData);
                                              },
                                              tooltip: 'Edit Competitor',
                                            ),
                                              if (_userRole != 'Manager' && _userRole != 'User') 
                                            IconButton(
                                              icon: Icon(Icons.delete, color: Colors.red),
                                              onPressed: () {
                                                _showDeleteCompetitorDialog(context, competitorData);
                                              },
                                              tooltip: 'Delete Competitor',
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
            title: 'Competitor Details', // Set the title as needed
            ),



    );
  }
void _showCompetitorDetailsDialog(Competitor competitor) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Competitor Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                'Competitor Name: ${competitor.name ?? 'No Name Provided'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10), // Space between items
              Text(
                'Website: ${competitor.website ?? 'No URL Provided'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Project Name: ${competitor.projectName ?? 'No Project Name Provided'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              // Add more fields as necessary
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  // Method to display a dialog for creating a new Competitor URL
  void _showCreateCompetitorDialog(BuildContext context) async {
    final secureStorage = FlutterSecureStorage();
    final orgRoleId = await secureStorage.read(key: 'orgRoleId');
    final orgUserId = await secureStorage.read(key: 'orgUserId');
    final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateCompetitorUrlDialog(
          orgSlug: widget.orgSlug,
          orgRoleId: orgRoleId!,
          orgUserId: orgUserId!,
          orgUserorgId: orgUserorgId!,
        ); // Passing the orgSlug
      },
    );
  }

void _showEditCompetitorDialog(BuildContext context, dynamic competitorData) async {
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

  print("inside editcompetitorurl dialog coming");
  
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateCompetitorUrlDialog(
        orgSlug: widget.orgSlug,
        orgRoleId: orgRoleId!,
        orgUserId: orgUserId!,
        orgUserorgId: orgUserorgId!,
        competitorid: competitorData.id.toString(), // Convert int to String here
        projectName: competitorData.projectName, // Convert int to String here
        projectId: competitorData.projectId.toString(), //i Convert int to String here
        initialName: competitorData.name,
        initialWebsite: competitorData.website,
        initialFacebook: competitorData.facebook,
        initialTwitter: competitorData.twitter,
        initialInstagram: competitorData.instagram,
        initialYoutube: competitorData.youtube,
        initialLinkedin: competitorData.linkedin,
        initialPinterest: competitorData.pinterest,
        initialReddit: competitorData.reddit,
        initialTiktok: competitorData.tiktok,
      );
    },
  );
}

  // Method to display a dialog for deleting a competitor
  void _showDeleteCompetitorDialog(BuildContext context, dynamic competitorData) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Competitor'),
          content: Text('Are you sure you want to delete this competitor?'),
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
       await organizationViewModel.deleteCompetitor(competitorData.id.toString()); // Assuming deleteCompetitor method takes an ID
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