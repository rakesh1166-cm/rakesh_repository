import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/keywordscreen.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreateKeywordDialog extends StatefulWidget {
   final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;

  // Optional fields for editing
  final String? keywordId; // New parameter for keyword ID (edit mode)
  final List<String>? existingKeywords; // Pre-filled keywords for edit mode
  final String? selectedProjectId; // For the selected project in edit mode
  final String? selectedUrlId; // For the selected URL in edit mode
  final String? selectedUrlname; // For the selected URL in edit mode
  const CreateKeywordDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.keywordId,
    this.existingKeywords,
    this.selectedProjectId,
    this.selectedUrlId,
    this.selectedUrlname,
    Key? key,
  }) : super(key: key);

  @override
  _CreateKeywordDialogState createState() => _CreateKeywordDialogState();
}

class _CreateKeywordDialogState extends State<CreateKeywordDialog> {
  final TextEditingController _keywordController = TextEditingController();
  String? selectedProjectId;
  String? selectedProjectName;
  String? selectedUrlId;
  String? selectedUrlName;
  List<String> keywords = [];
  List<DropdownMenuItem<String>> projectDropdownItems = [];
  List<DropdownMenuItem<String>> urlDropdownItems = [];
  bool isLoading = false;
  bool isProjectSelected = false;

@override
void initState() {
  super.initState();
  _fetchData();

  // Ensure selectedProjectId and selectedUrlId are set correctly in edit mode
  if (widget.keywordId != null) {
    selectedProjectId = widget.selectedProjectId;
    selectedUrlId = widget.selectedUrlId; // Pre-select the URL in edit mode
     selectedUrlName = widget.selectedUrlname; // Pre-select the URL in edit mode
    keywords = widget.existingKeywords ?? [];
     print("dropdown2 urlname is here");

    print(selectedUrlName);

  }
}

Future<void> _fetchData() async {


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

    await organizationViewModel.getUrl(
      email.toString(),
      widget.orgSlug,
      widget.orgRoleId,
      widget.orgUserId,
      widget.orgUserorgId,
    );

    _populateProjectNamesAndUrls(); // Populate project and URL dropdown items

    // Ensure the selected URL is still valid and pre-selected
    if (widget.keywordId != null) {
      selectedProjectId = widget.selectedProjectId;
      selectedUrlId = widget.selectedUrlId;  // Pre-select the URL in edit mode
    }

    print("Dropdown Items: ${projectDropdownItems.map((item) => item.value).toList()}");
    print("Selected Value: $selectedProjectId");
  } catch (e) {
    print('Error fetching data: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

// Modify _populateProjectNamesAndUrls function
void _populateProjectNamesAndUrls() {
  final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

  // Populate Project Dropdown Items
  if (organizationViewModel.my_projects != null && organizationViewModel.my_projects.isNotEmpty) {
    projectDropdownItems = organizationViewModel.my_projects.map((project) {
      return DropdownMenuItem<String>(
        value: project.id?.toString() ?? '',
        child: Text(
          project.projectName ?? 'Unknown',
          overflow: TextOverflow.ellipsis,
        ),
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

  // Populate URL Dropdown Items
  urlDropdownItems = organizationViewModel.my_urls.map((url) {
    return DropdownMenuItem<String>(
      value: url.id?.toString() ?? '',
      child: Text(
        url.url ?? 'Unknown',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }).toList();

  // Only add selected URL in edit mode if it’s not already in the list
  if (widget.selectedUrlId != null && widget.selectedUrlname != null) {
    bool isAlreadyInDropdown = urlDropdownItems.any((item) => item.value == widget.selectedUrlId);
    if (!isAlreadyInDropdown) {
      urlDropdownItems.add(
        DropdownMenuItem<String>(
          value: widget.selectedUrlId,
          child: Text(widget.selectedUrlname!),
        ),
      );
    }
  }
}

  Future<Map<String, String>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    final email = await secureStorage.read(key: 'email');
    return {'email': email ?? ''};
  }

void _filterUrlsByProject(String? projectId) {
  final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

  if (projectId != null && organizationViewModel.my_urls.isNotEmpty) {
    final filteredUrls = organizationViewModel.my_urls.where((url) {
      return url.projectId?.toString() == projectId; // Filter URLs by projectId
    }).toList();

    setState(() {
      urlDropdownItems = filteredUrls.map((url) {
        return DropdownMenuItem<String>(
          value: url.id?.toString() ?? '', // Ensure the URL has a valid value
          child: Text(
            url.url ?? 'Unknown',  // Display URL or 'Unknown' if null
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList();

      // If no URLs are available for the selected project, add a fallback
      if (urlDropdownItems.isEmpty) {
        urlDropdownItems.add(
          DropdownMenuItem<String>(
            value: '',
            child: Text('No URLs available for this project'),
          ),
        );
      }
      // Reset the selectedUrlId if it's not in the filtered list
      if (selectedUrlId != null && !urlDropdownItems.any((item) => item.value == selectedUrlId)) {
        selectedUrlId = null;
      }
    });
  } else {
    setState(() {
      urlDropdownItems = [
        DropdownMenuItem<String>(
          value: '',
          child: Text('Select URL'),
        ),
      ];
      selectedUrlId = null;  // Reset URL selection if no project is selected
    });
  }
}

  void _addKeyword() {
    String keywordText = _keywordController.text.trim();
    if (keywordText.isNotEmpty) {
      setState(() {
        keywords.add(keywordText);
        _keywordController.clear();
      });
    }
  }

  List<Widget> _buildKeywordChips() {
    return keywords.map((keyword) {
      return Chip(
        label: Text(
          keyword,
          overflow: TextOverflow.ellipsis,
        ),
        onDeleted: () {
          setState(() {
            keywords.remove(keyword);
          });
        },
      );
    }).toList();
  }

Future<void> _createKeyword() async {
  if (selectedProjectId != null && selectedUrlId != null && keywords.isNotEmpty) {
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

      // Ensure that selectedProjectName and selectedUrlName are not null
      selectedProjectName ??= 'Unknown';
      selectedUrlName ??= 'Unknown';

      // Check if it's an edit action
      final response = await (widget.keywordId == null
          ? organizationViewModel.createKeyword(
              loggedInUserEmail,
              selectedProjectId!,
              selectedUrlId!,
              keywords,
              widget.orgSlug,
              widget.orgRoleId,
              widget.orgUserId,
              widget.orgUserorgId,
              selectedProjectName!,  // Ensure this is not null
              selectedUrlName!,      // Ensure this is not null
            )
          : organizationViewModel.updateKeyword(
              widget.keywordId!, // Pass the keyword ID for update
              loggedInUserEmail,
              selectedProjectId!,
              selectedUrlId!,
              keywords,
              widget.orgSlug,
              widget.orgRoleId,
              widget.orgUserId,
              widget.orgUserorgId,
              selectedProjectName!,  // Ensure this is not null
              selectedUrlName!,      // Ensure this is not null
            ));

      setState(() {
        isLoading = false;
      });

      if (response['success'] == true) {
        print("Keyword ${widget.keywordId == null ? 'created' : 'updated'} successfully");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => KeywordScreen(orgSlug: widget.orgSlug),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to create/update keyword')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error creating/updating keyword: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating/updating keyword: $e')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all fields and add at least one keyword')),
    );
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
        title: Text('Add New Keyword'),
        content: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9), // Constrain dialog width
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
      labelText: 'Project Name',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
        ),
        value: projectDropdownItems.any((item) => item.value == selectedProjectId)
        ? selectedProjectId
        : null,  // Fallback to null if selectedProjectId is not in the list
        items: projectDropdownItems,
        onChanged: widget.keywordId == null
        ? (value) {
            setState(() {
              selectedProjectId = value;
              selectedUrlId = null;  // Reset URL selection when project changes
              isProjectSelected = true;
      
              // Find the selected project and get the projectName
              final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
              final selectedProjectItem = organizationViewModel.my_projects.firstWhere(
                (project) => project.id.toString() == value, // Use unique ID as the value
              );
              selectedProjectName = selectedProjectItem.projectName ?? 'Unknown'; // Store project name
      
              // Refilter URLs based on the new selected project
              _filterUrlsByProject(value);
            });
          }
        : null,  // Disable if in edit mode
        validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please select a project';
      }
      return null;
        },
        disabledHint: Text(selectedProjectName ?? 'Unknown'), // Show project name when disabled
      ),
         
      SizedBox(height: 10),
      
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
      labelText: 'URL',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
        ),
        value: urlDropdownItems.any((item) => item.value == selectedUrlId)
        ? selectedUrlId
        : null,  // Fallback to null if selectedUrlId is not in the list
        items: urlDropdownItems,
        onChanged: widget.keywordId == null
        ? (value) {
            setState(() {
              selectedUrlId = value;
              final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
              final selectedUrlItem = organizationViewModel.my_urls.firstWhere(
                (url) => url.id.toString() == value,
              );
              selectedUrlName = selectedUrlItem.url ?? 'Unknown';
            });
          }
        : null,  // Disable if in edit mode
        validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please select a URL';
      }
      return null;
        },
        disabledHint: Text(selectedUrlName ?? 'Unknown'), // Show selected URL when disabled
      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: _buildKeywordChips(),
                      ),
                      TextField(
                        controller: _keywordController,
                        decoration: InputDecoration(
                          labelText: 'Enter a keyword',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: _addKeyword,
                          ),
                        ),
                        onSubmitted: (_) => _addKeyword(),
                      ),
                      SizedBox(height: 10),
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
          ElevatedButton(
            onPressed: _createKeyword,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }
}
