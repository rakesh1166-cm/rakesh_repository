import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/model/webassets.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class StartWizardDialog extends StatefulWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;
  final String projectName;
  final String projectId;
  

  const StartWizardDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    required this.projectName,
    required this.projectId,
    Key? key,
  }) : super(key: key);

  @override
  _StartWizardDialogState createState() => _StartWizardDialogState();
}

class _StartWizardDialogState extends State<StartWizardDialog> with DrawerMixin, RoleMixin, NavigationMixin { 
  List<WebassetsModel> _filteredWebAssets = []; // List to hold filtered web assets
  bool isLoading = false;
    String _userRole = ''; // Variable to store the role for AppBar
  TextEditingController _searchController = TextEditingController();
  String _userName = ''; // Variable to store the user's name
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
 @override
  void initState() {
    super.initState();
    organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false); // 2. Initialize in initState
     _fetchData(); // Fetch organization data when the screen initializes
  }

    Future<void> _fetchData() async {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final credentials = await _getCredentials();
    final email = credentials['email'];
    final orgSlug = widget.orgSlug;
    final secureStorage = FlutterSecureStorage();
    final orgRoleId = await secureStorage.read(key: 'orgRoleId');
    final orgUserId = await secureStorage.read(key: 'orgUserId');
    final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
    final username = await secureStorage.read(key: 'userName');
setState(() {
    _userRole = determineUserRole(orgRoleId);
    _userName = username ?? 'User'; // Set the user name or default to 'User'
    print("my role is $_userRole");
  });
  if (email != null && orgSlug.isNotEmpty) {
  print("my widget id is there");
  print(widget.projectId);

  await organizationViewModel.getWebassets(
    email,
    orgSlug,
    orgRoleId.toString(),
    orgUserId.toString(),
    orgUserorgId.toString(),
  ); // Pass the additional parameters
  
  _filteredWebAssets = organizationViewModel.my_webassets; // Initialize with full data
   print("Data in _filteredWebAssets: $_filteredWebAssets");
  // Filter by widget.projectId
 final filteredByProjectId = _filteredWebAssets.where((asset) {
  return asset.projectId?.toString() == widget.projectId;
}).toList();


  print("Filtered Data by Project ID (${widget.projectId}): $filteredByProjectId");
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

  // Create a map to store social media URLs for the specific project ID
  Map<String, String> socialUrlsMap = {
    'facebooks': '',
    'twitter': '',
    'linkedin': '',
    'instagram': '',
    'youtube': '',
    'tiktok': '',
    'slideshare': '',
    'devopsschool': '',
    'dailymotion': '',
    'pinterest': '',
    'reddit': '',
    'plurk': '',
    'debugschool': '',
    'blogger': '',
    'medium': '',
    'quora': '',
    'github': '',
    'gurukulgalaxy': '',
    'professnow': '',
    'hubpages': '',
    'mymedicplus': '',
    'holidaylandmark': '',
    'facebook_page': '',
  };

  // Populate the socialUrlsMap with data from filteredWebAssets for this projectId
  for (var asset in _filteredWebAssets) {
    if (asset.projectId?.toString() == widget.projectId) {
      socialUrlsMap['facebooks'] = (asset.facebooks ?? socialUrlsMap['facebooks'])!;
      socialUrlsMap['twitter'] = (asset.twitter ?? socialUrlsMap['twitter'])!;
      socialUrlsMap['linkedin'] = (asset.linkedin ?? socialUrlsMap['linkedin'])!;
      socialUrlsMap['instagram'] = (asset.instagram ?? socialUrlsMap['instagram'])!;
      socialUrlsMap['youtube'] = (asset.youtube ?? socialUrlsMap['youtube'])!;
      socialUrlsMap['tiktok'] = (asset.tiktok ?? socialUrlsMap['tiktok'])!;
      socialUrlsMap['slideshare'] = (asset.slideshare ?? socialUrlsMap['slideshare'])!;
      socialUrlsMap['devopsschool'] = (asset.devopsschool ?? socialUrlsMap['devopsschool'])!;
      socialUrlsMap['dailymotion'] = (asset.dailymotion ?? socialUrlsMap['dailymotion'])!;
      socialUrlsMap['pinterest'] = (asset.pinterest ?? socialUrlsMap['pinterest'])!;
      socialUrlsMap['reddit'] = (asset.reddit ?? socialUrlsMap['reddit'])!;
      socialUrlsMap['plurk'] = (asset.plurk ?? socialUrlsMap['plurk'])!;
      socialUrlsMap['debugschool'] = (asset.debugschool ?? socialUrlsMap['debugschool'])!;
      socialUrlsMap['blogger'] = (asset.blogger ?? socialUrlsMap['blogger'])!;
      socialUrlsMap['medium'] = (asset.medium ?? socialUrlsMap['medium'])!;
      socialUrlsMap['quora'] = (asset.quora ?? socialUrlsMap['quora'])!;
      socialUrlsMap['github'] = (asset.github ?? socialUrlsMap['github'])!;
      socialUrlsMap['gurukulgalaxy'] = (asset.gurukulgalaxy ?? socialUrlsMap['gurukulgalaxy'])!;
      socialUrlsMap['professnow'] = (asset.professnow ?? socialUrlsMap['professnow'])!;
      socialUrlsMap['hubpages'] = (asset.hubpages ?? socialUrlsMap['hubpages'])!;
      socialUrlsMap['mymedicplus'] = (asset.mymedicplus ?? socialUrlsMap['mymedicplus'])!;
      socialUrlsMap['holidaylandmark'] = (asset.holidaylandmark ?? socialUrlsMap['holidaylandmark'])!;
      socialUrlsMap['facebook_page'] = (asset.facebookPage ?? socialUrlsMap['facebook_page'])!;
    }
  }

  // Set the text fields based on the populated socialUrlsMap
  _facebookController.text = socialUrlsMap['facebooks']!;
  _twitterController.text = socialUrlsMap['twitter']!;
  _linkedinController.text = socialUrlsMap['linkedin']!;
  _instagramController.text = socialUrlsMap['instagram']!;
  _youtubeController.text = socialUrlsMap['youtube']!;
  _tiktokController.text = socialUrlsMap['tiktok']!;
  _slideshareController.text = socialUrlsMap['slideshare']!;
  _devopsschoolController.text = socialUrlsMap['devopsschool']!;
  _dailymotionController.text = socialUrlsMap['dailymotion']!;
  _pinterestController.text = socialUrlsMap['pinterest']!;
  _redditController.text = socialUrlsMap['reddit']!;
  _plurkController.text = socialUrlsMap['plurk']!;
  _debugschoolController.text = socialUrlsMap['debugschool']!;
  _bloggerController.text = socialUrlsMap['blogger']!;
  _mediumController.text = socialUrlsMap['medium']!;
  _quoraController.text = socialUrlsMap['quora']!;
  _githubController.text = socialUrlsMap['github']!;
  _gurukulgalaxyController.text = socialUrlsMap['gurukulgalaxy']!;
  _professnowController.text = socialUrlsMap['professnow']!;
  _hubpagesController.text = socialUrlsMap['hubpages']!;
  _mymedicplusController.text = socialUrlsMap['mymedicplus']!;
  _holidaylandmarkController.text = socialUrlsMap['holidaylandmark']!;
  _facebookPageController.text = socialUrlsMap['facebook_page']!;

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
                TextFormField(
                  initialValue: widget.projectName,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Project Name',
                    border: OutlineInputBorder(),
                  ),
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
        onPressed: _startWizardProcess, // Call the start wizard process
        child: Text('Start Wizard'),
      ),
    ],
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

 void _startWizardProcess() async {
  setState(() {
    isLoading = true; // Set loading state to true
  });
  final credentials = await _getCredentials();
      final loggedInUserEmail = credentials['email'];

      if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User email is required')));
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


  // Call the createPagerank method with all the parameters
  await organizationViewModel.createSocialwizard(
      loggedInUserEmail,
      widget.projectId,
      widget.projectName,
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