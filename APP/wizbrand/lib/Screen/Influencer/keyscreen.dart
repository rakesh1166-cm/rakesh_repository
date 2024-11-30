import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/model/webassets.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class KeyScreen extends StatefulWidget {
  final String orgSlug;
  KeyScreen({required this.orgSlug});
  
  @override
  _KeyScreenState createState() => _KeyScreenState();
}

class _KeyScreenState extends State<KeyScreen> with DrawerMixin, RoleMixin, NavigationMixin {
  String _userRole = '';
  List<KeyData> _filteredKeys = [];
  bool isLoading = false;
  String _userName = ''; // Variable to store the user's name

  @override
  void initState() {
    super.initState();
    _fetchData();
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
      await organizationViewModel.getToken(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());
      setState(() {
        _filteredKeys = organizationViewModel.my_tokens.map((token) {
          return KeyData(
            keyName: token.token.toString(),
            keyDate: token.keydate.toString(),
            keyId: token.keyid.toString(),
          );
        }).toList();
        isLoading = false;
      });
    }
  }

    void _showDeleteKeyDialog(BuildContext context, KeyData keyData) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Key'),
          content: Text('Are you sure you want to delete this key?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      try {
        await organizationViewModel.deleteKey(keyData.keyId);
        _fetchData(); // Refresh the list after deletion
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Key deleted successfully")));
      } catch (error) {
        print("Error while deleting key: $error");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting key")));
      }
    }
  }
Future<void> generateAndDownloadKey(TextEditingController keyController) async {
  final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
  final credentials = await _getCredentials();
  final email = credentials['email'];
  final orgRoleId = await FlutterSecureStorage().read(key: 'orgRoleId');
  final orgUserId = await FlutterSecureStorage().read(key: 'orgUserId');
  final orgUserorgId = await FlutterSecureStorage().read(key: 'orgUserorgId');

  // Get the key name from the controller
  String keyName = keyController.text.trim();

  try {
    // Call the generatekey method to generate key and get response
    final response = await organizationViewModel.generatekey(
      email!,
      widget.orgSlug,
      orgRoleId!,
      orgUserId!,
      orgUserorgId!,
      keyName, // Pass the key name as a parameter
    );

if (response['success'] == true) {
      // Access the private key directly from the response
      final privateKey = response['response']; // This should now work as expected
      print("Private key received: $privateKey"); // Debugging line

      if (privateKey != null) {
        // Save the private key to a file
        await _savePrivateKeyToFile(privateKey, keyName); // Save the private key as a .pem file
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Key downloaded successfully")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Private key not found")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? "Failed to generate key")));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error generating key: $e")));
  }
}




Future<void> requestStoragePermission() async {
  // Request basic storage permissions
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }

  // For Android 11 and above, request MANAGE_EXTERNAL_STORAGE permission for broad file access
  if (await Permission.manageExternalStorage.isDenied) {
    await Permission.manageExternalStorage.request();
  }
}

/// Function to save a private key file to the "Downloads" folder
Future<void> _savePrivateKeyToFile(String privateKey, String keyName) async {
  try {
    // Request storage permission
    await requestStoragePermission();

    // Set the path to the Downloads folder on Android
    final downloadsDirPath = '/storage/emulated/0/Download';

    // Insert "privatekey" dynamically into the file name
    final fileName = keyName + 'privatekey.pem'; // Concatenate "privatekey" with the specified keyName
    final filePath = '$downloadsDirPath/$fileName'; // Construct the full path

    // Write the private key to the file in the Downloads folder
    final file = File(filePath);
    await file.writeAsString(privateKey);
    
    print("Private key saved to: $filePath");
  } catch (e) {
    print("Save error: $e");
  }
}
  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    return {'email': email};
  }

  // Method to show the dialog for generating a new key
  void _showGenerateKeyDialog() {
    final TextEditingController keyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Generate New Key'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: keyController,
                decoration: InputDecoration(labelText: 'Key'),
              ),
              // Add other input fields if necessary
            ],
          ),
         actions: [
          TextButton(
            onPressed: () {
             generateAndDownloadKey(keyController); // Pass the controller itself
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Generate'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close the dialog
            child: Text('Cancel'),
          ),
        ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
       '$_userName - $_userRole', // Display role dynamically in the AppBar
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: buildDrawer(context, orgSlug: widget.orgSlug),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : buildBaseScreen(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _showGenerateKeyDialog,
                      child: Text('Generate Key'),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredKeys.length,
                        itemBuilder: (context, index) {
                          final keyData = _filteredKeys[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Key: ${keyData.keyName}', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('Key Date: ${keyData.keyDate}'),
                                      Text('Key ID: ${keyData.keyId}'),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteKeyDialog(context, keyData);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
                currentIndex: 0, // Set an appropriate index
            title: 'Generate Key', // Set the title as needed
            ),
    );
  }

Widget buildBaseScreen({required Widget body, required int currentIndex, required String title}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Column(
      children: [
        // Optionally, add a title if needed
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: body),
      ],
    ),
  );
}
}

// Sample KeyData class to represent each key item
class KeyData {
  final String keyName;
  final String keyDate;
  final String keyId;

  KeyData({required this.keyName, required this.keyDate, required this.keyId});
}
