import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/teamrating.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreateRatingDialog extends StatefulWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;

  final String? ratingId;
  final String? ratingUserName;
  final String? managerid; 

  final String? week;
  final String? month;
  final String? year;
  final String? ratingValue;

  CreateRatingDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,

    this.ratingId,
    this.ratingUserName,
   this.managerid,
    this.week,
    this.month,
    this.year,
    this.ratingValue,
  });

  @override
  _CreateRatingDialogState createState() => _CreateRatingDialogState();
}

class _CreateRatingDialogState extends State<CreateRatingDialog> {
  String? selectedUser;
  String? selectedManager;
  String? selectedWeek;
  String? selectedMonth;
  String? selectedRating;
    String? managerid;  
  List<Map<String, String>> managerEmails = [];
  bool isLoading = false;

  // Variables to capture additional parameters from selected manager
  String? selectedManagerEmail;
  String? selectedManagerInvitedBy;
  String? selectedManagerInvitedByEmail;
  String? selectedManagerOrgUserId;
  String? selectedManagerOrgRoleId;
  String? selectedManagerOrgRoleName;
  String? selectedManagerOrgOrganizationId;
  String? selectedManagerOrgSlugName;
  String? selectedManagerStatus;
  String? selectedManagerInvitedRemoved;

  final List<String> weeks = ['1', '2', '3', '4'];
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June', 
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final List<String> ratings = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    
    // Pre-fill fields for edit if data is provided
   
    selectedWeek = widget.week ?? null;
    selectedMonth = widget.month ?? null;
    selectedRating = widget.ratingValue ?? null;
    selectedUser = widget.ratingUserName ?? null;

 DateTime now = DateTime.now();
    int currentMonthIndex = now.month - 1; // January is 0, February is 1, etc.

    // Filter the months list to include months from January to current month
    List<String> availableMonths = months.sublist(0, currentMonthIndex + 1);

 selectedMonth = months[currentMonthIndex];
    _fetchData();

     if (widget.ratingId != null) {
    managerid = widget.managerid;    
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
      final orgSlug = widget.orgSlug;

      if (email != null && orgSlug.isNotEmpty) {
        await organizationViewModel.getUserFunction(email, orgSlug);
        // Extract user IDs and originalNames
        final userOrgs = organizationViewModel.my_org;
        setState(() {
          managerEmails = userOrgs
              .where((user) => user.originalName != null && user.id != null)
              .map((user) => {
                    'id': user.id.toString(),
                    'name': user.originalName ?? '',
                    'myemail': user.orgUserEmail ?? '',
                    'invited_by': user.invitedBy ?? '',
                    'invitedByEmail': user.invitedByEmail ?? '',
                    'orgUserId': user.orgUserId ?? '',
                    'orgRoleId': user.orgRoleId ?? '',
                    'orgRoleName': user.orgRoleName ?? '',
                    'orgOrganizationId': user.orgOrganizationId ?? '',
                    'orgSlugName': user.orgSlugName ?? '',
                    'status': user.status ?? '',
                    'invitedRemoved': user.invitedRemoved ?? '',
                  })
              .toList();
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

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    int currentMonthIndex = now.month - 1; // January is 0, February is 1, etc.

    // Filter the months list to include months from January to current month
    List<String> availableMonths = months.sublist(0, currentMonthIndex + 1);
    return GestureDetector(
       onTap: () {
      FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside
    },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(widget.ratingId != null ? 'Edit Rating' : 'Add New Rating'),
        content: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Project Manager Dropdown
                   // Project Manager Dropdown
      widget.ratingId != null
      ? TextFormField(
          initialValue: managerEmails.firstWhere((manager) => manager['id'] == managerid, orElse: () => {'name': ''})['name'],
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Project Manager',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        )
      : DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Project Manager',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          value: managerEmails.any((manager) => manager['id'] == managerid) ? managerid : null, // Set to null if no match is found
          items: managerEmails.map((manager) {
            return DropdownMenuItem<String>(
              value: manager['id'],
              child: Text(manager['name'] ?? ''),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedManager = value;
              selectedUser = managerEmails.firstWhere((manager) => manager['id'] == value)['name'];
      
              // Capture additional manager details
              var selectedManagerData = managerEmails.firstWhere((manager) => manager['id'] == value);
              selectedManagerEmail = selectedManagerData['myemail'];
              selectedManagerInvitedBy = selectedManagerData['invited_by'];
              selectedManagerInvitedByEmail = selectedManagerData['invitedByEmail'];
              selectedManagerOrgUserId = selectedManagerData['orgUserId'];
              selectedManagerOrgRoleId = selectedManagerData['orgRoleId'];
              selectedManagerOrgRoleName = selectedManagerData['orgRoleName'];
              selectedManagerOrgOrganizationId = selectedManagerData['orgOrganizationId'];
              selectedManagerOrgSlugName = selectedManagerData['orgSlugName'];
              selectedManagerStatus = selectedManagerData['status'];
              selectedManagerInvitedRemoved = selectedManagerData['invitedRemoved'];
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a project manager';
            }
            return null;
          },
        ),
                    SizedBox(height: 10),
      
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Week',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                      value: selectedWeek,
                      items: weeks.map((week) {
                        return DropdownMenuItem<String>(
                          value: week,
                          child: Text(week),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedWeek = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Month',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                      value: selectedMonth,
                      items: availableMonths.map((month) {
            return DropdownMenuItem<String>(
              value: month,
              child: Text(month),
            );
          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
      
                    TextFormField(
                      initialValue: widget.year ?? DateTime.now().year.toString(),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
      
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Rating',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                      value: selectedRating,
                      items: ratings.map((rating) {
                        return DropdownMenuItem<String>(
                          value: rating,
                          child: Text(rating),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRating = value;
                        });
                      },
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
            onPressed: _createOrUpdateRating,
            child: Text(widget.ratingId != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

void _createOrUpdateRating() async {
  // Check if it's an update operation (when `ratingId` is not null)
  if (widget.ratingId != null) {
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

      // Update existing rating
      await organizationViewModel.updateRating(
        widget.ratingId!,       // Existing rating ID for update
        loggedInUserEmail,       // Logged-in user's email
        selectedManager ?? '',   // Allow empty or previously selected manager
        selectedUser ?? '',      // Allow empty or previously selected user
        selectedWeek ?? '',      // Allow empty or previously selected week
        selectedMonth ?? '',     // Allow empty or previously selected month
        widget.year ?? DateTime.now().year.toString(), // Use existing or current year
        selectedRating ?? '',    // Allow empty or previously selected rating
        widget.orgSlug,          // Organization slug
        widget.orgRoleId,        // Organization role ID
        widget.orgUserId,        // Organization user ID
        widget.orgUserorgId,     // Organization user organization ID
      );

      setState(() {
        isLoading = false;
      });

      // Redirect to the TeamRating page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TeamRating(orgSlug: widget.orgSlug),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  } else {
    // This is the "create new" scenario, validate all fields
    if (selectedManager != null && selectedWeek != null && selectedMonth != null && selectedRating != null) {
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

        // Create new rating
        await organizationViewModel.createRating(
          loggedInUserEmail,     // Logged-in user's email
          selectedManager!,      // Selected manager ID
          selectedUser!,         // Selected user name
          selectedWeek!,         // Selected week
          selectedMonth!,        // Selected month
          DateTime.now().year.toString(), // Current year
          selectedRating!,       // Selected rating
          widget.orgSlug,        // Organization slug
          widget.orgRoleId,      // Organization role ID
          widget.orgUserId,      // Organization user ID
          widget.orgUserorgId,   // Organization user organization ID

          // Additional parameters from managerEmails
          selectedManagerEmail,
          selectedManagerInvitedBy,
          selectedManagerInvitedByEmail,
          selectedManagerOrgUserId,
          selectedManagerOrgRoleId,
          selectedManagerOrgRoleName,
          selectedManagerOrgOrganizationId,
          selectedManagerOrgSlugName,
          selectedManagerStatus,
          selectedManagerInvitedRemoved,
        );

        setState(() {
          isLoading = false;
        });

        // Redirect to the TeamRating page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TeamRating(orgSlug: widget.orgSlug),
          ),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      // Show an error if required fields are missing during creation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
    }
  }
}
}