import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/createtaskboard.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/model/taskboard.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class TaskBoards extends StatefulWidget {
  final String orgSlug;

  TaskBoards({required this.orgSlug});

  @override
  _TaskBoardState createState() => _TaskBoardState();
}

class _TaskBoardState extends State<TaskBoards> with DrawerMixin, RoleMixin, NavigationMixin { 
  String _userRole = ''; // Variable to store the role for AppBar
TextEditingController _searchController = TextEditingController();
String _userName = ''; // Variable to store the user's name
List<TaskBoard> _filteredTasks = []; // List to hold filtered tasks
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
        await organizationViewModel.getTaskboard(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());
        _filteredTasks = organizationViewModel.my_taskboard; // Initialize with full data
    }
  }
void _filterTasks(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final allTasks = organizationViewModel.my_taskboard;

    setState(() {
        _filteredTasks = allTasks.where((task) {
            final titleLower = task.inputTitle?.toLowerCase() ?? '';
            final projectNameLower = task.projectName?.toLowerCase() ?? '';
            final queryLower = query.toLowerCase();

            return titleLower.contains(queryLower) || projectNameLower.contains(queryLower);
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
                          _showCreateTaskDialog(context);
                        },
                        child: Text('Create New Task'),
                      ),
                      SizedBox(height: 20),
                      Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
            labelText: 'Search by Task Title or Project Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
            _filterTasks(value); // Call filter method on text change
        },
    ),
),
                      Expanded(
                        child: _filteredTasks.isEmpty
                            ? Center(child: Text('No data available in table'))
                            : ListView.builder(
                                 itemCount: _filteredTasks.length,
            itemBuilder: (context, index) {
                final taskData = _filteredTasks[index];

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
                                          // Updated layout for task details
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              
                                              Text(
                                                'Task Title: ${taskData.inputTitle ?? 'No Task Title'}',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Project Name: ${taskData.projectName ?? 'No Project Name'}',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 8),
                                        
                                          Text(
                                            'User Email: ${taskData.user ?? ' No User Email'}',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                           SizedBox(height: 8),
                                          Text(
                                            'Task Deadline: ${taskData.taskDeadline ?? 'No Task Deadline'}',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                           SizedBox(height: 8),
                                          Wrap(
                                            spacing: 6.0,
                                            runSpacing: 6.0,
                                            children: [
                                             
                                              _buildTag('Status: ${taskData.status ?? 'N/A'}'),
                                            ],
                                          ),
                                        
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                            
                                              IconButton(
                                                icon: Icon(Icons.edit, color: Colors.blue),
                                                onPressed: () {
                                                  _showEditTaskDialog(context, taskData);
                                                },
                                                tooltip: 'Edit Task',
                                              ),
                                              if (_userRole != 'Manager' && _userRole != 'User') 
                                              IconButton(
                                                icon: Icon(Icons.delete, color: Colors.red),
                                                onPressed: () {
                                                  _showDeleteTaskDialog(context, taskData);
                                                },
                                                tooltip: 'Delete Task',
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
            title: 'Taskboard', // Set the title as needed
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

  // Method to display a dialog for creating a task
  void _showCreateTaskDialog(BuildContext context) async {
       final secureStorage = FlutterSecureStorage();
    final orgRoleId = await secureStorage.read(key: 'orgRoleId');
    final orgUserId = await secureStorage.read(key: 'orgUserId');
    final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateTaskboardDialog(
          orgSlug: widget.orgSlug,
          orgRoleId: orgRoleId!,
          orgUserId: orgUserId!,
          orgUserorgId: orgUserorgId!,
        ); // Passing the orgSlug        
      },
    );     
  }

  // Method to display a dialog for editing a task
  void _showEditTaskDialog(BuildContext context, dynamic taskData) async {
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateTaskboardDialog(
        orgSlug: widget.orgSlug,
        orgRoleId: orgRoleId!,
        orgUserId: orgUserId!,
        orgUserorgId: orgUserorgId!,
        taskTitle: taskData.inputTitle, // Existing task title
        projectName: taskData.projectName, // Existing project name
         projectId: taskData.projectId, // Existing project name
        userEmail: taskData.user, // Existing user email
        taskDeadline: taskData.taskDeadline, // Existing task deadline
        status: taskData.status, // Existing status                
        webUrl: taskData.webUrl, // Existing task title
        keyword: taskData.keyword, // Existing task title
        sevirty: taskData.severity, // Existing task title     
        document: taskData.document, // Existing task title 
        description: taskData.description, // Existing task title 
         tasktype: taskData.taskType, // Existing task title 
         id: taskData.id // Pass ID if needed
        
      );
    },
  );
}

  // Method to display a dialog for deleting a task
  void _showDeleteTaskDialog(BuildContext context, dynamic taskData) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
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
       await organizationViewModel.deleteTask(taskData.id.toString()); 
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