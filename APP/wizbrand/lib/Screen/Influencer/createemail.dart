import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/emailscreen.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreateEmailDialog extends StatefulWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;

  // Optional fields for editing
  final String? email;
  final String? phoneNumber;
  final String? password;
  final String? passwordHint;
  final String? accountRecoveryDetails;
  final int? id; // Change this to int?

  CreateEmailDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.email,
    this.phoneNumber,
    this.password,
    this.passwordHint,
    this.accountRecoveryDetails,
    this.id, // Add emailId for edit
  });

  @override
  _CreateEmailDialogState createState() => _CreateEmailDialogState();
}

class _CreateEmailDialogState extends State<CreateEmailDialog> {
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _passwordController; // New password controller
  late TextEditingController _passwordHintController;
  late TextEditingController _accountRecoveryController;

  String? _errorMessage;
  bool isLoading = false; // To show a loading state while fetching data and saving
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the passed email data or empty values for new emails
    _emailController = TextEditingController(text: widget.email ?? '');
    _phoneNumberController = TextEditingController(text: widget.phoneNumber ?? '');
    _passwordController = TextEditingController(text: widget.password ?? ''); // Initialize password field
    _passwordHintController = TextEditingController(text: widget.passwordHint ?? '');
    _accountRecoveryController = TextEditingController(text: widget.accountRecoveryDetails ?? '');
  }

  Future<void> _createOrUpdateEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final credentials = await _getCredentials();
        final loggedInUserEmail = credentials['email'];

        if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User email is required')),
          );
          setState(() {
            isLoading = false;
          });
          return;
        }

        final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

       // Call the appropriate method for create or update based on whether email exists

        final response = await (widget.email == null
            ? organizationViewModel.createEmail(
                loggedInUserEmail,
                _emailController.text,
                _phoneNumberController.text,
                _passwordController.text, // Use password field
                _passwordHintController.text,
                _accountRecoveryController.text,
                widget.orgSlug,
                widget.orgRoleId,
                widget.orgUserId,
                widget.orgUserorgId,
              )
            : organizationViewModel.updateEmail(
                loggedInUserEmail,
                _emailController.text,
                _phoneNumberController.text,
                _passwordController.text, // Use password field
                _passwordHintController.text,
                _accountRecoveryController.text,
                widget.orgSlug,
                widget.id.toString(),
                widget.orgRoleId,
                widget.orgUserId,
                widget.orgUserorgId,
              ));

        setState(() {
          isLoading = false;
        });

             if (response['success'] == true) {
                  print('coming inside response');
                   print(response['message']);
                    print(response['success']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EmailScreen(orgSlug: widget.orgSlug),
              ),
            );

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Failed to create/update email.')),
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating/updating email: $e')),
        );
      }
    }
  }



  Future<Map<String, String>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    final email = await secureStorage.read(key: 'email');
    return {'email': email ?? ''};
  }

  @override
  Widget build(BuildContext context) {
   return GestureDetector(
       onTap: () {
      FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside
    },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(widget.email == null ? 'Add New Email' : 'Edit Email'),
        content: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView( // Wrap in SingleChildScrollView
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                     widget.id != null // Check if editing
                        ? TextFormField(
                            controller: _emailController,
                            readOnly: true, // Make the field read-only
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                          )
                        : TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              }
                              return null;
                            },
                          ),
                      SizedBox(height: 10),
                      TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              keyboardType: TextInputType.phone, // Ensure the keyboard is optimized for phone input
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                } else if (!RegExp(r'^\d{10}$').hasMatch(value)) { // Regex to check for exactly 10 digits
                  return 'Please enter a valid 10-digit phone number';
                }
                return null;
              },
            ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController, // New password field
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        obscureText: true, // Hide the password input
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordHintController,
                        decoration: InputDecoration(
                          labelText: 'Password Hint',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _accountRecoveryController,
                        decoration: InputDecoration(
                          labelText: 'Account Recovery Details',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _createOrUpdateEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(widget.email == null ? 'Add' : 'Update'),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose(); // Dispose of password controller
    _passwordHintController.dispose();
    _accountRecoveryController.dispose();
    super.dispose();
  }
}