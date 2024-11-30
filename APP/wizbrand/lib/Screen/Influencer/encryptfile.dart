import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/createwebasset.dart';
import 'package:wizbrand/Screen/Influencer/mywebview.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class EncryptDialog extends StatefulWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;
  final String projectName;
  final String tokenname; 
  final String? view; // Existing description
  final int id;
 

  const EncryptDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    required this.projectName,
    required this.tokenname,
    required this.view,
    required this.id,
 
    Key? key,
  }) : super(key: key);

  @override
  _EncryptDialogState createState() => _EncryptDialogState();
}

class _EncryptDialogState extends State<EncryptDialog> {
 PlatformFile? selectedFile; 


 Future<Map<String, String>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    final email = await secureStorage.read(key: 'email');
    return {'email': email ?? ''};
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

void _submit() async {
  // Check if a file is selected
  if (selectedFile != null) {
    setState(() {
      // Optionally, you can show a loading indicator
    });
    try {
      // Assuming you have a function to get credentials
      final credentials = await _getCredentials();
      final loggedInUserEmail = credentials['email'];

      if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User email is required')),
        );
        return;
      }

      final requestData = {
        'email': loggedInUserEmail,
        'project_name': widget.projectName,
        'token_name': widget.tokenname,
        'id': widget.id.toString(),
        'document': selectedFile?.path,
        'org_slug': widget.orgSlug,
        'org_role_id': widget.orgRoleId,
        'org_user_id': widget.orgUserId,
        'org_user_org_id': widget.orgUserorgId,
      };

      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

      // Call the method to create or update the organization
      final result = await organizationViewModel.openwebasset(
        widget.orgSlug,
        widget.orgRoleId,
        widget.orgUserId,
        widget.orgUserorgId,
        requestData['project_name'] ?? '',
        requestData['token_name'] ?? '',
        requestData['document'] ?? '',
        loggedInUserEmail,
        widget.id.toString(),
      );

      // Debug the result
      print("API Response: $result"); // Add this line to debug
      // Check if the operation was successful
     if (result != null && result['pro_name'] != null) {
  print("data is here");  
  // Instead of accessing result['data'], access the fields directly
 
  
  // Redirect to CreateWebsiteAssetDialog
 if (widget.view == 'myview') {
          // Navigate to a different Dart file
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyWebView(
                orgSlug: widget.orgSlug,
                orgRoleId: widget.orgRoleId,
                orgUserId: widget.orgUserId,
                orgUserorgId: widget.orgUserorgId,
                projectName: result['pro_name'] ?? 'No Project Name',
                Tasktype: result['type_task'] ?? 'No Task Type',
                webname: result['website'] ?? widget.id.toString(),
                token_engineer: result['mytoken_engineer'] ?? widget.id.toString(),
                username: result['username'] ?? widget.id.toString(),
                email: result['email'] ?? widget.id.toString(),
                password: result['password'] ?? widget.id.toString(),
                pro_name: result['pro_name'] ?? widget.id.toString(),
                pro_engg: result['pro_engg'] ?? widget.id.toString(),
                id: int.tryParse(result['myid']?.toString() ?? '0') ?? 0, // Convert to int safely
              ),
            ),
          );
        } else {
          // Redirect to CreateWebsiteAssetDialog
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateWebsiteAssetDialog(
                orgSlug: widget.orgSlug,
                orgRoleId: widget.orgRoleId,
                orgUserId: widget.orgUserId,
                orgUserorgId: widget.orgUserorgId,
                projectName: result['pro_name'] ?? 'No Project Name',
                Tasktype: result['type_task'] ?? 'No Task Type',
                webname: result['website'] ?? widget.id.toString(),
                token_engineer: result['mytoken_engineer'] ?? widget.id.toString(),
                username: result['username'] ?? widget.id.toString(),
                email: result['email'] ?? widget.id.toString(),
                password: result['password'] ?? widget.id.toString(),
                pro_name: result['pro_name'] ?? widget.id.toString(),
                pro_engg: result['pro_engg'] ?? widget.id.toString(),
                  type:"asset",
                id: int.tryParse(result['myid']?.toString() ?? '0') ?? 0, // Convert to int safely
              ),
            ),
          );
        }

} else {
  // Show error message if the operation failed
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(result['message'] ?? 'Failed to create asset.')),
  );
}
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  } else {
    // Show error if no file is selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please choose a file to upload.')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Upload Private Key to Decrypt'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Upload (${widget.tokenname}) private key to decrypt:'),
          SizedBox(height: 10),
          Row(
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
          else
            Text('No file chosen'),
        ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text('Submit'),
        ),
      ],
    );
  }
}