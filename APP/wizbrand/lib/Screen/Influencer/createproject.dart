import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/project.dart';
import 'package:wizbrand/Screen/Influencer/users.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreateProjectDialog extends StatefulWidget {
    final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;

  // Optional fields for editing
  final String? projectName;
  final String? url;
  final String? selectedManager;
  final int? id; // Change this to int?

  CreateProjectDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.projectName,
    this.url,
    this.selectedManager,
    this.id, // Add projectId for edit
  });

  @override
  _CreateProjectDialogState createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  late TextEditingController _projectNameController;
  late TextEditingController _urlController;
  String? selectedManager;

  String? _errorMessage;
  // Dynamic list of manager emails
  List<String> managerEmails = [];
  
  bool isLoading = false; // To show a loading state while fetching data and saving
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

  @override
  void initState() {
    super.initState();

    // Initialize controllers with the passed project data or empty values for new projects
    _projectNameController = TextEditingController(text: widget.projectName ?? '');
    _urlController = TextEditingController(text: widget.url ?? '');
    selectedManager = widget.selectedManager;    
    _fetchData(); // Fetch the necessary data when the widget initializes
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true; // Show loading while data is being fetched
    });

    try {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      final credentials = await _getCredentials();
      final email = credentials['email'];
      final orgSlug = widget.orgSlug;
      print("data is coming");
      print(widget.orgRoleId);
      print(widget.orgUserId);
      print(widget.orgUserorgId);
      // Fetch organization data
      if (email != null && orgSlug.isNotEmpty) {
        await organizationViewModel.getUserFunction(email, orgSlug);
        // Extract all orgUserEmail values
        final userOrgs = organizationViewModel.my_org;
        setState(() {
          managerEmails = userOrgs.map((user) => user.orgUserEmail).where((email) => email != null).cast<String>().toList();
        });        
      }
    } catch (e) {
      // Handle error fetching data
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }



  Future<Map<String, String>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    final email = await secureStorage.read(key: 'email');
    return {'email': email ?? ''};
  }

  
  Future<void> _createOrUpdateProject() async {
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

      //  Call the appropriate method for create or update based on whether projectName exists
        final response = await (widget.projectName == null
            ? organizationViewModel.createProject(
                loggedInUserEmail,
                _projectNameController.text,
                _urlController.text,
                selectedManager,
                widget.orgSlug,
                widget.orgRoleId,
                widget.orgUserId,
                widget.orgUserorgId,
              )
            : organizationViewModel.updateProject(
                loggedInUserEmail,
                _projectNameController.text,
                _urlController.text,
                selectedManager,
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
                builder: (context) => ProjectScreen(orgSlug: widget.orgSlug),
              ),
            );
          } else {
             print('coming inside else response');
        // Show error message in Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to create/update project.')),
        );
      }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating/updating project: $e')),
        );
      }
    }
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
        title: Text(widget.projectName == null ? 'Add New Project' : 'Edit Project'),
        content: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
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
                    TextFormField(
                      controller: _projectNameController,
                      decoration: InputDecoration(
                        labelText: 'Project Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a project name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                        TextFormField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  return null;
                },
                enabled: widget.id == null, // Disable the field if editing
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Project Manager',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                value: selectedManager,
                items: managerEmails.map((email) {
                  return DropdownMenuItem<String>(
                    value: email,
                    child: Text(email),
                  );
                }).toList(),
                onChanged: widget.id == null
                    ? (value) {
                        setState(() {
                          selectedManager = value;
                        });
                      }
                    : null, // Disable onChanged if editing
                validator: (value) {
                  if (value == null) {
                    return 'Please select a project manager';
                  }
                  return null;
                },
                disabledHint: Text(selectedManager ?? 'Unknown'), // Show selected manager when disabled
              ),
                  ],
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
                      onPressed: _createOrUpdateProject,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(widget.projectName == null ? 'Add' : 'Update'),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _urlController.dispose();
    super.dispose();
  }
}