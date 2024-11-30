import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/CreateGuest.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/model/guest.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';

class GuestScreen extends StatefulWidget {
  final String orgSlug;

  GuestScreen({required this.orgSlug});

  @override
  _GuestScreenState createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> with DrawerMixin, RoleMixin, NavigationMixin { 
  String _userRole = '';
  String? _guestMessage;
  TextEditingController _searchController = TextEditingController();
List<GuestModel> _filteredGuests = []; // List to hold filtered guest messages
  final TextEditingController _messageController = TextEditingController();
  String _userName = ''; // Variable to store the user's name

  @override
  void initState() {
    super.initState();
    _fetchData();
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
        await organizationViewModel.getGuestassets(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());
        _filteredGuests = organizationViewModel.my_guests; // Initialize with full data
    }
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }
void _filterGuests(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final allGuests = organizationViewModel.my_guests;

    setState(() {
        _filteredGuests = allGuests.where((guest) {
            final titleLower = guest.title?.toLowerCase() ?? '';
            final urlLower = guest.url?.toLowerCase() ?? '';
            final queryLower = query.toLowerCase();

            return titleLower.contains(queryLower) || urlLower.contains(queryLower);
        }).toList();
    });
}
  Future<void> _sendMessage() async {
    // Handle message sending logic here
    // You can add your API call or logic to process the message

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message sent successfully')),
    );
    setState(() {
      _guestMessage = _messageController.text; // Update displayed message
      _messageController.clear(); // Clear the input field after sending
    });
  }
void _showEditGuestDialog(guest) async {
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateGuestMessageDialog(
        orgSlug: widget.orgSlug,
        orgRoleId: orgRoleId!,
        orgUserId: orgUserId!,
        orgUserorgId: orgUserorgId!,
        id: guest.id,
        title: guest.title, // Pass the guest message title
        url: guest.url, // Pass the guest message URL
       
      );
    },
  );
}
  void _showDeleteGuestDialog(BuildContext context, guest) async {
  // Show confirmation dialog
  final confirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Guest'),
        content: Text('Are you sure you want to delete this guest?'),
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
      await organizationViewModel.deleteGuest(
        guest.id, // Pass the project ID for deletion
        widget.orgSlug, // Pass the organization slug if necessary
      );
      
      // After deletion, fetch updated data
      _fetchData(); // Refresh the project list
    } catch (error) {
      print("Error while deleting project: $error");
    }
  }
}



  void _showSendGuestMessageDialog() async {
  // Fetch the parameters from secure storage
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateGuestMessageDialog (
        orgSlug: widget.orgSlug, // Pass the existing parameter
        orgRoleId: orgRoleId!,   // Pass the new parameter
        orgUserId: orgUserId!,   // Pass the new parameter
        orgUserorgId: orgUserorgId!, // Pass the new parameter
      );
    },
  );
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
      body: buildBaseScreen(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
       
              if (_userRole != 'User') 
              ElevatedButton(
                onPressed: _showSendGuestMessageDialog,
                child: Text('Send Message'),
              ),
              SizedBox(height: 20),
              Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
            labelText: 'Search by Message or URL',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
            _filterGuests(value); // Call filter method on text change
        },
    ),
),
              if (_guestMessage != null) ...[
                Text(
                  'Last Message: $_guestMessage',
                  style: TextStyle(fontSize: 16),
                ),
              ],
              SizedBox(height: 20),
              // ListView for displaying fetched guest messages
              Expanded(
                child: organizationViewModel.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _filteredGuests.isEmpty
                        ? Center(child: Text('No guest messages found for this organization.'))
                        : ListView.builder(
                           itemCount: _filteredGuests.length,
            itemBuilder: (context, index) {
                final guest = _filteredGuests[index];

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
                           RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Guest Message: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${guest.title ?? 'No guest message'}', // The dynamic part
                                            style: TextStyle(
                                              fontSize: 14,color: Colors.black, // Regular size for the email
                                              fontWeight: FontWeight.normal, // Regular font weight for the email
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                     
                                      SizedBox(height: 8),
                                       RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Url: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${guest.url ?? 'No url  here'}', // The dynamic part
                                            style: TextStyle(
                                              fontSize: 14,color: Colors.black, // Regular size for the email
                                              fontWeight: FontWeight.normal, // Regular font weight for the email
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                     
                                      SizedBox(height: 8),
                                      Row(
                      children: [
                        Text(
                          'Status: ', // The static part
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold, // Bold style for 'Status:'
                          ),
                        ),
                      
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
    // Status button
    ElevatedButton(
      onPressed: () {
        // Add action for the button if needed
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: guest.status == 1 ? Colors.cyan : Colors.grey, // Change color based on status
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
      ),
      child: Text(
        guest.status == 1 ? 'Active' : 'Inactive', // Dynamic text based on status
        style: TextStyle(color: Colors.white), // White text color
      ),
    ),
                                     
                                      SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                           if (_userRole != 'User')
                                          IconButton(
                                            icon: Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () {
                                              _showEditGuestDialog(guest); // Edit logic
                                            },
                                            tooltip: 'Edit Message',
                                          ),
                                           if (_userRole != 'Manager' && _userRole != 'User')
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              _showDeleteGuestDialog(context, guest);
                                            
                                            },
                                            tooltip: 'Delete Message',
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
            title: 'GuestPost', // Set the title as needed

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