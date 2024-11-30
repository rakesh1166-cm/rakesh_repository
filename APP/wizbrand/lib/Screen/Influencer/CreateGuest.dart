import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/guestscreen.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class CreateGuestMessageDialog extends StatefulWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;
  final String? title; // Title of the guest message
  final String? url; // URL of the guest message
  final int? id;

  CreateGuestMessageDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.title,
    this.url,
    this.id,
  });

  @override
  _CreateGuestMessageDialogState createState() => _CreateGuestMessageDialogState();
}

class _CreateGuestMessageDialogState extends State<CreateGuestMessageDialog> {
  late TextEditingController _titleController;
  late TextEditingController _urlController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with existing data
    _titleController = TextEditingController(text: widget.title);
    _urlController = TextEditingController(text: widget.url);
  }

Future<void> _sendMessage() async {
  setState(() {
    isLoading = true;
  });

  try {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final credentials = await _getCredentials();
    final email = credentials['email'];

    // Check if the user email is null
    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User email is required')),
      );
      return;
    }

    // Call the appropriate method for create or update based on whether an ID exists
    final response = await (widget.id == null
        ? organizationViewModel.createGuestMessage(email, _titleController.text, _urlController.text, widget.orgSlug, widget.orgRoleId, widget.orgUserId, widget.orgUserorgId)
        : organizationViewModel.updateGuestMessage(email, _titleController.text, _urlController.text, widget.orgSlug, widget.id.toString(), widget.orgRoleId, widget.orgUserId, widget.orgUserorgId));

    if (response['success'] == true) {
      print('coming inside response');
                   print(response['message']);
                    print(response['success']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GuestScreen(orgSlug: widget.orgSlug),
              ),
            );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Failed to send message.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error sending message: $e')),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  @override
  void dispose() {
    _titleController.dispose(); // Dispose the controllers
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
      FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside
    },
      child: AlertDialog(
        title: Text('Send Guest Message'),
        content: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter the title',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText: 'URL',
                      hintText: 'Enter the URL',
                    ),
                  ),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel action
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _sendMessage,
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}