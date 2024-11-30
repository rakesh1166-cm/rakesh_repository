import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wizbrand/Screen/Influencer/taskboard.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreateTaskboardDialog extends StatefulWidget {
   final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;
  final String? taskTitle; // Existing task title
  final String? projectName; // Existing project name
  final String? projectId; // Existing project name  
  final String? userEmail; // Existing user email
  final String? taskDeadline; // Existing task deadline
  final String? status; // Existing status
  final String? webUrl; // Existing web URL
  final String? keyword; // Existing keyword
  final String? sevirty; // Existing severity
  final String? document; // Existing document
  final String? description; // Existing description
  final String? tasktype; // Existing description
    final int? id;
  

  const CreateTaskboardDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.taskTitle, // Optional
    this.projectName, // Optional
    this.projectId, // Optional
    this.userEmail, // Optional
    this.taskDeadline, // Optional
    this.status, // Optional
    this.webUrl, // Optional
    this.keyword, // Optional
    this.sevirty, // Optional
    this.document, // Optional
    this.description, // Optional
     this.tasktype, // Optional
      this.id,
    Key? key,
  }) : super(key: key);

  @override
  _CreateTaskboardDialogState createState() => _CreateTaskboardDialogState();
}

class _CreateTaskboardDialogState extends State<CreateTaskboardDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDeadlineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _descController = TextEditingController();
  

  String? existingDocument; // To store the existing document name
  // Additional Controllers

  
//projectName,webUrl,keyword,userEmail
  final TextEditingController _assignedToController = TextEditingController();
List<String> projectManagerEmails = []; // List to hold project managers
List<String> projectweburl = []; // List to hold project managers
 bool hasKeywords = false; // Boolean variable to indicate if keywords are available
  bool additionalCondition = false; // Declare additionalCondition here

  String? selectedProjectId;
  String? selectedUrl;
  String? selectedSeverity;
  String? selectedTaskType;
  String? selectedAssignedUser;
  PlatformFile? selectedFile;  
  List<DropdownMenuItem<String>> projectDropdownItems = [];
  List<DropdownMenuItem<String>> urlDropdownItems = [];
  List<DropdownMenuItem<String>> keywordDropdownItems = [];
    List<DropdownMenuItem<String>> mykeywordDropdownItems = [];
  
  List<DropdownMenuItem<String>> severityDropdownItems = [];
  List<DropdownMenuItem<String>> taskTypeDropdownItems = [];
  List<DropdownMenuItem<String>> assignedUserDropdownItems = [];

  String? selectedProjectManager; // To hold the selected project manager
  List<String> selectedKeywords = []; // Store the selected keywords
  bool isLoading = false;

    @override
void initState() {
  super.initState();
  
  // Initialize controllers with data passed to the dialog or default values
  _taskTitleController.text = widget.taskTitle ?? '';
  _taskDeadlineController.text = widget.taskDeadline ?? '';
  _descriptionController.text = widget.description ?? '';
   _descController.text="mydata" ?? '';
  // Handle the existing document as a string (file path or URL)
  existingDocument = widget.document;  
  selectedUrl = widget.webUrl;
  selectedSeverity = widget.sevirty;
  selectedTaskType = widget.tasktype;
  selectedProjectManager = widget.userEmail;
  // Fetch necessary dropdown data
  _fetchData();
  _populateSeverityDropdown();
  _populateTaskTypeDropdown();
}


  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      final credentials = await _getCredentials();
      final email = credentials['email'];

      await Future.wait([
        organizationViewModel.getProject(email.toString(), widget.orgSlug, widget.orgRoleId, widget.orgUserId, widget.orgUserorgId),
        organizationViewModel.getUrl(email.toString(), widget.orgSlug, widget.orgRoleId, widget.orgUserId, widget.orgUserorgId),
        organizationViewModel.getKeyword(email.toString(), widget.orgSlug, widget.orgRoleId, widget.orgUserId, widget.orgUserorgId),
        organizationViewModel.getUserFunction(email.toString(), widget.orgSlug), // Fetch assigned users
      ]);
 await organizationViewModel.getUserFunction(email.toString(), widget.orgSlug);
        
        // Extract all orgUserEmail values
        final userOrgs = organizationViewModel.my_org;
        final webmyurls =  organizationViewModel.my_urls;
        //projectweburl       
  // Corrected to filter and populate based on projectId match
        if (widget.id != null) {
          setState(() {
            projectweburl = webmyurls
              .where((url) => url.projectId.toString() == widget.projectId) // Filter by matching projectId
              .map((url) => url.url) // Assuming you're interested in the URL
              .where((url) => url != null)
              .cast<String>()
              .toList(); // Convert to list of URLs
          });
        }
        setState(() {
            projectManagerEmails = userOrgs.map((user) => user.orgUserEmail).where((email) => email != null).cast<String>().toList();       
        });
      _populateProjectDropdown();
      _populateAssignedUserDropdown();
    } catch (e) {
      print('Error fetching data: $e');
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

  void _populateProjectDropdown() {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

    projectDropdownItems = organizationViewModel.my_projects.map((project) {
      return DropdownMenuItem<String>(
        value: project.id?.toString() ?? '',
        child: Text(
          project.projectName ?? 'Unknown',
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

void _populateSeverityDropdown() {
  severityDropdownItems = [
    DropdownMenuItem(value: 'Most Important', child: Text('Most Important')),
    DropdownMenuItem(value: 'Moderately Important', child: Text('Moderately Important')),
    DropdownMenuItem(value: 'Important', child: Text('Important')),
    DropdownMenuItem(value: 'Regular', child: Text('Regular')),
  ];
}

void _populateTaskTypeDropdown() {
  taskTypeDropdownItems = [
    DropdownMenuItem(value: 'SEO', child: Text('SEO')),
    DropdownMenuItem(value: 'SBM', child: Text('SBM')),
    DropdownMenuItem(value: 'Anchor tags', child: Text('Anchor tags')),
    DropdownMenuItem(value: 'Forum Posting', child: Text('Forum Posting')),
    DropdownMenuItem(value: 'Meta Titles', child: Text('Meta Titles')),
    DropdownMenuItem(value: 'Site Speed', child: Text('Site Speed')),
    DropdownMenuItem(value: 'Content Writing', child: Text('Content Writing')),
    DropdownMenuItem(value: 'Internal linking', child: Text('Internal linking')),
    DropdownMenuItem(value: 'Mobile-Friendly', child: Text('Mobile-Friendly')),
    DropdownMenuItem(value: 'Image Alt-text', child: Text('Image Alt-text')),
    DropdownMenuItem(value: 'Meta Descriptions', child: Text('Meta Descriptions')),
    DropdownMenuItem(value: 'Blog Submission', child: Text('Blog Submission')),
    DropdownMenuItem(value: 'Image Submission', child: Text('Image Submission')),
    DropdownMenuItem(value: 'Video Submission', child: Text('Video Submission')),
    DropdownMenuItem(value: 'Meta Description', child: Text('Meta Description')),
    DropdownMenuItem(value: 'Social Networking', child: Text('Social Networking')),
    DropdownMenuItem(value: 'Guest Author', child: Text('Guest Author')),
    DropdownMenuItem(value: 'Article Submission', child: Text('Article Submission')),
    DropdownMenuItem(value: 'Link building', child: Text('Link building')),
  ];
}

  void _populateAssignedUserDropdown() {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

    assignedUserDropdownItems = organizationViewModel.my_org.map((user) {
      return DropdownMenuItem<String>(
        value: user.invitedByEmail,
        child: Text(user.invitedByEmail ?? user.invitedByEmail ?? 'Unknown', overflow: TextOverflow.ellipsis),
      );
    }).toList();
  }


  void _filterUrlsByProject(String? projectId) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

    if (projectId != null && organizationViewModel.my_urls.isNotEmpty) {
      final filteredUrls = organizationViewModel.my_urls.where((url) {
        return url.projectId?.toString() == projectId;
      }).toList();

      setState(() {
        urlDropdownItems = filteredUrls.map((url) {
          return DropdownMenuItem<String>(
            value: url.id?.toString() ?? 'Unknown',
            child: Text(
              url.url ?? 'Unknown',
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();

        print("urldropdownitem coming");
         print(urlDropdownItems);

      });
    }
  }
  
  void _removeSelectedKeyword(String keyword) {
    setState(() {
      selectedKeywords.remove(keyword);
    });
  }
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpeg', 'jpg', 'png','pem'],
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }
    void _addSelectedKeyword(String? keyword) {
  if (keyword != null && keyword.isNotEmpty) {
    List<String> splitKeywords = keyword.split(',').map((k) => k.trim()).toList(); // Split and trim individual keywords
    setState(() {
      // Track if any new keywords were added
      bool addedNewKeyword = false;
      
      for (var k in splitKeywords) {
        if (!selectedKeywords.contains(k)) {
          selectedKeywords.add(k); // Add only if it doesn't already exist
          addedNewKeyword = true; // Mark that a new keyword has been added
        }
      }
      // Set hasKeywords to true if any keywords were added
      hasKeywords = selectedKeywords.isNotEmpty || addedNewKeyword; 
    });
  }
}

 Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _taskDeadlineController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

 String formatKeywords(String? keywordsJson) {
    if (keywordsJson != null && keywordsJson.isNotEmpty) {
      List<dynamic> keywords = jsonDecode(keywordsJson); // Decode the JSON string
      return keywords.map((keyword) => keyword['value']).join(', '); // Join values by comma
    }
    return 'Select Keyword'; // Default hint text if no keywords
  }

void _filterKeywordsByProjectAndUrl(String? projectId, String? urlId) {
  final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

  if (projectId != null && urlId != null && organizationViewModel.my_keywords.isNotEmpty) {
    final filteredKeywords = organizationViewModel.my_keywords.where((keyword) {
      return keyword.projectId == projectId && keyword.urlId == urlId; // Adjust properties as necessary
    }).toList();

    print('look here Filtered Keywords: $filteredKeywords');

    // Clear previous dropdown items
    keywordDropdownItems = [];
     

    // Populate keywordDropdownItems with individual keywords
    for (var keyword in filteredKeywords) {
      if (keyword.keyword != null) {
        for (var kw in keyword.keyword!) {
          keywordDropdownItems.add(DropdownMenuItem<String>(
            value: kw, // Use the individual keyword for the value
            child: Text(
              kw, // Display the individual keyword
              overflow: TextOverflow.ellipsis,
            ),
          ));
        }
      }
    }
    setState(() {
       if (hasKeywords && keywordDropdownItems.isNotEmpty) {
        selectedKeywords.clear(); // Clear the selected keywords list
      }
        additionalCondition = hasKeywords && keywordDropdownItems.isNotEmpty; // Update additionalCondition
      });
   
  }
}






Future<void> _createOrUpdateTask() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      isLoading = true; // Set loading state
    });

    try {
      // Fetch credentials like user email
      final credentials = await _getCredentials();
      final loggedInUserEmail = credentials['email'];

      if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User email is required')),
        );
        setState(() {
          isLoading = false; // Reset loading state
        });
        return;
      }

      // Prepare data to be sent in the request
      final requestData = {
        'email': loggedInUserEmail,
        'task_title': _taskTitleController.text.trim().isNotEmpty ? _taskTitleController.text.trim() : widget.taskTitle ?? '',
        'project_id': selectedProjectId ?? widget.projectId, // Use existing project ID if not selected
        'task_deadline': _taskDeadlineController.text.isNotEmpty ? _taskDeadlineController.text : widget.taskDeadline ?? '',
        'url': selectedUrl ?? '', // Selected URL
        'owner': selectedProjectManager ?? widget.userEmail ?? '', // Selected task owner (email)
        'keywords': selectedKeywords.isNotEmpty ? selectedKeywords.join(', ') : widget.keyword ?? '', // Combine selected keywords
        'severity': selectedSeverity ?? widget.sevirty ?? '', // Severity level from dropdown
        'task_type': selectedTaskType ?? widget.tasktype ?? '', // Task type from dropdown
        'description': _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : widget.description ?? '', // Task description
        'document': selectedFile?.path ?? existingDocument ?? '', // Handle document
        'org_slug': widget.orgSlug, // Organization slug
        'org_role_id': widget.orgRoleId, // Organization role ID
        'org_user_id': widget.orgUserId, // Organization user ID
        'org_user_org_id': widget.orgUserorgId, // Organization user org ID
      };

      // Call the appropriate create or update method
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

      final response = await (widget.id == null
          ? organizationViewModel.createTask(
              loggedInUserEmail,
              requestData['project_id'] ?? '', // Provide a default empty string if null
              requestData['task_title'] ?? '', // Provide a default empty string if null
              requestData['task_deadline'] ?? '', // Provide a default empty string if null
              requestData['url'] ?? '', // Provide a default empty string if null
              requestData['owner'] ?? '', // Provide a default empty string if null
              requestData['keywords'] ?? '', // Provide a default empty string if null
              requestData['severity'] ?? '', // Provide a default empty string if null
              requestData['task_type'] ?? '', // Provide a default empty string if null
              requestData['description'] ?? '', // Provide a default empty string if null
              requestData['document'] ?? '', // Provide a default empty string if null
              widget.orgSlug, // Organization slug is likely non-null
              widget.orgRoleId, // Org role ID is likely non-null
              widget.orgUserId, // Org user ID is likely non-null
              widget.orgUserorgId, // Org user org ID is likely non-null
            )
          : organizationViewModel.updateTask(
              loggedInUserEmail,
              widget.id.toString(), // Task ID for update
              requestData['project_id'] ?? '', // Provide a default empty string if null
              requestData['task_title'] ?? '', // Provide a default empty string if null
              requestData['task_deadline'] ?? '', // Provide a default empty string if null
              requestData['url'] ?? '', // Provide a default empty string if null
              requestData['owner'] ?? '', // Provide a default empty string if null
              requestData['keywords'] ?? '', // Provide a default empty string if null
              requestData['severity'] ?? '', // Provide a default empty string if null
              requestData['task_type'] ?? '', // Provide a default empty string if null
              requestData['description'] ?? '', // Provide a default empty string if null
              requestData['document'] ?? '', // Provide a default empty string if null
              widget.orgSlug, // Organization slug is likely non-null
              widget.orgRoleId, // Org role ID is likely non-null
              widget.orgUserId, // Org user ID is likely non-null
              widget.orgUserorgId, // Org user org ID is likely non-null
            )
      );

      setState(() {
        isLoading = false; // Reset loading state
      });

      if (response['success'] == true) {
        // Handle successful creation or update
       Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TaskBoards(orgSlug: widget.orgSlug),
            ),
          );
      } else {
        // Show failure message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to create/update task.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Reset loading state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating/updating task: $e')),
      );
    }
  }
}

              Future<void> _updateTask() async {
                  setState(() {
                    isLoading = true; // Set loading state
                  });
                  try {
                    // Fetch credentials like user email
                    final credentials = await _getCredentials();
                    final loggedInUserEmail = credentials['email'];

                    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User email is required')),
                      );
                      setState(() {
                        isLoading = false; // Reset loading state
                      });
                      return;
                    }

                    // Prepare data to be sent in the request
                    final requestData = {
                      'email': loggedInUserEmail,
                      'task_title': _taskTitleController.text.trim().isNotEmpty ? _taskTitleController.text.trim() : widget.taskTitle ?? '',
                      'project_id': selectedProjectId ?? widget.projectId,
                      'task_deadline': _taskDeadlineController.text.isNotEmpty ? _taskDeadlineController.text : widget.taskDeadline ?? '',
                      'url': selectedUrl ?? '', // Selected URL
                      'owner': selectedProjectManager ?? widget.userEmail ?? '', // Selected task owner (email)
                      'keywords': selectedKeywords.isNotEmpty ? selectedKeywords.join(', ') : widget.keyword ?? '', // Combine selected keywords
                      'severity': selectedSeverity ?? widget.sevirty ?? '', // Severity level from dropdown
                      'task_type': selectedTaskType ?? widget.tasktype ?? '', // Task type from dropdown
                      'description': _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : widget.description ?? '', // Task description
                      'document': selectedFile?.path ?? existingDocument ?? '', // Handle document
                      'org_slug': widget.orgSlug, // Organization slug
                      'org_role_id': widget.orgRoleId, // Organization role ID
                      'org_user_id': widget.orgUserId, // Organization user ID
                      'org_user_org_id': widget.orgUserorgId, // Organization user org ID
                    };

                    // Call the update method only
                    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

                    final response = await organizationViewModel.updateTask(
                      loggedInUserEmail,
                      widget.id.toString(), // Task ID for update
                      requestData['project_id'] ?? '', // Provide a default empty string if null
                      requestData['task_title'] ?? '', // Provide a default empty string if null
                      requestData['task_deadline'] ?? '', // Provide a default empty string if null
                      requestData['url'] ?? '', // Provide a default empty string if null
                      requestData['owner'] ?? '', // Provide a default empty string if null
                      requestData['keywords'] ?? '', // Provide a default empty string if null
                      requestData['severity'] ?? '', // Provide a default empty string if null
                      requestData['task_type'] ?? '', // Provide a default empty string if null
                      requestData['description'] ?? '', // Provide a default empty string if null
                      requestData['document'] ?? '', // Provide a default empty string if null
                      widget.orgSlug, // Organization slug is likely non-null
                      widget.orgRoleId, // Org role ID is likely non-null
                      widget.orgUserId, // Org user ID is likely non-null
                      widget.orgUserorgId, // Org user org ID is likely non-null
                    );

                    setState(() {
                      isLoading = false; // Reset loading state
                    });

                    if (response['success'] == true) {
                      // Handle successful update
                     Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TaskBoards(orgSlug: widget.orgSlug),
            ),
          );
                    } else {
                      // Show failure message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response['message'] ?? 'Failed to update task.')),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false; // Reset loading state
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating task: $e')),
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
        title: Text('Add New Task'),
        content: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [                 
                        _buildTextField('Task Title', _taskTitleController),
                          _buildDropdown(
                        'Select Project', 
                        projectDropdownItems, 
                        selectedProjectId, 
                        (value) {
                          setState(() {
                            selectedProjectId = value;
                            selectedUrl = null; // Reset the URL selection when project changes
                            
                            _filterUrlsByProject(value); // Re-filter URLs based on selected project
                            
                          });
                        }, 
                        widget.projectName != null && widget.projectName!.isNotEmpty ? widget.projectName! : 'Select Project' // Provide dynamic hint
                      ),
                         if (selectedProjectId != null) 
        _buildDropdown(
      'Web URL',
      urlDropdownItems, // Directly pass urlDropdownItems
      selectedUrl,
      (value) {
        setState(() {
          
      
          selectedUrl = value;
           
          // Call a different function based on additionalCondition
          if (value != null && value.isNotEmpty) {
            _filterKeywordsByProjectAndUrl(selectedProjectId, value);
          }
        });
      },
      urlDropdownItems.isNotEmpty ? 'Select My Web URL' : 'No Web URLs Available' // Ternary for hint
        ),
                if (selectedProjectId == null) 
                      widget.id != null && selectedUrl != null
                  ? _buildDropdown('Select Web URL', projectweburl.map((url) {
                      return DropdownMenuItem<String>(
                        value: url,
                        child: Text(url),
                      );
                    }).toList(), selectedUrl, (value) {
                      setState(() {
                        
                        selectedUrl = value;
                          
                      });
                    }, 'Web URL')
                  : _buildDropdown(
                      'Web URL',
                      urlDropdownItems.isNotEmpty 
                        ? urlDropdownItems 
                        : [
                            DropdownMenuItem<String>(
                              value: '', // You can assign a default value here
                              child: Text('No URL available for this project', style: TextStyle(color: Colors.grey)),
                            ),
                          ],
                      selectedUrl,
                      (value) {
                        setState(() {
                           
                         
                          _filterKeywordsByProjectAndUrl(selectedProjectId, value); // Ensure this is called correctly
                      
                        });
                      },
                      widget.webUrl != null && widget.webUrl!.isNotEmpty ? widget.webUrl! : 'Select Web URL' // Provide dynamic hint
                  ),
      
                    
                      
            //    if (selectedProjectId != null && !additionalCondition) 
                  if (selectedProjectId != null) 
                  
                        _buildDropdown(
                              'Keyword',
                              keywordDropdownItems,
                              null,
                              (value) {
                                _addSelectedKeyword(value);
                              },
                              'Select my Keyword', // Using the helper function to format the keyword hint
                            ),
      
                      
                       
                        
                            
                      // if (selectedUrl != null) 
                      //   _buildDropdown(
                      //         'Keyword',
                      //         keywordDropdownItems,
                      //         null,
                      //         (value) {
                      //           _addSelectedKeyword(value);
                      //         },
                      //         'Select mykey Keyword', // Using the helper function to format the keyword hint
                      //       ),
                             if (selectedProjectId == null) 
                        _buildDropdown(
                              'Keyword',
                              keywordDropdownItems,
                              null,
                              (value) {
                                _addSelectedKeyword(value);
                              },
                              formatKeywords(widget.keyword), // Using the helper function to format the keyword hint
                            ),
      
                // Display selected keywords as chips
                _buildChipsDisplay(),
                     
                      _buildDropdown('Severity', severityDropdownItems, selectedSeverity, (value) {
                        setState(() {
                          selectedSeverity = value;
                        });
                      }, 'Select Severity'),
                      _buildDropdown('Task Type', taskTypeDropdownItems, selectedTaskType, (value) {
                        setState(() {
                          selectedTaskType = value;
                        });
                      }, 'Select Task Type'),
      
                      _buildDropdown('Task Assign to', projectManagerEmails.map((email) {
                        return DropdownMenuItem<String>(
                          value: email,
                          child: Text(email),
                        );
                      }).toList(), selectedProjectManager, (value) {
                        setState(() {
                          selectedProjectManager = value;
                        });
                      }, 'Select Owner'),
                      _buildTextField('Task Deadline', _taskDeadlineController, onTap: _selectDate),
                      _buildFilePickerButton(),
                      _buildTextField('Description', _descriptionController, maxLines: 5),
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
        if (widget.id != null) {
          // Call update function if id is not null
          _updateTask();
        } else {
          // Call create function if id is null
          _createOrUpdateTask();
        }
      },
      child: Text(widget.id != null ? 'Update Task' : 'Add Task'),
        ),
      ],
      ),
    );
  }

 Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
        readOnly: onTap != null,
        onTap: onTap,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDropdown(String label, List<DropdownMenuItem<String>> items, String? value, ValueChanged<String?> onChanged, String? hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: value,
        items: items,
        onChanged: onChanged,
        validator: (value) => value == null || value.isEmpty ? 'Please select $label' : null,
        hint: Text(hintText ?? 'Select $label'),
      ),
    );
  }

  Widget _buildChipsDisplay() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: selectedKeywords.map((keyword) {
        return Chip(
          label: Text(keyword),
          onDeleted: () => _removeSelectedKeyword(keyword),
        );
      }).toList(),

     
    );
    
  }

  Widget _buildFilePickerButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Choose File'),
          ),
          Text(
            'Upload file (.pdf, .jpeg, .jpg, .png)',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 5),
          if (selectedFile != null) 
            Text(selectedFile!.name)
          else if (existingDocument != null && existingDocument!.isNotEmpty)
            GestureDetector(
              onTap: () {
                _openFileLink(existingDocument!);
              },
              child: Text(
                existingDocument!,
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            )
          else
            Text('No file chosen'),
        ],
      ),
    );
  }

// Helper function to open the file link (if the document is a URL or file path)
void _openFileLink(String fileName) {
  // Implement logic to open the file in a browser or download it
  // For example, you can use url_launcher to open links in Flutter
  // if it's a valid URL:
  if (fileName.startsWith('http') || fileName.startsWith('www')) {
    launch(fileName); // Use the url_launcher package to open URLs
  }
}
}