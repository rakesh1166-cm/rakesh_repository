import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/webassetscreen.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreateWebsiteAssetDialog extends StatefulWidget {
 final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;
  final String? projectName;
  final String? Tasktype;
  final String? webname;
  final String? token_engineer;
  final String? username;
  final String? email;   
  final String? password;
  final String? pro_name;
  final String? pro_engg;
 final String? type;  
  final int? id;
 

  const CreateWebsiteAssetDialog({
  required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.projectName,
    this.Tasktype,
    this.webname,
    this.token_engineer,
    this.username,
    this.email,
    this.password,
    this.pro_name,
    this.pro_engg,
    this.type,
    this.id,
        Key? key,
  }) : super(key: key);

  @override
  _CreateWebsiteAssetDialogState createState() => _CreateWebsiteAssetDialogState();
}

class _CreateWebsiteAssetDialogState extends State<CreateWebsiteAssetDialog> {
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _websiteController = TextEditingController();

  String? selectedProjectId;
  String? selectedTokenId;
  String? emails;
  String? selectedProjectName;
  String? selectedAssetType;
  String? selectedPublicKey;
  String? selectedManager; // Added for project manager selection

  List<DropdownMenuItem<String>> projectDropdownItems = [];
  List<DropdownMenuItem<String>> tokenDropdownItems = [];
  List<DropdownMenuItem<String>> assetTypeDropdownItems = [
    DropdownMenuItem(value: 'Social Media Sites', child: Text('Social Media Sites')),
    DropdownMenuItem(value: 'Social Bookmarking Sites', child: Text('Social Bookmarking Sites')),
    DropdownMenuItem(value: 'Video Submission Sites', child: Text('Video Submission Sites')),
    DropdownMenuItem(value: 'Images Submission Sites', child: Text('Images Submission Sites')),
    DropdownMenuItem(value: 'Blogs Submission Sites', child: Text('Blogs Submission Sites')),
    DropdownMenuItem(value: 'Articles Submission Sites', child: Text('Articles Submission Sites')),
    DropdownMenuItem(value: 'Forums Sites', child: Text('Forums Sites')),
    DropdownMenuItem(value: 'Social Media data', child: Text('Social Media data')),
    DropdownMenuItem(value: 'Press Releases', child: Text('Press Releases')),
    DropdownMenuItem(value: 'News News', child: Text('News News')),
    DropdownMenuItem(value: 'Web pages Sites', child: Text('Web pages Sites')),
    DropdownMenuItem(value: 'Location data', child: Text('Location data')),
    DropdownMenuItem(value: 'Podcasts', child: Text('Podcasts')),
  ];
  List<DropdownMenuItem<String>> publicKeyDropdownItems = [
    DropdownMenuItem(value: 'Token1', child: Text('Token1')),
    DropdownMenuItem(value: 'Token2', child: Text('Token2')),
    DropdownMenuItem(value: 'Token3', child: Text('Token3')),
    // Add other tokens as needed
  ];

  // Dynamic list of manager emails
  List<String> managerEmails = [];
  
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print("type of asset coming");
     _websiteController.text = widget.webname ?? '';
      print(widget.Tasktype);
      print(widget.projectName);
      print(widget.Tasktype);
      print(widget.projectName);
      print(widget.Tasktype);
      print(widget.pro_engg);

      selectedProjectId = widget.projectName; // This should ideally match the project IDs in projectDropdownItems
      selectedTokenId= widget.token_engineer; // This should ideally match the project IDs in projectDropdownItems
      selectedAssetType = widget.Tasktype; // This should match the asset type in assetTypeDropdownItems
      emails = widget.email; // This should match the asset type in assetTypeDropdownItems
      selectedManager = widget.pro_engg; 

     _emailController = TextEditingController(text: widget.email ?? '');
    _usernameController = TextEditingController(text: widget.username ?? '');
     _passwordController = TextEditingController(text: widget.password ?? '');

    _fetchProjects(); // Fetch the projects or any initial data here
     _fetchToken(); // Fetch the projects or any initial data here
    _fetchManagers(); // Fetch project managers


  }

  Future<void> _fetchProjects() async {
    setState(() {
      isLoading = true;
    });
    try {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      final credentials = await _getCredentials();
      final email = credentials['email'];
      await organizationViewModel.getProject(
        email.toString(),
        widget.orgSlug,
        widget.orgRoleId,
        widget.orgUserId,
        widget.orgUserorgId,
      );

   if (widget.id != null) {
      // If widget.id is not null, filter or modify the dropdown items accordingly
      projectDropdownItems = organizationViewModel.my_projects.where((project) {
        // For example, filter out the project with the given ID
        return project.id != widget.id; // Exclude the project with the given ID
      }).map((project) {
        return DropdownMenuItem<String>(
          value: project.projectName?.toString(), // Ensure this ID is unique
          child: Text(project.projectName ?? 'Unknown'),
        );
      }).toList();
    } else {
      // If widget.id is null, create dropdown items normally
      projectDropdownItems = organizationViewModel.my_projects.map((project) {
        return DropdownMenuItem<String>(
          value: project.id?.toString(), // Ensure this ID is unique
          child: Text(project.projectName ?? 'Unknown'),
        );
      }).toList();
    }


    } catch (e) {
      print('Error fetching projects: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

    Future<void> _fetchToken() async {
    setState(() {
      isLoading = true;
    });

    try {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      final credentials = await _getCredentials();
      final email = credentials['email'];

      await organizationViewModel.getToken(
        email.toString(),
        widget.orgSlug,
        widget.orgRoleId,
        widget.orgUserId,
        widget.orgUserorgId,
      );
   if (widget.id != null && widget.type == "asset") {
      // If widget.id is not null, filter or modify the dropdown items accordingly
      tokenDropdownItems = organizationViewModel.my_tokens.where((token) {
        // For example, filter out the project with the given ID
        return token.id != widget.id; // Exclude the project with the given ID
      }).map((token) {
        return DropdownMenuItem<String>(
          value: token.token?.toString(), // Ensure this ID is unique
          child: Text(token.token ?? 'Unknown'),
        );
      }).toList();
    } else {
      // If widget.id is null, create dropdown items normally
     tokenDropdownItems = organizationViewModel.my_tokens.map((token) {
        return DropdownMenuItem<String>(
          value: token.id?.toString(),
          child: Text(token.token ?? 'Unknown'),
        );
      }).toList();
    }      
    } catch (e) {
      print('Error fetching projects: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchManagers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      final credentials = await _getCredentials();
      final email = credentials['email'];

      await organizationViewModel.getUserFunction(email.toString(), widget.orgSlug);
      // Extract manager emails from organization view model
      final userOrgs = organizationViewModel.my_org;
      setState(() {
        managerEmails = userOrgs.map((user) => user.orgUserEmail).where((email) => email != null).cast<String>().toList();
      });
    } catch (e) {
      print('Error fetching managers: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, String>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    final email = await secureStorage.read(key: 'email');
    return {'email': email ?? ''};
  }

 Future<void> _createWebsiteAsset() async {
  if (_emailController.text.isNotEmpty &&
      _usernameController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _websiteController.text.isNotEmpty &&
      selectedProjectId != null &&
      selectedTokenId != null &&        
      selectedAssetType != null &&     
      selectedManager != null) { // Validate selected manager

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

   //   Determine whether to create or update based on the presence of the ID
      final response = await (widget.id == null
          ? organizationViewModel.createWebsiteAsset(
              loggedInUserEmail,
              _emailController.text,
              _usernameController.text,
              _passwordController.text,
              _websiteController.text,
              selectedProjectId,
              selectedAssetType,
              selectedTokenId,
              selectedManager,
              widget.orgSlug,
              widget.orgRoleId,
              widget.orgUserId,
              widget.orgUserorgId,
            )
          : organizationViewModel.updateWebsiteAsset(
              widget.id!,
              loggedInUserEmail,
              _emailController.text,
              _usernameController.text,
              _passwordController.text,
              _websiteController.text,
              selectedProjectId,
              selectedAssetType,
              selectedTokenId,
              selectedManager,
              widget.orgSlug,
              widget.orgRoleId,
              widget.orgUserId,
              widget.orgUserorgId,
            ));

      setState(() {
        isLoading = false;
      });

      if (response['success'] == true) {
        Navigator.of(context).pop(); // Close the dialog
        // Optionally navigate to another screen or show a success message
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WebassetScreen(orgSlug: widget.orgSlug),
          ),
        );
      } else {
        // Show error message in Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to create/update website asset.')),
        );
      }


    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating/updating website asset: $e')),
      );
    }
  } else {
    // Show validation error message
    print('Please fill all fields');
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
        title: Text('Create Website Asset'),
        content: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     _buildDropdown(
                    'Type of Assets',
                    selectedAssetType,
                    assetTypeDropdownItems,
                    (value) {
                      setState(() {
                        selectedAssetType = value;
                      });
                    },
                    hint: widget.Tasktype != null && widget.Tasktype!.isNotEmpty ? widget.Tasktype : 'Select Type of Asset', // Provide dynamic hint
                  ),
                  SizedBox(height: 5),
                  _buildTextField(_emailController, 'Email Address'),
                  SizedBox(height: 5),
                  _buildTextField(_websiteController, 'Website (Domain Name)'),
                  SizedBox(height: 5),
                  _buildTextField(_usernameController, 'User Name'),
                  SizedBox(height: 5),
                  _buildTextField(_passwordController, 'Password', isObscure: true),
                  SizedBox(height: 5),
                  _buildDropdown(
                    'Project Name',
                    selectedProjectId,
                    projectDropdownItems,
                    (value) {
                      setState(() {
                        selectedProjectId = value;
                      });
                    },
                    hint: widget.projectName != null && widget.projectName!.isNotEmpty ? widget.projectName : 'Select Project Name', // Provide dynamic hint
                  ),                  
                  SizedBox(height: 5),
      
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
                          onChanged: (value) { // Allow changing even if editing
                            setState(() {
                              selectedManager = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a project manager';
                            }
                            return null;
                          },
                        ),
            
                     SizedBox(height: 5),                
               _buildDropdown(
                   'Select Token',
                    selectedTokenId,
                    tokenDropdownItems,
                    (value) {
                      setState(() {
                        selectedTokenId = value;
                      });
                    },
                    hint: widget.token_engineer != null && widget.token_engineer!.isNotEmpty ? widget.token_engineer : 'Select token Name', // Provide dynamic hint
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
          ElevatedButton(
            onPressed: _createWebsiteAsset,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isObscure = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      obscureText: isObscure,
    );
  }

Widget _buildDropdown(String label, String? value, List<DropdownMenuItem<String>> items, ValueChanged<String?> onChanged, {String? hint}) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: label,
      hintText: hint, // Add hint text here
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
    ),
    value: value,
    items: items,
    onChanged: onChanged,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please select $label';
      }
      return null;
    },
  );
}

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
}
