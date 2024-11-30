import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreateSocialrankDialog extends StatefulWidget {
 final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;
  final String? projectName; // New parameter for project name
  final String? fbLikes; // New parameter for Facebook likes
  final String? ytSubscribers; // New parameter for YouTube subscribers
  final String? twitterFollowers; // New parameter for Twitter followers
  final String? instagramFollowers; // New parameter for Instagram followers
  final String? createdAt; // New parameter for creation date
  final int? id; // New parameter for ID

  const CreateSocialrankDialog({
     required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.projectName, // Optional
    this.fbLikes, // Optional
    this.ytSubscribers, // Optional
    this.twitterFollowers, // Optional
    this.instagramFollowers, // Optional
    this.createdAt, // Optional
    this.id, // Optional
    Key? key,
  }) : super(key: key);

  @override
  _CreateSocialrankDialogState createState() => _CreateSocialrankDialogState();
}

class _CreateSocialrankDialogState extends State<CreateSocialrankDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _youtubeSubscribersController = TextEditingController();
  final TextEditingController _twitterFollowersController = TextEditingController();
  final TextEditingController _instagramFollowersController = TextEditingController();
  final TextEditingController _facebookLikesController = TextEditingController();

  List<DropdownMenuItem<String>> projectDropdownItems = [];
  String? selectedProject;
  String? selectedProjectName;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProjectData();

    // Initialize controllers with existing values for editing
    if (widget.id != null) { // Check if we are in edit mode
      _youtubeSubscribersController.text = widget.ytSubscribers ?? '';
      _twitterFollowersController.text = widget.twitterFollowers ?? '';
      _instagramFollowersController.text = widget.instagramFollowers ?? '';
      _facebookLikesController.text = widget.fbLikes ?? '';
      selectedProject = widget.projectName; // Optionally set selected project if applicable
    }
  }

  // Fetch project data and then the project names
  
  Future<void> _fetchProjectData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      final credentials = await _getCredentials();
      final email = credentials['email'];
      // Fetch the projects from the API
      await organizationViewModel.getProject(
        email.toString(),
        widget.orgSlug,
        widget.orgRoleId,
        widget.orgUserId,
        widget.orgUserorgId,
      );
      _fetchProjectNames();
    } catch (e) {
      print('Error fetching project data: $e');
    } finally {
      setState(() {
        isLoading = false;
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
        title: Text(widget.id != null ? 'Edit Social Ranking' : 'Add New Social Ranking'), // Adjust title based on edit or add
        content: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                       key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              //  Project Name Dropdown
                if (widget.id != null) ...[
                  // Display the project name in a read-only TextField
                      TextField(
                      decoration: InputDecoration(
                        labelText: widget.projectName, // Optionally, you can change this to a static label if needed
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: selectedProjectName), // Use the selected project name
                      enabled: false, // Disable the TextField
                    ),
                ] else ...[
                  // If not in edit mode, show the DropdownButtonFormField
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Please Select Your Project Name First',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedProject,
                    items: projectDropdownItems,
                    onChanged: (value) {
                      setState(() {
                        selectedProject = value;
                        final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
                        final selectedProjectItem = organizationViewModel.my_projects.firstWhere(
                          (project) => project.id.toString() == value,
                        );
                        selectedProjectName = selectedProjectItem.projectName ?? 'Unknown';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a project';
                      }
                      return null;
                    },
                  ),
                ],
                                SizedBox(height: 10),
                                // YouTube Subscribers Field
                                _buildTextField('YouTube Subscribers', _youtubeSubscribersController),
                                // Twitter Followers Field
                                _buildTextField('Twitter Followers', _twitterFollowersController),
                                // Instagram Followers Field
                                _buildTextField('Instagram Followers', _instagramFollowersController),
                                // Facebook Likes Field
                                _buildTextField('Facebook Likes', _facebookLikesController),
                              ],
                            ),
                          ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _createSocialRank();
              }
            },
            child: Text(widget.id != null ? 'Update' : 'Add'), // Adjust button text based on action
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  // Function to handle form submission and API call
  Future<void> _createSocialRank() async {
    setState(() {
      isLoading = true;
    });

    try {
      final credentials = await _getCredentials();
      final loggedInUserEmail = credentials['email'];

      if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User email is required')));
        setState(() {
          isLoading = false;
        });
        return;
      }

      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

      // Call your API to create the social rank
      final response = await organizationViewModel.createSocialRank(
        loggedInUserEmail, 
        selectedProject!, 
        selectedProjectName!,
        _youtubeSubscribersController.text,
        _twitterFollowersController.text, 
        _instagramFollowersController.text, 
        _facebookLikesController.text, 
        widget.orgSlug, 
        widget.orgRoleId, 
        widget.orgUserId, 
        widget.orgUserorgId
      );

      setState(() {
        isLoading = false;
      });

      if (response['success'] == true) {
        print("Social Rank created successfully");
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Failed to create Social Rank')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _youtubeSubscribersController.dispose();
    _twitterFollowersController.dispose();
    _instagramFollowersController.dispose();
    _facebookLikesController.dispose();
    super.dispose();
  }
}