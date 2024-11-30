import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/invite.dart'; // Ensure this path is correct
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/model/userorganization.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';


class UsersScreen extends StatefulWidget {
  final String orgSlug;
  UsersScreen({required this.orgSlug});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> with DrawerMixin, RoleMixin, NavigationMixin {
  String _userRole = ''; // Variable to store the role for AppBar
  TextEditingController _searchController = TextEditingController();
  List<UserOrganization> _filteredUsers = []; // List to hold filtered users

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

    setState(() {
      _userRole = determineUserRole(orgRoleId); // Use the mixin to determine the role
    });

    // Fetch organization data
    if (email != null && orgSlug.isNotEmpty) {
      await organizationViewModel.getUserFunction(email, orgSlug);
      _filteredUsers = organizationViewModel.my_org; // Initialize with full data
    }
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

void _filterUsers(String query) {
  final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
  final allUsers = organizationViewModel.my_org;

  // Debug: Print all users
  print("All Users: $allUsers");

  setState(() {
    _filteredUsers = allUsers.where((user) {
      final userEmailLower = user.orgUserEmail?.toLowerCase() ?? '';
      final orgNameLower = user.orgSlugName?.toLowerCase() ?? '';
      final userRole = determineUserRole(user.orgRoleId).toLowerCase();
      final queryLower = query.toLowerCase();
      return userEmailLower.contains(queryLower) || 
             orgNameLower.contains(queryLower);
    }).toList();

    // Debug: Print filtered users
    print("Filtered Users: $_filteredUsers");
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
          'Wizbrand - $_userRole', // Display role dynamically in the AppBar
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
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Users',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Search by Email, Organization, or Role',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            _filterUsers(value); // Call filter method on text change
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      if (_userRole != 'User')
                      ElevatedButton(
                        onPressed: () {
                          _showInviteUserDialog(context);
                        },
                        child: Text('Invite Member ' + widget.orgSlug),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _fetchData, // Pull to refresh calls _fetchData
                          child: _filteredUsers.isEmpty
                              ? Center(
                                  child: Text('No users found for this organization'),
                                )
                              : ListView.builder(
                                  itemCount: _filteredUsers.length,
                                  itemBuilder: (context, index) {
                                    final userOrganization = _filteredUsers[index];

                                    // Convert orgRoleId to display role
                                    String userRole = determineUserRole(userOrganization.orgRoleId);

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
                                            // Organization Name
                                            Text(
                                              'Organization Name: ${userOrganization.orgSlugName ?? 'No Organization Name'}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            // Member's Email
                                            Text(
                                              'Member\'s Email: ${userOrganization.orgUserEmail ?? 'No Email Available'}',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(height: 8),
                                            // Role (Display the converted userRole)
                                            Text(
                                              'Role: $userRole',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(height: 8),
                                            // Status
                                            Text(
                                              'Status: ${userOrganization.status == '2' ? 'Accepted' : userOrganization.status == '1' ? 'Blocked' : 'Invited'}',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(height: 8),
                                            // Row for icons
                                             if (_userRole != 'Manager' && _userRole != 'User') 
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                // Block / Unblock Icon
                                                IconButton(
                                                  icon: Icon(
                                                    userOrganization.status == '2' || userOrganization.status == '0'
                                                        ? Icons.lock_open  // Unblock for 'Accepted' or 'Invited'
                                                        : Icons.block,     // Block for 'Blocked'
                                                    color: userOrganization.status == '2' || userOrganization.status == '0'
                                                        ? Colors.green     // Green for unblock (Accepted or Invited)
                                                        : Colors.red,      // Red for block (Blocked)
                                                  ),
                                                  onPressed: () async {
                                                    final credentials = await _getCredentials();
                                                    final loggedInEmail = credentials['email'];

                                                    if (loggedInEmail != null) {
                                                      await _showBlockConfirmationDialog(
                                                        context,
                                                        widget.orgSlug,
                                                        userOrganization.orgUserEmail ?? '',
                                                        loggedInEmail,
                                                        userRole,  // Use the converted userRole here
                                                      );
                                                    }
                                                  },
                                                  tooltip: userOrganization.status == '2' || userOrganization.status == '0'
                                                      ? 'Block User'   // Tooltip for unblock action
                                                      : 'Unblock User',     // Tooltip for block action
                                                ),
                                                SizedBox(width: 10),
                                                IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () async {
                                                    final credentials = await _getCredentials();
                                                    final loggedInEmail = credentials['email'];

                                                    if (loggedInEmail != null) {
                                                      await _showDeleteConfirmationDialog(
                                                        context,
                                                        widget.orgSlug,
                                                        userOrganization.orgUserEmail ?? '',
                                                        loggedInEmail,
                                                        userRole,  // Use the converted userRole here
                                                      );
                                                    }
                                                  },
                                                  tooltip: 'Remove User',
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
                      ),
                    ],
                  ),
                     currentIndex: 0, // Set an appropriate index
            title: 'Invite User', // Set the title as needed
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _fetchData(), // Manual refresh button to call _fetchData
        child: const Icon(Icons.refresh),
      ),
    );
  }

  // Modified to handle refresh after inviting user
  void _showInviteUserDialog(BuildContext context) async {
      final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return InviteUserDialog(orgSlug: widget.orgSlug,orgRoleId: orgRoleId.toString()); // Pass orgSlug to dialog
      },
    );

    // If a user was invited, result should be true, and we refresh the list
    if (result == true) {
      _fetchData(); // Refresh user list after inviting
    }
  }

  // Show confirmation dialog for blocking
  Future<void> _showBlockConfirmationDialog(
    BuildContext context,
    String orgSlug,
    String email,
    String loggedEmail,
    String role,
  ) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Block User'),
          content: Text('Are you sure you want to block this user from the organization?'),
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
              child: Text('Block'),
            ),
          ],
        );
      },
    );

    // If confirmed, call the block API
    if (confirmed == true) {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      await organizationViewModel.blockOrganization(
        orgSlug: orgSlug,
        email: email,
        loggedEmail: loggedEmail,
        role: role,     // Organization slug
      );
      // Refresh the data after blocking
      _fetchData();
    }
  }

  // Show confirmation dialog for deleting
  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    String orgSlug,
    String email,
    String loggedEmail,
    String role,
  ) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user from the organization?'),
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

    // If confirmed, call the delete API
    if (confirmed == true) {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

      try {
        await organizationViewModel.deletemyOrganization(
          orgSlug: orgSlug,
          email: email,
          loggedEmail: loggedEmail,
          role: role,  // Pass the orgSlug correctly
        );

        // After deleting, fetch the updated user list and refresh the UI
        await _fetchData();
        setState(() {});  // Rebuild the UI with the updated user list
      } catch (error) {
        print("Error: $error");
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
