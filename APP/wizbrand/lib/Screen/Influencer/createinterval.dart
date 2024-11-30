import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/intervaltask.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreateIntervalDialog extends StatefulWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;
  final String? taskTitle; // Existing task title
  final String? taskDetails; // Existing task details
  final String? taskFreq; // Existing task frequency
  final String? adminEmail; // Existing admin email
  final String? userEmail; // Existing user email
  final int? id; // Task ID if needed

  const CreateIntervalDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.taskTitle,
    this.taskDetails,
    this.taskFreq,
    this.adminEmail,
    this.userEmail,
    this.id,
    Key? key,
  }) : super(key: key);

  @override
  _CreateIntervalDialogState createState() => _CreateIntervalDialogState();
}

class _CreateIntervalDialogState extends State<CreateIntervalDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDetailsController = TextEditingController();
  List<String> managerEmails = [];
  List<String> selectedUsers = [];
  Map<String, bool> checkboxSelections = {};  
  String? selectedTaskFrequency;
  bool isLoading = true;

  // Ensure these are unique and correctly populated
  final List<DropdownMenuItem<String>> frequencyDropdownItems = [
    DropdownMenuItem(value: 'hourly', child: Text('Hourly')),
    DropdownMenuItem(value: 'daily', child: Text('Daily')),
    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
    DropdownMenuItem(value: 'biweekly', child: Text('Bi Weekly')),
    DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values
    _taskTitleController.text = widget.taskTitle ?? '';
    _taskDetailsController.text = widget.taskDetails ?? '';
    selectedTaskFrequency = widget.taskFreq; // Initialize with existing frequency
      print(widget.userEmail);
    // selectedUsers = widget.userEmail;

      print("frequency aa raha hain");
    //  print(selectedTaskFrequency);
    _populateUserDropdown();
  }

  Future<void> _populateUserDropdown() async {
    try {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      final credentials = await _getCredentials();
      final email = credentials['email'];
      final orgSlug = widget.orgSlug;

      if (email != null && orgSlug.isNotEmpty) {
        await organizationViewModel.getUserFunction(email, orgSlug);
        final userOrgs = organizationViewModel.my_org;
        setState(() {
          managerEmails = userOrgs
              .map((user) => user.orgUserEmail)
              .where((email) => email != null)
              .cast<String>()
              .toList();

          checkboxSelections = {
            for (var email in managerEmails) email: false,
          };
        });
      }
    } catch (e) {
      print("Error: $e");
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

  

 Future<void> _updateIntervalTask() async { 
    setState(() {
      isLoading = true; // Set loading state
    });
    try {
      final credentials = await _getCredentials();
      final loggedInUserEmail = credentials['email'];
      if (loggedInUserEmail!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User email is required')),
        );
        setState(() {
          isLoading = false; // Reset loading state
        });
        return;
      }
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      // Prepare the request data
      final requestData = {
        'task_title': _taskTitleController.text,
        'task_details': _taskDetailsController.text,
        'task_freq': selectedTaskFrequency ?? widget.taskFreq, // Use widget.taskFreq if selectedTaskFrequency is null
        'assigned_users': selectedUsers ?? widget.userEmail, // Use widget.userEmail if selectedUsers is null
         'users': widget.userEmail, // Use widget.userEmail if selectedUsers is null
        'org_slug': widget.orgSlug,
        'org_role_id': widget.orgRoleId,
        'org_user_id': widget.orgUserId,
        'org_userorg_id': widget.orgUserorgId,
      };
      // Only updating the interval task since the create call has been removed
      final response = await organizationViewModel.updateIntervalTask(
        widget.id!,
        loggedInUserEmail.toString(),
        requestData['task_title'].toString(),
        requestData['task_details'].toString(),
        requestData['task_freq'].toString(),
        selectedUsers,
        requestData['users'].toString(),
        widget.orgSlug,
        widget.orgRoleId,
        widget.orgUserId,
        widget.orgUserorgId,
      );
      setState(() {
        isLoading = false; // Reset loading state
      });
      if (response['success']) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => IntervalTasks(orgSlug: widget.orgSlug),
            ),
          );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to update interval task.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Reset loading state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating interval task: $e')),
      );
    }
  
}

Future<void> _createIntervalTask() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      isLoading = true; // Set loading state
    });

    try {
      final credentials = await _getCredentials();
      final loggedInUserEmail = credentials['email'];

      if (loggedInUserEmail!.isEmpty) {
        _showSnackBar('User email is required');
        setState(() {
          isLoading = false; // Reset loading state
        });
        return;
      }

      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      final requestData = _prepareRequestData();

      // Only create an interval task since the update call has been removed
      final response = await organizationViewModel.createIntervalTask(
        loggedInUserEmail,
        requestData['task_title'],
        requestData['task_details'],
        requestData['task_freq'],
        selectedUsers,
        widget.orgSlug,
        widget.orgRoleId,
        widget.orgUserId,
        widget.orgUserorgId,
      );

      setState(() {
        isLoading = false; // Reset loading state
      });

      if (response['success']) {
        _showSnackBar('Task saved successfully!');
       Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => IntervalTasks(orgSlug: widget.orgSlug),
            ),
          );
      } else {
        _showSnackBar(response['message'] ?? 'Failed to save interval task.');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Reset loading state
      });
      _showSnackBar('Error saving interval task: $e');
    }
  }
}
void _showSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Map<String, dynamic> _prepareRequestData() {
  return {
    'task_title': _taskTitleController.text,
    'task_details': _taskDetailsController.text,
    'task_freq': selectedTaskFrequency,
    'assigned_users': selectedUsers,
    'org_slug': widget.orgSlug,
    'org_role_id': widget.orgRoleId,
    'org_user_id': widget.orgUserId,
    'org_userorg_id': widget.orgUserorgId,
  };
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
       title: Text(widget.id != null ? 'Edit Interval Task' : 'Add Interval Task'), // Us
        content: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                              _buildTextField('Task Title', _taskTitleController),
                              _buildMultiSelectDropdown(
                            'Select Multiple Users',
                            hintText: widget.userEmail != null ? widget.userEmail : 'Select Users',
                            isReadOnly: widget.id != null, // Set readonly if updating
                          ),
                            _buildDropdown(
                              'Select Task Frequency',
                              frequencyDropdownItems,
                              selectedTaskFrequency,
                              (value) {
                                setState(() {
                                  selectedTaskFrequency = value; // Set the selected frequency
                                });
                              },
                            widget.taskFreq != null && widget.taskFreq!.isNotEmpty ? widget.taskFreq! : 'SelectTask Frequency' // Provide dynamic hint                     
                            ),              
                           _buildTextField('Task Details', _taskDetailsController, maxLines: 3),
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
          _updateIntervalTask();
        } else {
          // Call create function if id is null
          _createIntervalTask();
        }
      },
      child: Text(widget.id != null ? 'Update Task' : 'Add Task'),
        ),       
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
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

Widget _buildMultiSelectDropdown(String label, {String? hintText, bool isReadOnly = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      readOnly: isReadOnly,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: isReadOnly ? null : Icon(Icons.arrow_drop_down), // Show arrow only if not read-only
      ),
      onTap: isReadOnly ? null : () { // Disable onTap if read-only
        _showMultiSelectDialog();
      },
      validator: (value) => selectedUsers.isEmpty ? 'Please select at least one user' : null,
      controller: TextEditingController(
        text: selectedUsers.isNotEmpty ? selectedUsers.join(', ') : (hintText ?? 'Select Users')
      ),
    ),
  );
}
  void _showMultiSelectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Users"),
          content: SingleChildScrollView(
            child: Column(
              children: managerEmails.map((email) {
                return StatefulBuilder(
                  builder: (context, _setState) {
                    return CheckboxListTile(
                      title: Text(email),
                      value: checkboxSelections[email] ?? false,
                      onChanged: (isSelected) {
                        _setState(() {
                          checkboxSelections[email] = isSelected ?? false;
                        });
                        setState(() {
                          if (isSelected != null && isSelected) {
                            if (!selectedUsers.contains(email)) {
                              selectedUsers.add(email);
                            }
                          } else {
                            selectedUsers.remove(email);
                          }
                        });
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
