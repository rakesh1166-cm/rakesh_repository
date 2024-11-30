import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/users.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class InviteUserDialog extends StatefulWidget {
  final String orgSlug; // Add orgSlug parameter
  final String orgRoleId; // Add orgSlug parameter
  

  InviteUserDialog({required this.orgSlug,required this.orgRoleId}); // Initialize orgSlug

  @override
  _InviteUserDialogState createState() => _InviteUserDialogState();
}

class _InviteUserDialogState extends State<InviteUserDialog> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedRole;
  bool _isLoading = false; // For showing a loading indicator

  // Regular expression for email validation
  final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  @override
  Widget build(BuildContext context) {
    print("orgrole id");
    print(widget.orgRoleId);
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
 List<String> roleOptions = [];
    
    if (widget.orgRoleId == '2') {
      // If orgRoleId is 2, include all roles except Admin
      roleOptions = ['Manager', 'User'];
    } else {
      // Default case: Show all roles
      roleOptions = ['Admin', 'Manager', 'User'];
    }
  
       return GestureDetector(
       onTap: () {
      FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside
    },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.purple,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Invite User', style: TextStyle(color: Colors.white)),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop(false); // Return false to indicate form was not submitted
                },
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: _formKey, // Key to manage form state
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Invite User By Email id',
                    border: OutlineInputBorder(),
                  ),
                  // Add validation logic here
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!emailRegExp.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null; // Return null if valid
                  },
                ),
                SizedBox(height: 20),
                 DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Invite Role',
              border: OutlineInputBorder(),
            ),
            value: _selectedRole,
            onChanged: (String? newValue) {
              setState(() {
                _selectedRole = newValue;
              });
            },
            items: roleOptions
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(
              child: _isLoading
                  ? CircularProgressIndicator() // Show loading indicator when making API call
                  : ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });      
      // Fetch the logged-in user's email from secure storage
      final credentials = await _getCredentials();
      final loggedInUserEmail = credentials['email'];      
      // Call the inviteUser API method from OrganizationViewModel

  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

      final response = await organizationViewModel.inviteUser(
        loggedInUserEmail, // email from secure storage (logged-in user)
        _emailController.text, // invitee's email
        _selectedRole!, // selected role
        widget.orgSlug, // pass orgSlug to the method
        orgRoleId.toString(),
        orgUserId.toString(),
        orgUserorgId.toString(),
      );

      
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      
      // Check if the response was successful
      if (response['success'] == true) {
       print("aa raha hain");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UsersScreen(orgSlug: widget.orgSlug),
          ),
        );
      } else {
        // Show an error message if the invitation failed
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UsersScreen(orgSlug: widget.orgSlug),
          ),
        );
      }
        }
      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Add'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}