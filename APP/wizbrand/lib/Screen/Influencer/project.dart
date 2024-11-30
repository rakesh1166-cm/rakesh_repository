import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/createorg.dart';
import 'package:wizbrand/Screen/Influencer/createproject.dart';
import 'package:wizbrand/Screen/Influencer/notfound.dart';
import 'package:wizbrand/Screen/Influencer/organizationScreen.dart';
import 'package:wizbrand/Screen/Influencer/startwizard.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/model/projectmodel.dart';
import 'package:wizbrand/model/webassets.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class ProjectScreen extends StatefulWidget {
  final String orgSlug;

  ProjectScreen({required this.orgSlug});

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> with DrawerMixin, RoleMixin, NavigationMixin {
  String _userRole = ''; // Variable to store the role for AppBar
TextEditingController _searchController = TextEditingController();
 String _userName = ''; // Variable to store the user's name
List<Project> _filteredProjects = []; // List to hold filtered projects

List<WebassetsModel> _filteredWebAssets = []; // List to hold filtered web assets
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
    await organizationViewModel.getProject(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString()); // Pass the additional parameters
    _filteredProjects = organizationViewModel.my_projects; // Initialize with full data

    await organizationViewModel.getWebassets(
      email,
      widget.orgSlug,
      orgRoleId.toString(),
      orgUserId.toString(),
      orgUserorgId.toString(),
    );

    _filteredWebAssets=organizationViewModel.my_webassets; // Initialize with full data

  }
   
}
void _filterProjects(String query) {
  final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
  final allProjects = organizationViewModel.my_projects;

  setState(() {
    _filteredProjects = allProjects.where((project) {
      final projectNameLower = project.projectName?.toLowerCase() ?? '';
      final projectManagerLower = project.projectManager?.toLowerCase() ?? '';
      final queryLower = query.toLowerCase();

      return projectNameLower.contains(queryLower) || 
             projectManagerLower.contains(queryLower);
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
                                labelText: 'Search by Project Name or Manager',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.search),
                              ),
                              onChanged: (value) {
                                _filterProjects(value); // Call filter method on text change
                              },
                            ),
                          ),

                           if (_userRole != 'User')
                        ElevatedButton(
                          onPressed: () {
                            _showCreateProjectDialog(context);
                          },
                          child: Text('Create New Project'),
                        ),
                        SizedBox(height: 20),
                     Expanded(
  child: _filteredProjects.isEmpty
      ? Center(
          child: Text('No projects found for this organization'),
        )
      : ListView.builder(
          itemCount: _filteredProjects.length,
          itemBuilder: (context, index) {
            final project = _filteredProjects[index];

            return GestureDetector(
               onTap: () => _showProjectDetailsDialog(project), // Show dialog on tap
              child: Card(
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
                      // Project Name
                      Text(
                        'Project Name: ${project.projectName ?? 'No Project Name'}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      
                      // Project Manager
                      Text(
                        'Project Manager: ${project.projectManager ?? 'No Manager Available'}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
              
                      // Project Status
                      Text(
                        'Status: ${project.status == 'Up' ? 'Up' : 'Down'}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
              
                      // Project URL
                      Text(
                        'URL: ${project.url ?? 'No URL Available'}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
              
                          // SSL Expiry
                          SizedBox(height: 8),
                          Text(
                            'SSL Expiry: ${project.expiry ?? 'No Expiry Date'}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
              
                            // Row for edit and delete icons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                          Icon(
                        Icons.visibility,
                        color: Colors.blue,
                        size: 24,
                              ),
                     if (_userRole != 'User') 
                                IconButton(
                            icon: Icon(Icons.play_arrow, color: Colors.green),
                            onPressed: () {
                              _startProjectWizard(context, project); // Handle start wizard action
                            },
                            tooltip: 'Start Wizard',
                          ),
                      if (_userRole != 'User') 
                   IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditProjectDialog(context, project);
                            },
                            tooltip: 'Edit Project',
                          ),
                         if (_userRole != 'Manager' && _userRole != 'User') 
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteProjectDialog(context, project);
                      },
                      tooltip: 'Delete Project',
                    ),
                        ],
                      ),
                    ],
                  ),
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
                 title: 'Projects', // Set the title as needed
                ),
              ],
            ),
    );
  }

void _showProjectDetailsDialog(Project project) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Project Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                'Pro_Name: ${project.projectName ?? 'No Project Name'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10), // Space between text items
              Text(
                'Pro_Mgr: ${project.projectManager ?? 'No Manager Available'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10), // Space between text items
              Text(
                'Status: ${project.status == 'Up' ? 'Up' : 'Down'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10), // Space between text items
              Text(
                'URL: ${project.url ?? 'No URL Available'}',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
              SizedBox(height: 10), // Space between text items
              Text(
                'SSL Expiry: ${project.expiry ?? 'No Expiry Date'}',
                style: TextStyle(fontSize: 16),
              ),
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

void _startProjectWizard(BuildContext context, project) async {
  // Fetch the parameters from secure storage
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StartWizardDialog(
        orgSlug: widget.orgSlug,      // Pass organization slug from project
        orgRoleId: orgRoleId!,         // Pass orgRoleId
        orgUserId: orgUserId!,         // Pass orgUserId
        orgUserorgId: orgUserorgId!,   // Pass orgUserorgId
        projectName: project.projectName ?? 'Unknown Project',  // Pass project name
         projectId: project.id.toString() ?? 'Unknown Project',  // Pass project name
      );
    },
  );
}

void _showCreateProjectDialog(BuildContext context) async {
  // Fetch the parameters from secure storage
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateProjectDialog(
        orgSlug: widget.orgSlug, // Pass the existing parameter
        orgRoleId: orgRoleId!,   // Pass the new parameter
        orgUserId: orgUserId!,   // Pass the new parameter
        orgUserorgId: orgUserorgId!, // Pass the new parameter
      );
    },
  );
}

  // Method to display a dialog for editing a project
 void _showEditProjectDialog(BuildContext context, project) async {
  // Pass the project data to the CreateProjectDialog
   final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateProjectDialog(
        orgSlug: widget.orgSlug,
        orgRoleId: orgRoleId!,// Replace with actual value
        orgUserId: orgUserId!,   // Replace with actual value
        orgUserorgId: orgUserorgId!, // Replace with actual value
        projectName: project.projectName, // Pass project name
        url: project.url, // Pass project URL
        id: project.id, 
        selectedManager: project.projectManager, // Pass selected manager
      );
    },
  );

  // Optionally, refresh the data after editing
  _fetchData();
}

 Future<void> _showDeleteProjectDialog(BuildContext context, Project project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Project'),
          content: Text('Are you sure you want to delete this project?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
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
      final response = await organizationViewModel.deleteProject(context, project.id, widget.orgSlug);
 
        if (response['success'] == true) {
            print("coming here success");
          _fetchData();
        } else {
          print("comingelse here");
         
        }
      } catch (error) {
        await _showErrorDialog(context, 'An error occurred while deleting the project.');
      }
    }
  }

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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


