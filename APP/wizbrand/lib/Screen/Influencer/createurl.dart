import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/urlscreen.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreateUrlDialog extends StatefulWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;
  final int? urlid; // Change this to int?
  final String? url; // For editing, optional
  final String? selectedProject; // For editing, optional

  const CreateUrlDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.urlid, // Add projectId for edit
    this.url, // Allow prefilled URL for editing
    this.selectedProject, // Allow prefilled project for editing
    Key? key,
  }) : super(key: key);

  @override
  _CreateUrlDialogState createState() => _CreateUrlDialogState();
}

class _CreateUrlDialogState extends State<CreateUrlDialog> {
  final TextEditingController _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> projectDropdownItems = [];
  String? selectedProject;
  String? selectedProjectName; // Store the selected project name
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if available (for editing)
    _urlController.text = widget.url ?? ''; // Prepopulate with passed URL
    selectedProject = widget.selectedProject; // Prepopulate with selected project
    _fetchProjectData();
  }

  // Fetch project data and then the project names
  Future<void> _fetchProjectData() async {
    setState(() {
      isLoading = true; // Show loading indicator while fetching
    });
    try {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      final credentials = await _getCredentials();
      final email = credentials['email'];
      // Fetch the projects from the API
      await organizationViewModel.getProject(
        email.toString(), // Replace with actual email or dynamic email
        widget.orgSlug,
        widget.orgRoleId,
        widget.orgUserId,
        widget.orgUserorgId,
      );
      // Now fetch project names after project data is fetched
      _fetchProjectNames();
    } catch (e) {
      print('Error fetching project data: $e');
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  // Fetch project names from already populated project data
  Future<void> _fetchProjectNames() async {
    try {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      // Check if my_projects is populated
      if (organizationViewModel.my_projects != null && organizationViewModel.my_projects.isNotEmpty) {
        projectDropdownItems = organizationViewModel.my_projects.map((project) {
          return DropdownMenuItem<String>(
            value: project.id?.toString() ?? '', // Check for null values
            child: Text(project.projectName ?? 'Unknown'),
          );
        }).toList();
      } else {
        projectDropdownItems = [
          DropdownMenuItem<String>(
            value: '',
            child: Text('No projects available'),
          ),
        ];
      }
    } catch (e) {
      print('Error fetching project names: $e');
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
        title: Text(widget.urlid != null ? 'Edit URL' : 'Add New URL'), // Update title based on edit or create mode
        content: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loader while data is being fetched
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // URL Text Field
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
                          return 'Please enter a valid URL';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    // Project Name Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Project Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                      value: selectedProject,
                      items: projectDropdownItems,
                      onChanged: widget.urlid == null
                          ? (value) {
                              setState(() {
                                selectedProject = value;
                                // Find the selected project name
                                final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
                                final selectedProjectItem = organizationViewModel.my_projects.firstWhere(
                                  (project) => project.id.toString() == value,
                                );
                                selectedProjectName = selectedProjectItem.projectName ?? 'Unknown'; // Save project name
                              });
                            }
                          : null, // Disable onChanged if in edit mode
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a projectmy';
                        }
                        return null;
                      },
                      // Disable the dropdown if editing an existing project
                      disabledHint: Text(selectedProjectName ?? 'Unknown'),
                    ),
                  ],
                ),
              ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _createProject(); // Call the function to create project and send data to backend
            },
            child: Text(widget.urlid != null ? 'Update' : 'Add'), // Button text based on mode
          ),
        ],
      ),
    );
  }

  // Function to handle form submission and API call
  Future<void> _createProject() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      try {
        // Fetch the logged-in user's email (replace with your actual logic)
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

        // Ensure that `selectedProjectName` and `selectedProject` are non-null
     // **Apply this check only during creation**
      if (widget.urlid == null && (selectedProject == null || selectedProjectName == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a project')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

        // Call your API to create or update the URL
        final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
        final response = widget.url == null
            ? await organizationViewModel.createUrl(
                loggedInUserEmail,
                selectedProject!,
                _urlController.text,
                selectedProjectName!,
                widget.orgSlug,
                widget.orgRoleId,
                widget.orgUserId,
                widget.orgUserorgId,
              )
            : await organizationViewModel.updateUrl(
                loggedInUserEmail,
              
                _urlController.text,
              
                widget.urlid.toString(),
                widget.orgSlug,
                widget.orgRoleId,
                widget.orgUserId,
                widget.orgUserorgId,
              );

        setState(() {
          isLoading = false; // Hide loading indicator
        });

        // Check if the response was successful
        if (response['success'] == true) {
          print("URL created/updated successfully");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UrlScreen(orgSlug: widget.orgSlug),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Failed to create/update URL')),
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error creating/updating URL: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating/updating URL: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
