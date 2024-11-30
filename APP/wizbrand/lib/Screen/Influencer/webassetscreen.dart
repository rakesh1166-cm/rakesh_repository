import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/addsocialwizardurl.dart';
import 'package:wizbrand/Screen/Influencer/createproject.dart';
import 'package:wizbrand/Screen/Influencer/createwebasset.dart';
import 'package:wizbrand/Screen/Influencer/encryptfile.dart';
import 'package:wizbrand/Screen/Influencer/mywebview.dart';
import 'package:wizbrand/Screen/Influencer/startwizard.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/model/webassets.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class WebassetScreen extends StatefulWidget {
  final String orgSlug;

  WebassetScreen({required this.orgSlug});

  @override
  _WebassetScreenState createState() => _WebassetScreenState();
}

class _WebassetScreenState extends State<WebassetScreen> with DrawerMixin, RoleMixin, NavigationMixin { 
  String _userRole = ''; // Variable to store the role for AppBar
  TextEditingController _searchController = TextEditingController();
  String _userName = ''; // Variable to store the user's name
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
      await organizationViewModel.getWebassets(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString()); // Pass the additional parameters
    _filteredWebAssets = organizationViewModel.my_webassets; // Initialize with full data
    print("Data in _filteredWebAssets: $_filteredWebAssets");
    }
  }
void _filterWebAssets(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final allWebAssets = organizationViewModel.my_webassets;

    setState(() {
        _filteredWebAssets = allWebAssets.where((webAsset) {
            final projectNameLower = webAsset.wizardProjectName?.toLowerCase() ?? '';
            final assetTypeLower = webAsset.typeOfTask?.toLowerCase() ?? '';
            final queryLower = query.toLowerCase();

            return projectNameLower.contains(queryLower) || assetTypeLower.contains(queryLower);
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
                        Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the start
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showCreateProjectDialog(context,);
                    },
                    child: Text('Add Asset'),
                  ),

                  SizedBox(width: 10), // Add some space between the buttons

                  ElevatedButton(
                    onPressed: () {
                     _showAddSocialWizardUrlDialog(context); // Call the new function for adding Social Wizard URL
                    },
                    child: Text('Add Social Wizard URL'),
                  ),
                ],
              ),

                 Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            labelText: 'Search by Project Name or Type',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                            _filterWebAssets(value); // Call filter method on text change
                        },
                      ),
                      ),

                        SizedBox(height: 20),
                Expanded(
    child: _filteredWebAssets.isEmpty
      ? Center(
          child: Text('No web assets found for this organization'),
        )
      : ListView.builder(
          itemCount: _filteredWebAssets.length,
            itemBuilder: (context, index) {
                final webAsset = _filteredWebAssets[index];
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
                    // Display project details dynamically
                           Text(
                      'Project Name: ${webAsset.wizardProjectName != null && webAsset.wizardProjectName!.length > 28 
                          ? webAsset.wizardProjectName!.substring(0, 28) + '...' 
                          : webAsset.wizardProjectName ?? 'No Project Name'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),

                    Text(
                      'Type of Asset: ${webAsset.typeOfTask != null && webAsset.typeOfTask!.length > 28 
                          ? webAsset.typeOfTask!.substring(0, 28) + '...' 
                          : webAsset.typeOfTask ?? 'No Type Available'}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    Text(
                      'emailAddress Name: ${webAsset.tokenEngineer ?? 'No Project Name'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Add more fields here as needed
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                                           IconButton(
                          icon: Icon(Icons.visibility, color: Colors.green),
                          onPressed: () {
                            _showViewProjectDialog(context, webAsset);
                          },
                          tooltip: 'View Details',
                        ),
                        if (_userRole != 'User')
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditProjectDialog(context, webAsset);
                          },
                          tooltip: 'Edit Project',
                        ),
                         if (_userRole != 'Manager' && _userRole != 'User') 
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteProjectDialog(context, webAsset);
                          },
                          tooltip: 'Delete Project',
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
            title: 'Web Assets', // Set the title as needed

                ),
              ],
            ),
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
          orgSlug: widget.orgSlug, // Pass organization slug from project
          orgRoleId: orgRoleId!, // Pass orgRoleId
          orgUserId: orgUserId!, // Pass orgUserId
          orgUserorgId: orgUserorgId!, // Pass orgUserorgId
          projectName: project.projectName ?? 'Unknown Project', // Pass project name
          projectId: project.id.toString() ?? 'Unknown Project', // Pass project name
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
        return CreateWebsiteAssetDialog(
          orgSlug: widget.orgSlug, // Pass the existing parameter
          orgRoleId: orgRoleId!,   // Pass the new parameter
          orgUserId: orgUserId!,   // Pass the new parameter
          orgUserorgId: orgUserorgId!, // Pass the new parameter
        );
      },
    );
  }


 void _showEditProjectDialog(BuildContext context, project) async {
  // Pass the project data to the CreateProjectDialog
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
  // Check the type of task and redirect accordingly
  if (project.typeOfTask == 'Social Media Sites') {
    print("type of task is here");
    // Show the CreateProjectDialog for Social Media Sites
await showDialog(
  context: context,
  builder: (BuildContext context) {
    // Determine the web name based on available project fields
    String webname = project.instagram ?? 
                     project.facebooks ?? 
                     project.tiktok ?? 
                     project.twitter ?? 
                     project.slideshare ?? 
                     project.youtube ?? 
                     project.dailymotion ?? 
                     project.linkedin ?? 
                     project.tumblr ?? 
                     project.wordpress ?? 
                     project.pinterest ?? 
                     project.reddit ?? 
                     project.plurk ?? 
                     project.debugschool ?? 
                     project.blogger ?? 
                     project.medium ?? 
                     project.quora ?? 
                     project.professnow ?? 
                     project.github ?? 
                     project.hubpages ?? 
                     project.gurukulgalaxy ?? 
                     project.mymedicplus ?? 
                     project.holidaylandmark ?? 
                     project.facebook_page_value ?? 
                     'No Project Name'; // Default value if all are null                   

    return CreateWebsiteAssetDialog(
      orgSlug: widget.orgSlug,
      orgRoleId: orgRoleId!,
      orgUserId: orgUserId!,
      orgUserorgId: orgUserorgId!,
      projectName: project.wizardProjectName ?? 'No Project Name', // Provide a default value   
      Tasktype: project.typeOfTask ?? 'No Project Name', // Provide a default value   
      webname: webname, // Assign the resolved webname
      type:"social_media",
      id: project.id ?? 0, // Provide a default value or handle accordingly 
    );
  },
);
  } else {

      String tokenname = project.tokenEngineer; 
          // Show a different dialog for other types of tasks   
     print("type of EncryptDialog is here");
       print(tokenname);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EncryptDialog(
           orgSlug: widget.orgSlug,
          orgRoleId: orgRoleId!,
          orgUserId: orgUserId!,
          orgUserorgId: orgUserorgId!,
          tokenname: tokenname ?? 'No token Name', // Provide a default value
          projectName: project.projectName ?? 'No Project Name', // Provide a default value 
           view: "myedit", // Assign the resolved webname    
          id: project.id ?? 0, // Provide a default value or handle accordingly
          
        );
      },
    );
  }

  // Optionally, refresh the data after editing
  _fetchData();
}


 void _showViewProjectDialog(BuildContext context, project) async {
  // Pass the project data to the CreateProjectDialog
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
  // Check the type of task and redirect accordingly
  if (project.typeOfTask == 'Social Media Sites') {
    print("type of task is here");
    // Show the CreateProjectDialog for Social Media Sites
await showDialog(
  context: context,
  builder: (BuildContext context) {
    // Determine the web name based on available project fields
    String webname = project.instagram ?? 
                     project.facebooks ?? 
                     project.tiktok ?? 
                     project.twitter ?? 
                     project.slideshare ?? 
                     project.youtube ?? 
                     project.dailymotion ?? 
                     project.linkedin ?? 
                     project.tumblr ?? 
                     project.wordpress ?? 
                     project.pinterest ?? 
                     project.reddit ?? 
                     project.plurk ?? 
                     project.debugschool ?? 
                     project.blogger ?? 
                     project.medium ?? 
                     project.quora ?? 
                     project.professnow ?? 
                     project.github ?? 
                     project.hubpages ?? 
                     project.gurukulgalaxy ?? 
                     project.mymedicplus ?? 
                     project.holidaylandmark ?? 
                     project.facebook_page_value ?? 
                     'No Project Name'; // Default value if all are null  
            return MyWebView(
              orgSlug: widget.orgSlug,
              orgRoleId: orgRoleId!,
              orgUserId: orgUserId!,
              orgUserorgId: orgUserorgId!,
              projectName: project.wizardProjectName ?? 'No Project Name', // Provide a default value   
              token_engineer: project.tokenEngineer ?? 'Not avialble Name', // Provide a default value       
              Tasktype: project.typeOfTask ?? 'No Project Name', // Provide a default value   
              webname: webname, // Assign the resolved webname     
              id: project.id ?? 0, // Provide a default value or handle accordingly 
            );
  },
);
  } else {
      String tokenname = project.tokenEngineer; 
          // Show a different dialog for other types of tasks   
            print("type of EncryptDialog is here");
          print(tokenname);
           await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EncryptDialog(
           orgSlug: widget.orgSlug,
          orgRoleId: orgRoleId!,
          orgUserId: orgUserId!,
          orgUserorgId: orgUserorgId!,
          tokenname: tokenname ?? 'No token Name', // Provide a default value
          projectName: project.projectName ?? 'No Project Name', // Provide a default value  
          view: "myview", // Assign the resolved webname   
          id: project.id ?? 0, // Provide a default value or handle accordingly
          
        );
      },
    );
  }

  // Optionally, refresh the data after editing
  _fetchData();
}

  void _showDeleteProjectDialog(BuildContext context, webAsset) async {
    // Show confirmation dialog
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Project'),
          content: Text('Are you sure you want to delete this project?'),
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

    // If confirmed, call the API to delete the project
    if (confirmed == true) {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      
      try {
        // Make API call to delete the project
        await organizationViewModel.deleteAsset(
          webAsset.id.toString(), // Pass the project ID for deletion
        
        );
        
        // After deletion, fetch updated data
        _fetchData(); // Refresh the project list
      } catch (error) {
        print("Error while deleting project: $error");
      }
    }
  }

void _showAddSocialWizardUrlDialog(BuildContext context) async {
  // Fetch the parameters from secure storage
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId'); 
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddstartwizardDialog(
        orgSlug: widget.orgSlug,      // Pass organization slug from project
        orgRoleId: orgRoleId!,         // Pass orgRoleId
        orgUserId: orgUserId!,         // Pass orgUserId
        orgUserorgId: orgUserorgId!,   // Pass orgUserorgId       
      );
    },
  );  
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