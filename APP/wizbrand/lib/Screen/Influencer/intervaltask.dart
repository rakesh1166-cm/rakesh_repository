import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/createinterval.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/model/interval_task.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class IntervalTasks extends StatefulWidget {
  final String orgSlug;
  IntervalTasks({required this.orgSlug});
  @override
  _IntervalTaskState createState() => _IntervalTaskState();
}


class _IntervalTaskState extends State<IntervalTasks>with DrawerMixin, RoleMixin, NavigationMixin { 
String _userRole = ''; // Variable to store the role for AppBar
TextEditingController _searchController = TextEditingController();
List<IntervalTask> _filteredIntervaltask = []; // List to hold filtered keyword
List<IntervalTask> _allIntervalTasks = []; // List to hold filtered keyword
String _userName = ''; // Variable to store the user's name
    Map<String, List<IntervalTask>> memberDataMap = {};
    final List<String> timedata = [
         "Hourly",
         "Daily",
         "Weekly",
         "Bi Weekly",
         "Monthly",     
    ];
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
       _allIntervalTasks = organizationViewModel.my_intervaltask;
      await organizationViewModel.getIntervaltask(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());
   
    // _filteredIntervaltask = _allIntervalTasks.where((task) {
    //   return task.taskFreq != null && task.taskFreq!.toLowerCase().contains("hourly");
    // }).toList();

     _filteredIntervaltask = organizationViewModel.my_intervaltask; 
    _populateMemberDataMap();// look here
    }
  }
  void _filterIntervalTasks(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
  setState(() {
    _filteredIntervaltask = organizationViewModel.my_intervaltask.where((task) {
      final titleLower = task.taskTitle?.toLowerCase() ?? '';
      final detailsLower = task.taskDetails?.toLowerCase() ?? '';
      final queryLower = query.toLowerCase();

      return titleLower.contains(queryLower) || detailsLower.contains(queryLower);
    }).toList();
  });
}
void _populateMemberDataMap() {
  // Clear the existing data
  memberDataMap.clear();

  // Loop through the defined frequencies
  for (var member in timedata) {
    // Filter interval tasks based on the frequency that matches the member
    memberDataMap[member] = _filteredIntervaltask.where((data) {
      return data.taskFreq != null && data.taskFreq!.contains(member);
    }).toList();
  }
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
                        ElevatedButton(
                          onPressed: () {
                            _showCreateIntervalTaskDialog(context);
                          },
                          child: Text('Create New Interval Task'),
                        ),
                        SizedBox(height: 20),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search by Task Title or Details',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        _filterIntervalTasks(value); // Call filter method on text change
                      },
                    ),
                  ),
                    _buildDynamicButtons(), // Dynamic buttons for team members
                                          Expanded(
                          child: _filteredIntervaltask.isEmpty
                              ? Center(child: Text('No data available in table'))
                              : ListView.builder(
                                   itemCount: _filteredIntervaltask.length,
                                  itemBuilder: (context, index) {
                                    final taskData = _filteredIntervaltask[index];

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
                                                    'ID: ${taskData.id ?? 'N/A'}',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Frequency: ${taskData.taskFreq ?? 'N/A'}',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Task Title: ${taskData.taskTitle ?? 'No Title'}',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Task Details: ${taskData.taskDetails ?? 'No Details'}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 8),
                                            Wrap(
                                              spacing: 6.0,
                                              runSpacing: 6.0,
                                              children: [
                                                _buildTag('Admin Email: ${taskData.adminEmail ?? 'N/A'}'),
                                                _buildTag('User Email: ${taskData.userName ?? 'N/A'}'),
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
                                                    _showEditTaskDialog(context, taskData);
                                                  },
                                                  tooltip: 'Edit Task Data',
                                                ),
                                                  if (_userRole != 'Manager' && _userRole != 'User')
                                                IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () {
                                                    _showDeleteTaskDialog(context, taskData);
                                                  },
                                                  tooltip: 'Delete Task Data',
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
            title: 'Interval Task', // Set the title as needed
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

  // Method to display a dialog for creating an Interval Task entry
  void _showCreateIntervalTaskDialog(BuildContext context) async {
          final secureStorage = FlutterSecureStorage();
    final orgRoleId = await secureStorage.read(key: 'orgRoleId');
    final orgUserId = await secureStorage.read(key: 'orgUserId');
    final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateIntervalDialog(
          orgSlug: widget.orgSlug,
          orgRoleId: orgRoleId!,
          orgUserId: orgUserId!,
          orgUserorgId: orgUserorgId!,
        ); // Passing the orgSlug        
      },
    ); 
  }


  

void _showEditTaskDialog(BuildContext context, IntervalTask taskData) async {
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateIntervalDialog(

        orgSlug: widget.orgSlug, // Pass the existing parameter
        orgRoleId: orgRoleId!,   // Pass the new parameter
        orgUserId: orgUserId!,   // Pass the new parameter
        orgUserorgId: orgUserorgId!, // Pass the new parameter
        taskTitle: taskData.taskTitle, // Existing task title
        taskDetails: taskData.taskDetails, // Existing task details
        taskFreq: taskData.taskFreq, // Existing task frequency
        adminEmail: taskData.adminEmail, // Existing admin email
        userEmail: taskData.userName, // Existing user email
        id: taskData.id, // Pass ID if needed

      );
    },
  );
}
  // Method to display a dialog for deleting a Task entry
  void _showDeleteTaskDialog(BuildContext context, dynamic taskData) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Interval Task Data'),
          content: Text('Are you sure you want to delete this task entry?'),
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
      //await organizationViewModel.deleteTask(taskData['id']); // Assuming deleteTask method takes an ID
      await organizationViewModel.deleteIntervaltask(taskData.id.toString()); 
      _fetchData(); // Refresh the data after deletion
    }
  }
Widget _buildDynamicButtons() {
  final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: timedata.map((memberName) {
        return GestureDetector(
          onTap: () {
            // Filter the interval tasks based on the selected frequency
            setState(() {
              _filteredIntervaltask = organizationViewModel.my_intervaltask.where((task) {
                // Normalize both values to lowercase for comparison
                final taskFrequencyLower = task.taskFreq?.toLowerCase() ?? '';
                final memberNameLower = memberName.toLowerCase();
                return taskFrequencyLower.contains(memberNameLower);
              }).toList();
            });
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