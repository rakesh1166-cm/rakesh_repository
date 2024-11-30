import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/web.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreateWebDialog extends StatefulWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;
  final String? webid; // Use this to check if we're updating or creating a new entry
  final String? projectId;
  final String? projectName;
  final String? domain;
  final String? globalRank;
  final String? usaRank;
  final String? indiaRank;
  final String? backlinks;
  final String? referringDomains;

  const CreateWebDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.webid,
    this.projectId,
    this.projectName,
    this.domain,
    this.globalRank,
    this.usaRank,
    this.indiaRank,
    this.backlinks,
    this.referringDomains,
    Key? key,
  }) : super(key: key);

  @override
  _CreateWebDialogState createState() => _CreateWebDialogState();
}

class _CreateWebDialogState extends State<CreateWebDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _domainAuthorityController = TextEditingController();
  final TextEditingController _alexaGlobalRankController = TextEditingController();
  final TextEditingController _alexaUSARankController = TextEditingController();
  final TextEditingController _alexaIndiaRankController = TextEditingController();
  final TextEditingController _externalBacklinksController = TextEditingController();
  final TextEditingController _referringDomainsController = TextEditingController();
  
  List<DropdownMenuItem<String>> projectDropdownItems = [];
  String? selectedProject;
  String? selectedProjectName;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data (for editing)
    _domainAuthorityController.text = widget.domain ?? '';
    _alexaGlobalRankController.text = widget.globalRank ?? '';
    _alexaUSARankController.text = widget.usaRank ?? '';
    _alexaIndiaRankController.text = widget.indiaRank ?? '';
    _externalBacklinksController.text = widget.backlinks ?? '';
    _referringDomainsController.text = widget.referringDomains ?? '';
    
    // Set selectedProject if editing an existing entry
    selectedProject = widget.projectId; 
    selectedProjectName = widget.projectName;

    _fetchProjectData(); // Fetch project data after initializing controllers
  }

  Future<void> _fetchProjectData() async {
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
        title: Text(widget.webid != null ? 'Edit Webrank' : 'Add New Webrank'),
        content: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.webid != null
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
                                border: OutlineInputBorder(),
                              ),
                              value: projectDropdownItems.any((item) => item.value == selectedProject)
                                  ? selectedProject
                                  : null,
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
                      SizedBox(height: 10),
                      _buildNumericTextField('Domain Authority', _domainAuthorityController),
                      _buildNumericTextField('Alexa Global Rank', _alexaGlobalRankController),
                      _buildNumericTextField('Alexa USA Rank', _alexaUSARankController),
                      _buildNumericTextField('Alexa India Rank', _alexaIndiaRankController),
                      _buildNumericTextField('External Backlinks', _externalBacklinksController),
                      _buildNumericTextField('Referring Domains', _referringDomainsController),
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
            onPressed: _createOrUpdateWebrank,
            child: Text(widget.webid != null ? 'Update' : 'Add'),
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
          FilteringTextInputFormatter.digitsOnly, // Allow digits only
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

  void _createOrUpdateWebrank() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
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

      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

      try {
        // Check if we are updating or creating a new web rank
        if (widget.webid != null) {
          // Update existing web rank
          await organizationViewModel.updateWebrank(
            widget.webid!, // Existing web rank ID
            loggedInUserEmail,
            selectedProject!,
            selectedProjectName!,
            _domainAuthorityController.text,
            _alexaGlobalRankController.text,
            _alexaUSARankController.text,
            _alexaIndiaRankController.text,
            _externalBacklinksController.text,
            _referringDomainsController.text,
            widget.orgSlug,
            widget.orgRoleId,
            widget.orgUserId,
            widget.orgUserorgId,
          );
        } else {
          // Create a new web rank
          await organizationViewModel.createWebrank(
            loggedInUserEmail,
            selectedProject!,
            selectedProjectName!,
            _domainAuthorityController.text,
            _alexaGlobalRankController.text,
            _alexaUSARankController.text,
            _alexaIndiaRankController.text,
            _externalBacklinksController.text,
            _referringDomainsController.text,
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
            builder: (context) => WebScreen(orgSlug: widget.orgSlug),
          ),
        );



      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  void dispose() {
    _domainAuthorityController.dispose();
    _alexaGlobalRankController.dispose();
    _alexaUSARankController.dispose();
    _alexaIndiaRankController.dispose();
    _externalBacklinksController.dispose();
    _referringDomainsController.dispose();
    super.dispose();
  }
}