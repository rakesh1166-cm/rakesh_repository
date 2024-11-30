import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/pagerank.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreatePagerankDialog extends StatefulWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;  
  final String? pageid;
  final String? projectId;
  final String? projectName;
  final String? url;
  final String? selectedUrlId;
  final String? pagerank;
  final String? authority;
  final String? gsplace;
  final String? bsplace;

  const CreatePagerankDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.pageid,
    this.projectId,
    this.projectName,
    this.url,
    this.selectedUrlId,
    this.pagerank,
    this.authority,
    this.gsplace,
    this.bsplace,
    Key? key,
  }) : super(key: key);

  @override
  _CreatePagerankDialogState createState() => _CreatePagerankDialogState();
}

class _CreatePagerankDialogState extends State<CreatePagerankDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _googlePagerankController = TextEditingController();
  final TextEditingController _pageAuthorityController = TextEditingController();
  final TextEditingController _googlePagePlacementController = TextEditingController();
  final TextEditingController _bsPagePlacementController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();
  
  List<DropdownMenuItem<String>> projectDropdownItems = [];
  List<DropdownMenuItem<String>> urlDropdownItems = [];
  String? selectedProject;
  String? selectedUrl;
  String? selectedProjectName;
  String? projectId;
  bool isLoading = false;
  String? selectedProjectId;
  String? selectedUrlId;
  String? selectedUrlName;
  List<String> keywords = [];
  bool isProjectSelected = false;

  @override
  void initState() {
    super.initState();
    _googlePagerankController.text = widget.pagerank ?? '';
    _pageAuthorityController.text = widget.authority ?? '';
    _googlePagePlacementController.text = widget.gsplace ?? '';
    _bsPagePlacementController.text = widget.bsplace ?? '';
    
    selectedProject = widget.projectId; 
    selectedProjectName = widget.projectName;
    selectedUrlId = widget.selectedUrlId;  // Retain selected URL ID
    
    _fetchData();

    if (widget.pageid != null) {
      projectId = widget.projectId;
      print("dropdown2 urlname is here");
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

      _populateProjectNamesAndUrls();
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _populateProjectNamesAndUrls() {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    
    if (organizationViewModel.my_projects != null && organizationViewModel.my_projects.isNotEmpty) {
      projectDropdownItems = organizationViewModel.my_projects.map((project) {
        return DropdownMenuItem<String>(
          value: project.id?.toString() ?? '',
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

    urlDropdownItems = organizationViewModel.my_urls.map((url) {
      return DropdownMenuItem<String>(
        value: url.id?.toString() ?? 'Unknown',
        child: Text(
          url.url ?? 'Unknown',
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();

    if (urlDropdownItems.isEmpty) {
      urlDropdownItems.add(
        DropdownMenuItem<String>(
          value: '',
          child: Text('No URLs available'),
        ),
      );
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

  Future<void> _createPagerank() async {
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
      // Call your API to create the pagerank
    
   final safeProjectId = selectedProjectId ?? '';
    final safeProjectName = selectedProjectName ?? 'Unknown';
    final safeUrlId = selectedUrlId ?? '';
    final safeUrlName = selectedUrlName ?? 'Unknown';

    if (widget.pageid != null) {
      // Update Pagerank (use safe fallback values for null checks)
      await organizationViewModel.updatePagerank(
        widget.pageid!,
        loggedInUserEmail,
        safeProjectId,
        safeProjectName,
        safeUrlId,
        _googlePagerankController.text,
        _pageAuthorityController.text,
        _googlePagePlacementController.text,
        _bsPagePlacementController.text,
        widget.orgSlug,
        widget.orgRoleId,
        widget.orgUserId,
        widget.orgUserorgId,
      );
    } else {
      // Create Pagerank (use safe fallback values for null checks)
      await organizationViewModel.createPagerank(
        loggedInUserEmail,
        safeProjectId,
        safeProjectName,
        safeUrlName,
        safeUrlId,
        _googlePagerankController.text,
        _pageAuthorityController.text,
        _googlePagePlacementController.text,
        _bsPagePlacementController.text,
        widget.orgSlug,
        widget.orgRoleId,
        widget.orgUserId,
        widget.orgUserorgId,
      );
    }


      setState(() {
        isLoading = false;
      });

       Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PageRank(orgSlug: widget.orgSlug),
          ),
        );
      
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  
                  
                    widget.pageid != null
                          ? TextFormField(
                              initialValue: selectedProjectName ?? 'Unknown',
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Project Name',
                                border: OutlineInputBorder(),
                              ),
                            )
                          : DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Project Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        value: projectDropdownItems.any((item) => item.value == projectId)
                            ? projectId
                            : null,  // Ensure projectId exists in the list
                        items: projectDropdownItems,
                        onChanged: (value) {
                          setState(() {
                            selectedProjectId = value;
                            isProjectSelected = true;
                            final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
                            final selectedProjectItem = organizationViewModel.my_projects.firstWhere(
                              (project) => project.id.toString() == value,
                            );
                            selectedProjectName = selectedProjectItem.projectName ?? 'Unknown';
                            _filterUrlsByProject(value);
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a project';
                          }
                          return null;
                        },
                      ),
      
      
      
                      SizedBox(height: 10),
                      widget.pageid != null
                          ? TextFormField(
                              initialValue: widget.url ?? 'Unknown',
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'URL',
                                border: OutlineInputBorder(),
                              ),
                            )
                          :  DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'URL',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        value: selectedUrlId,  // Retain selected URL ID if available
                        items: urlDropdownItems,
                        onChanged: (value) {
                          
                          setState(() {
                            selectedUrlId = value;
                            if (urlDropdownItems.any((item) => item.value == value)) {
                              final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
                              final selectedUrlItem = organizationViewModel.my_urls.firstWhere(
                                (url) => url.id.toString() == value,
                              );
                              selectedUrlName = selectedUrlItem.url ?? 'Unknown';
                            } else {
                              selectedUrlName = value;
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a URL';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      _buildNumericTextField('Google Pagerank', _googlePagerankController),
                      _buildNumericTextField('Page Authority', _pageAuthorityController),
                      _buildNumericTextField('Google S Page Placement', _googlePagePlacementController),
                      _buildNumericTextField('BS Page Placement', _bsPagePlacementController),
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
            onPressed: _createPagerank,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (!RegExp(r'^\d+$').hasMatch(value)) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _googlePagerankController.dispose();
    _pageAuthorityController.dispose();
    _googlePagePlacementController.dispose();
    _bsPagePlacementController.dispose();
    super.dispose();
  }
}