import 'package:flutter/material.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/createphonescreen.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/model/phone.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';

class PhoneScreen extends StatefulWidget {
  final String orgSlug;
  PhoneScreen({required this.orgSlug});
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}




class _PhoneScreenState extends State<PhoneScreen> with DrawerMixin, RoleMixin, NavigationMixin { 
  String _userRole = '';
  String? _phoneNumber;
  TextEditingController _searchController = TextEditingController();
List<PhoneModel> _filteredPhones = []; // List to hold filtered phone numbers
  final TextEditingController _phoneController = TextEditingController();
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
        await organizationViewModel.getPhoneassets(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());
        _filteredPhones = organizationViewModel.my_phones; // Initialize with full data
    }
  }
void _filterPhones(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final allPhones = organizationViewModel.my_phones;

    setState(() {
        _filteredPhones = allPhones.where((phoneItem) {
            final phoneLower = phoneItem.phone?.toLowerCase() ?? '';
            final carrierLower = phoneItem.carrier?.toLowerCase() ?? '';
            final queryLower = query.toLowerCase();

            return phoneLower.contains(queryLower) || carrierLower.contains(queryLower);
        }).toList();
    });
}
  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  Future<void> _savePhoneNumber() async {
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'phoneNumber', value: _phoneController.text);
    setState(() {
      _phoneNumber = _phoneController.text; // Update displayed phone number
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Phone number saved successfully')),
    );
  }


  void _showAddPhoneDialog() async {
  // Fetch the parameters from secure storage
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreatePhoneDialog (
        orgSlug: widget.orgSlug, // Pass the existing parameter
        orgRoleId: orgRoleId!,   // Pass the new parameter
        orgUserId: orgUserId!,   // Pass the new parameter
        orgUserorgId: orgUserorgId!, // Pass the new parameter
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
     '$_userName - $_userRole', // Display role dynamically in the AppBar
          style: TextStyle(color: Colors.white),
        ),

        actions: buildAppBarActions(context),
      ),
      drawer: buildDrawer(context, orgSlug: widget.orgSlug),
      body: buildBaseScreen(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           
              // Add Phone Number button at the top
              if (_userRole != 'User') 
              ElevatedButton(
                onPressed: _showAddPhoneDialog,
                child: Text('Add Phone Number'),
              ),
              SizedBox(height: 20),
              Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
            labelText: 'Search by Phone or Carrier',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
            _filterPhones(value); // Call filter method on text change
        },
    ),
),
              // ListView for displaying fetched phone numbers
              Expanded(
                child: organizationViewModel.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _filteredPhones.isEmpty
                        ? Center(child: Text('No phone numbers found for this organization.'))
                        : ListView.builder(
                            itemCount: _filteredPhones.length,
            itemBuilder: (context, index) {
                final phoneItem = _filteredPhones[index];

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.grey[300]!),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Phone: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${phoneItem.phone ?? 'No Phone Number'}', // The dynamic part
                                            style: TextStyle(
                                              fontSize: 14,color: Colors.black, // Regular size for the email
                                              fontWeight: FontWeight.normal, // Regular font weight for the email
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Carrier: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${phoneItem.carrier ?? 'No Carrier'}', // The dynamic part
                                            style: TextStyle(
                                              fontSize: 14,color: Colors.black, // Regular size for the email
                                              fontWeight: FontWeight.normal, // Regular font weight for the email
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                          RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Owner: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${phoneItem.owner ?? 'No Owner'}', // The dynamic part
                                            style: TextStyle(
                                              fontSize: 14,color: Colors.black, // Regular size for the email
                                              fontWeight: FontWeight.normal, // Regular font weight for the email
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                      SizedBox(height: 8), // Space between text and icons
                                            RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Status: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${phoneItem.status ?? 'No Status available'}', // The dynamic part
                                            style: TextStyle(
                                              fontSize: 14,color: Colors.black, // Regular size for the email
                                              fontWeight: FontWeight.normal, // Regular font weight for the email
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                      SizedBox(height: 8), 
                                            RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'last Used: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${phoneItem.lastUsed ?? 'No last Used'}', // The dynamic part
                                            style: TextStyle(
                                              fontSize: 14,color: Colors.black, // Regular size for the email
                                              fontWeight: FontWeight.normal, // Regular font weight for the email
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8), 
                                            RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Last Recharged: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${phoneItem.lastRecharge ?? 'No Last Recharged'}', // The dynamic part
                                            style: TextStyle(
                                              fontSize: 14,color: Colors.black, // Regular size for the email
                                              fontWeight: FontWeight.normal, // Regular font weight for the email
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    
                                 SizedBox(height: 8),
                                  RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Country: ', // The static part
                                            style: TextStyle(
                                              fontSize: 16,color: Colors.black,
                                              fontWeight: FontWeight.bold, // Bold style for 'Email:'
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${phoneItem.state ?? 'Country'}', // The dynamic part
                                            style: TextStyle(
                                              fontSize: 14,color: Colors.black, // Regular size for the email
                                              fontWeight: FontWeight.normal, // Regular font weight for the email
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                      

                                      SizedBox(height: 8), 
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          if (_userRole != 'User') 
                                          IconButton(
                                            icon: Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () {
                                              _showEditPhoneDialog(phoneItem); // Implement your edit logic
                                            },
                                            tooltip: 'Edit Phone',
                                          ),
                                           if (_userRole != 'Manager' && _userRole != 'User') 
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              _showDeletePhoneDialog(context, phoneItem);
                                             
                                            },
                                            tooltip: 'Delete Phone',
                                          ),
                                        ],
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
            title: 'Phone Screen', // Set the title as needed
      ),


    );
  }

void _showEditPhoneDialog(phoneItem) async {
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreatePhoneDialog(
        orgSlug: widget.orgSlug, // Pass the existing parameter
        orgRoleId: orgRoleId!,   // Pass the new parameter
        orgUserId: orgUserId!,   // Pass the new parameter
        orgUserorgId: orgUserorgId!, // Pass the new parameter
        phone: phoneItem.phone, // Existing phone number
        carrier: phoneItem.carrier, // Existing carrier
        owner: phoneItem.owner, // Existing owner
        status: phoneItem.status, // Existing status
        lastUsed: phoneItem.lastUsed, // Existing last used
        lastRecharge: phoneItem.lastRecharge, // Corrected to match the property name
        state: phoneItem.state, // Existing country
        id: phoneItem.id // Pass ID if needed
      );
    },
  );
}


  void _showDeletePhoneDialog(BuildContext context, phoneItem) async {
  // Show confirmation dialog
  final confirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Phone'),
        content: Text('Are you sure you want to delete this phone?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel action
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm action
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      );
    },
  );

  // If confirmed, call the API to delete the project
  if (confirmed == true) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    
    try {
      // Make API call to delete the project
      await organizationViewModel.deletePhone(
        phoneItem.id, // Pass the project ID for deletion
        widget.orgSlug, // Pass the organization slug if necessary
      );
      
      // After deletion, fetch updated data
      _fetchData(); // Refresh the project list
    } catch (error) {
      print("Error while deleting project: $error");
    }
  }
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

  // Helper method to determine user role
 
}