import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class AddstartwizardDialog extends StatefulWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;  

  const AddstartwizardDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,

    Key? key,
  }) : super(key: key);

  @override
  _AddstartwizardDialogState createState() => _AddstartwizardDialogState();
}

class _AddstartwizardDialogState extends State<AddstartwizardDialog> {
  bool isLoading = false;
 late OrganizationViewModel organizationViewModel; // 1. Define as a member variable
 final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _slideshareController = TextEditingController();
  final TextEditingController _devopsschoolController = TextEditingController();
  final TextEditingController _dailymotionController = TextEditingController();
  final TextEditingController _pinterestController = TextEditingController();
  final TextEditingController _redditController = TextEditingController();
  final TextEditingController _plurkController = TextEditingController();
  final TextEditingController _debugschoolController = TextEditingController();
  final TextEditingController _bloggerController = TextEditingController();
  final TextEditingController _mediumController = TextEditingController();
  final TextEditingController _quoraController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _gurukulgalaxyController = TextEditingController();
  final TextEditingController _professnowController = TextEditingController();
  final TextEditingController _hubpagesController = TextEditingController();
  final TextEditingController _mymedicplusController = TextEditingController();
  final TextEditingController _holidaylandmarkController = TextEditingController();
  final TextEditingController _facebookPageController = TextEditingController(); // Ne
 List<DropdownMenuItem<String>> projectDropdownItems = [];
   String? selectedProjectId;
 @override
  void initState() {
    super.initState();
    organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false); // 2. Initialize in initState
     _fetchProjects(); // Fetch the projects or any initial data here
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


      // If widget.id is null, create dropdown items normally
      projectDropdownItems = organizationViewModel.my_projects.map((project) {
        return DropdownMenuItem<String>(
          value: project.id?.toString(), // Ensure this ID is unique
          child: Text(project.projectName ?? 'Unknown'),
        );
      }).toList();
    


    } catch (e) {
      print('Error fetching projects: $e');
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
    final organizationViewModel = Provider.of<OrganizationViewModel>(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text('Add Social Wizard'),
      content: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Read-only Project Name Field
                  _buildDropdown(
                  'Project Name',
                  selectedProjectId,
                  projectDropdownItems,
                  (value) {
                    setState(() {
                      selectedProjectId = value;
                    });
                  },                 
                ),
                  SizedBox(height: 20),
          _buildSocialUrlFields('facebooks', _facebookController, organizationViewModel),
          _buildSocialUrlFields('twitter', _twitterController, organizationViewModel),
          _buildSocialUrlFields('linkedin', _linkedinController, organizationViewModel),
          _buildSocialUrlFields('instagram', _instagramController, organizationViewModel),
          _buildSocialUrlFields('youtube', _youtubeController, organizationViewModel),
          _buildSocialUrlFields('tiktok', _tiktokController, organizationViewModel),
          _buildSocialUrlFields('slideshare', _slideshareController, organizationViewModel),
          _buildSocialUrlFields('devopsschool', _devopsschoolController, organizationViewModel),
          _buildSocialUrlFields('dailymotion', _dailymotionController, organizationViewModel),
          _buildSocialUrlFields('pinterest', _pinterestController, organizationViewModel),
          _buildSocialUrlFields('reddit', _redditController, organizationViewModel),
          _buildSocialUrlFields('plurk', _plurkController, organizationViewModel),
          _buildSocialUrlFields('debugschool', _debugschoolController, organizationViewModel),
          _buildSocialUrlFields('blogger', _bloggerController, organizationViewModel),
          _buildSocialUrlFields('medium', _mediumController, organizationViewModel),
          _buildSocialUrlFields('quora', _quoraController, organizationViewModel),
          _buildSocialUrlFields('github', _githubController, organizationViewModel),
          _buildSocialUrlFields('gurukulgalaxy', _gurukulgalaxyController, organizationViewModel),
          _buildSocialUrlFields('professnow', _professnowController, organizationViewModel),
          _buildSocialUrlFields('hubpages', _hubpagesController, organizationViewModel),
          _buildSocialUrlFields('mymedicplus', _mymedicplusController, organizationViewModel),
          _buildSocialUrlFields('holidaylandmark', _holidaylandmarkController, organizationViewModel),
          _buildSocialUrlFields('facebook_page', _facebookPageController, organizationViewModel), // New
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
          onPressed: _AddstartwizardProcess, // Call the start wizard process
          child: Text('Add'),
        ),
      ],
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


  // Helper to build each social URL input field with dynamic icon and color
  Widget _buildSocialUrlFields(String key, TextEditingController controller, OrganizationViewModel organizationViewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Enter your $key url',
          prefixIcon: Icon(
            organizationViewModel.getSocialIcon(key),
            color: organizationViewModel.getSocialIconColor(key),
          ),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

void _AddstartwizardProcess() async {
  setState(() {
    isLoading = true; // Set loading state to true
  });

  final credentials = await _getCredentials();
  final loggedInUserEmail = credentials['email'];

  if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User email is required'))
    );
    setState(() {
      isLoading = false;
    });
    return;
  }

  // Gather all the URL inputs from controllers
  final socialUrls = {
    'facebooks': _facebookController.text,
    'twitter': _twitterController.text,
    'linkedin': _linkedinController.text,
    'instagram': _instagramController.text,
    'youtube': _youtubeController.text,
    'tiktok': _tiktokController.text,
    'slideshare': _slideshareController.text,
    'devopsschool': _devopsschoolController.text,
    'dailymotion': _dailymotionController.text,
    'pinterest': _pinterestController.text,
    'reddit': _redditController.text,
    'plurk': _plurkController.text,
    'debugschool': _debugschoolController.text,
    'blogger': _bloggerController.text,
    'medium': _mediumController.text,
    'quora': _quoraController.text,
    'github': _githubController.text,
    'gurukulgalaxy': _gurukulgalaxyController.text,
    'professnow': _professnowController.text,
    'hubpages': _hubpagesController.text,
    'mymedicplus': _mymedicplusController.text,
    'holidaylandmark': _holidaylandmarkController.text,
    'facebook_page': _facebookPageController.text, // New
  };

  // Get the selected project name directly from the dropdown
  final selectedProject = organizationViewModel.my_projects.firstWhere(
    (project) => project.id.toString() == selectedProjectId,
    orElse: () => throw Exception('Selected project not found')
  );

  // Call the createSocialwizard method with the selected project details
  await organizationViewModel.createSocialwizard(
    loggedInUserEmail,
    selectedProjectId!, // Use selectedProjectId from dropdown
    selectedProject.projectName!, // Directly use the selected project's name
    socialUrls['facebooks'] ?? '',
    socialUrls['tiktok'] ?? '',
    socialUrls['slideshare'] ?? '',
    socialUrls['dailymotion'] ?? '',
    socialUrls['youtube'] ?? '',
    socialUrls['twitter'] ?? '',
    socialUrls['linkedin'] ?? '',
    socialUrls['instagram'] ?? '',
    socialUrls['tumblr'] ?? '',
    socialUrls['wordpress'] ?? '',
    socialUrls['pinterest'] ?? '',
    socialUrls['reddit'] ?? '',
    socialUrls['plurk'] ?? '',
    socialUrls['debugschool'] ?? '',
    socialUrls['blogger'] ?? '',
    socialUrls['medium'] ?? '',
    socialUrls['quora'] ?? '',
    socialUrls['github'] ?? '',
    socialUrls['gurukulgalaxy'] ?? '',
    socialUrls['professnow'] ?? '',
    socialUrls['hubpages'] ?? '',
    socialUrls['mymedicplus'] ?? '',
    socialUrls['holidaylandmark'] ?? '',
    socialUrls['devopsschool'] ?? '',
    socialUrls['facebook_page'] ?? '', // New
    widget.orgSlug,
    widget.orgRoleId,
    widget.orgUserId,
    widget.orgUserorgId,
  );

  setState(() {
    isLoading = false; // Set loading state to false after the process
  });

  Navigator.of(context).pop(); // Close the dialog after completion
}

  @override
 void dispose() {
    // Dispose of controllers
    _facebookController.dispose();
    _twitterController.dispose();
    _linkedinController.dispose();
    _instagramController.dispose();
    _youtubeController.dispose();
    _tiktokController.dispose();
    _slideshareController.dispose();
    _devopsschoolController.dispose();
    _dailymotionController.dispose();
    _pinterestController.dispose();
    _redditController.dispose();
    _plurkController.dispose();
    _debugschoolController.dispose();
    _bloggerController.dispose();
    _mediumController.dispose();
    _quoraController.dispose();
    _githubController.dispose();
    _gurukulgalaxyController.dispose();
    _professnowController.dispose();
    _hubpagesController.dispose();
    _mymedicplusController.dispose();
    _holidaylandmarkController.dispose();
    _facebookPageController.dispose(); // New
    super.dispose();
  }
}