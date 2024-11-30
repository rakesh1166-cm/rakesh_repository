import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/competitorscreen.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreateCompetitorUrlDialog extends StatefulWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;
  final String? competitorid; // To distinguish between create and edit
  final String? projectName;
  final String? projectId; 
  final String? initialName;
  final String? initialWebsite;
  final String? initialFacebook;
  final String? initialTwitter;
  final String? initialInstagram;
  final String? initialYoutube;
  final String? initialLinkedin;
  final String? initialPinterest;
  final String? initialReddit;
  final String? initialTiktok;

  const CreateCompetitorUrlDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.competitorid,
    this.projectName,
    this.projectId,
    this.initialName,
    this.initialWebsite,
    this.initialFacebook,
    this.initialTwitter,
    this.initialInstagram,
    this.initialYoutube,
    this.initialLinkedin,
    this.initialPinterest,
    this.initialReddit,
    this.initialTiktok,
    Key? key,
  }) : super(key: key);

  @override
  _CreateCompetitorUrlDialogState createState() =>
      _CreateCompetitorUrlDialogState();
}

class _CreateCompetitorUrlDialogState extends State<CreateCompetitorUrlDialog> {
  List<DropdownMenuItem<String>> projectDropdownItems = [];
  String? selectedProject;
 String? projectId;
  
  String? selectedProjectName;
  List<DropdownMenuItem<String>> urlDropdownItems = [];
  String? selectedUrlId;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _pinterestController = TextEditingController();
  final TextEditingController _redditController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProjectData();
  if (widget.competitorid != null) {
    projectId = widget.projectId;    
     print("dropdown2 urlname is here");  

  }
    // Pre-fill the fields if editing
    _nameController.text = widget.initialName ?? '';
    _websiteController.text = widget.initialWebsite ?? '';
    _facebookController.text = widget.initialFacebook ?? '';
    _twitterController.text = widget.initialTwitter ?? '';
    _instagramController.text = widget.initialInstagram ?? '';
    _youtubeController.text = widget.initialYoutube ?? '';
    _linkedinController.text = widget.initialLinkedin ?? '';
    _pinterestController.text = widget.initialPinterest ?? '';
    _redditController.text = widget.initialReddit ?? '';
    _tiktokController.text = widget.initialTiktok ?? '';

    if (widget.competitorid != null && widget.projectName != null) {
      selectedProject = widget.competitorid;
    }
  }

  Future<void> _fetchProjectData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final organizationViewModel =
          Provider.of<OrganizationViewModel>(context, listen: false);
      final credentials = await _getCredentials();
      final email = credentials['email'];

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

  Future<void> _fetchProjectNames() async {
    try {
      final organizationViewModel =
          Provider.of<OrganizationViewModel>(context, listen: false);
      projectDropdownItems.clear();

      if (organizationViewModel.my_projects != null &&
          organizationViewModel.my_projects.isNotEmpty) {
        projectDropdownItems = organizationViewModel.my_projects.map((project) {
      return DropdownMenuItem<String>(
        value: project.id?.toString() ?? '',
        child: Text(
          project.projectName ?? 'Unknown',
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();

        final idSet = projectDropdownItems.map((item) => item.value).toSet();
        if (idSet.length != projectDropdownItems.length) {
          print("Warning: Duplicate values found in DropdownMenuItems");
        }
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

  void _filterUrlsByProject(String? projectId) {
    final organizationViewModel =
        Provider.of<OrganizationViewModel>(context, listen: false);

    if (projectId != null && organizationViewModel.my_urls.isNotEmpty) {
      final filteredUrls = organizationViewModel.my_urls.where((url) {
        return url.projectId?.toString() == projectId;
      }).toList();

      setState(() {
        urlDropdownItems = filteredUrls.map((url) {
          return DropdownMenuItem<String>(
            value: url.id?.toString() ?? '',
            child: Text(url.url ?? 'Unknown', overflow: TextOverflow.ellipsis),
          );
        }).toList();

        if (urlDropdownItems.isEmpty) {
          urlDropdownItems.add(
            DropdownMenuItem<String>(
              value: '',
              child: Text('No URLs available for this project'),
            ),
          );
        }

        if (selectedUrlId != null &&
            !urlDropdownItems.any((item) => item.value == selectedUrlId)) {
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
        selectedUrlId = null;
      });
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
        title: Text(widget.competitorid != null
            ? 'Edit Competitor URL'
            : 'Add New Competitors URL'),
        content: SingleChildScrollView(
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
      
        
                value: projectDropdownItems.any((item) => item.value == projectId)
                    ? projectId
                    : null, // Fallback to null if value doesn't exist
                items: projectDropdownItems,
            
      
                onChanged: widget.competitorid == null
        ? (value) {
            setState(() {
              selectedProject = value;
              selectedUrlId = null;  // Reset URL selection when project changes
            
      
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
        : null,  // Dis
      
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a project';
                  }
                  return null;
                },
                  disabledHint: Text(selectedProjectName ?? 'Unknown'), // Show project name when disabled
              ),
              SizedBox(height: 10),
              _buildTextField(_nameController, 'Name'),
              _buildTextField(_websiteController, 'Website'),
              _buildTextField(_facebookController, 'Facebook'),
              _buildTextField(_twitterController, 'Twitter'),
              _buildTextField(_instagramController, 'Instagram'),
              _buildTextField(_youtubeController, 'YouTube'),
              _buildTextField(_linkedinController, 'LinkedIn'),
              _buildTextField(_pinterestController, 'Pinterest'),
              _buildTextField(_redditController, 'Reddit'),
              _buildTextField(_tiktokController, 'TikTok'),
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
            onPressed: _createOrUpdateCompetitor,
            child: Text(widget.competitorid != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }

 void _createOrUpdateCompetitor() async {
  // Ensure selectedProject and name are not null
  if (selectedProject != null && _nameController.text.isNotEmpty && _websiteController.text.isNotEmpty) {
    setState(() {
      isLoading = true;
    });
    try {
      final credentials = await _getCredentials();
      final loggedInUserEmail = credentials['email'];

      // Ensure that the selected project name is not null
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      // null check opertator used on null value
      selectedProjectName = selectedProjectName ?? 'Unknown'; // Provide a fallback if project name is null

      // Perform the update or create operation
      if (widget.competitorid != null) {
        await organizationViewModel.updateCompetitorUrl(
          loggedInUserEmail!,  // Use ! operator only when you are certain the value is non-null
          widget.competitorid!,
          selectedProject!, // Ensure this is not null
          selectedProjectName!, // Ensure this is not null
          _nameController.text,
          _websiteController.text,
          _facebookController.text,
          _twitterController.text,
          _instagramController.text,
          _youtubeController.text,
          _linkedinController.text,
          _pinterestController.text,
          _redditController.text,
          _tiktokController.text,
          widget.orgSlug,
          widget.orgRoleId,
          widget.orgUserId,
          widget.orgUserorgId,
        );
      } else {
        await organizationViewModel.createCompetitorUrl(
          loggedInUserEmail!,
          selectedProject!, // Ensure this is not null
          selectedProjectName!, // Ensure this is not null
          _nameController.text,
          _websiteController.text,
          _facebookController.text,
          _twitterController.text,
          _instagramController.text,
          _youtubeController.text,
          _linkedinController.text,
          _pinterestController.text,
          _redditController.text,
          _tiktokController.text,
          widget.orgSlug,
          widget.orgRoleId,
          widget.orgUserId,
          widget.orgUserorgId,
        );
      }

      setState(() {
        isLoading = false;
      });

      // Navigate to Competitor Screen after successful operation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompetitorScreen(orgSlug: widget.orgSlug),
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
    // Handle case where required fields are missing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all required fields')),
    );
  }
}
}