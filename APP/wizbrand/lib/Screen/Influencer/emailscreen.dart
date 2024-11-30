import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/createemail.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/model/email.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';


class EmailScreen extends StatefulWidget {
  final String orgSlug;

  EmailScreen({required this.orgSlug});

  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> with DrawerMixin, RoleMixin, NavigationMixin { 
  String _userRole = '';
  String? _email;
  TextEditingController _searchController = TextEditingController();
List<EmailModel> _filteredEmails = []; // List to hold filtered emails
  final TextEditingController _emailController = TextEditingController();
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
      await organizationViewModel.getEmailassets(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString()); // Fetch email assets
   _filteredEmails = organizationViewModel.my_emails; // Initialize with full data
    }
  }

void _filterEmails(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final allEmails = organizationViewModel.my_emails;

    setState(() {
        _filteredEmails = allEmails.where((emailItem) {
            final emailLower = emailItem.email?.toLowerCase() ?? '';
            final phoneLower = emailItem.phoneNumber?.toLowerCase() ?? '';
            final queryLower = query.toLowerCase();

            return emailLower.contains(queryLower) || phoneLower.contains(queryLower);
        }).toList();
    });
}
  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  Future<void> _saveEmail() async {
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'email', value: _emailController.text);
    setState(() {
      _email = _emailController.text; // Update displayed email
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Email saved successfully')),
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
        actions: buildAppBarActions(context),
      ),
      drawer: buildDrawer(context, orgSlug: widget.orgSlug),
      body: buildBaseScreen(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              // Mail button at the top
              if (_userRole != 'User') 
              ElevatedButton(
                onPressed: () {                 
                  _showSendMailDialog(context);
                },
                child: Text('Add Email'),
              ),
                    SizedBox(height: 20),
                                Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                              labelText: 'Search by Email or Phone Number',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                              _filterEmails(value); // Call filter method on text change
                          },
                      ),
                    ),
                                // ListView for displaying fetched emails
              Expanded(
                child: organizationViewModel.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _filteredEmails.isEmpty
                        ? Center(child: Text('No emails found for this organization.'))
                        : ListView.builder(
                            itemCount: _filteredEmails.length,
                              itemBuilder: (context, index) {
                                  final emailItem = _filteredEmails[index];
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
                                      SizedBox(height: 8),
                                       RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Email: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${emailItem.email ?? 'No Email Address'}', // The dynamic part
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
                                            text: 'Mobile: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${emailItem.phoneNumber ?? 'No Mobile'}', // The dynamic part
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
                                            text: 'Password Hint: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${emailItem.passwordHint ?? 'No Password Hint'}', // The dynamic part
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
                                            text: 'Account Recovery: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${emailItem.accountRecoveryDetails ?? 'No Account Recovery'}', // The dynamic part
                                            style: TextStyle(
                                              fontSize: 14,color: Colors.black, // Regular size for the email
                                              fontWeight: FontWeight.normal, // Regular font weight for the email
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                      SizedBox(height: 8),// Row for action icons
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                           if (_userRole != 'User') 
                                          IconButton(
                                            icon: Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () {
                                              _showEditEmailDialog(emailItem); // Implement your edit logic
                                            },
                                            tooltip: 'Edit Email',
                                          ),
                                           if (_userRole != 'Manager' && _userRole != 'User') 
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              _showDeleteEmailDialog(context, emailItem);
                                           
                                            },
                                            tooltip: 'Delete Email',
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
            title: 'Email Screen', // Set the title as needed 
      ),
    );
  }

  
void _showSendMailDialog(BuildContext context) async {
  // Fetch the parameters from secure storage
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateEmailDialog(
        orgSlug: widget.orgSlug, // Pass the existing parameter
        orgRoleId: orgRoleId!,   // Pass the new parameter
        orgUserId: orgUserId!,   // Pass the new parameter
        orgUserorgId: orgUserorgId!, // Pass the new parameter
      );
    },
  );
}
 
void _showEditEmailDialog(emailItem) async{
   final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateEmailDialog(   
        orgSlug: widget.orgSlug, // Pass the existing parameter
        orgRoleId: orgRoleId!,   // Pass the new parameter
        orgUserId: orgUserId!,   // Pass the new parameter
        orgUserorgId: orgUserorgId!, 
        email: emailItem.email, // Existing email
        phoneNumber: emailItem.phoneNumber, // Existing phone number
        password: emailItem.password, // Existing password
        passwordHint: emailItem.passwordHint, // Existing password hint
        accountRecoveryDetails: emailItem.accountRecoveryDetails, // Existing recovery details
        id: emailItem.id, // Pass the ID of the email

      );
    },
  );
}
 

   void _showDeleteEmailDialog(BuildContext context, emailItem) async {
  // Show confirmation dialog
  final confirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Email'),
        content: Text('Are you sure you want to delete this Email?'),
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
      await organizationViewModel.deleteEmail(
        emailItem.id, // Pass the project ID for deletion
        widget.orgSlug, // Pass the organization slug if necessary
      );    
    
      _fetchData(); // Refresh the project list
    } catch (error) {
      print("Error while deleting project: $error");
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

  // Helper method to determine user role
 
}