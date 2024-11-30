import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/phonescreen.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';
import 'package:wizbrand/view_modal/country_view_model.dart'; // Import the CountryViewModel

class CreatePhoneDialog extends StatefulWidget {
  final String orgSlug;
  final String orgRoleId;
  final String orgUserId;
  final String orgUserorgId;
  final String? phone;
  final String? carrier;
  final String? owner;
  final String? status;
  final String? lastUsed;
  final String? lastRecharge;
  final String? state; // Country  
  final int? id;

  CreatePhoneDialog({
    required this.orgSlug,
    required this.orgRoleId,
    required this.orgUserId,
    required this.orgUserorgId,
    this.phone,
    this.carrier,
    this.owner,
    this.status,
    this.lastUsed,
    this.lastRecharge,
    this.state,
    this.id,
  });

  @override
  _CreatePhoneDialogState createState() => _CreatePhoneDialogState();
}

class _CreatePhoneDialogState extends State<CreatePhoneDialog> {
  late TextEditingController _phoneController;
  late TextEditingController _stateController;
  late TextEditingController _ownerController;
  late TextEditingController _statusController;
  late TextEditingController _lastUsedController;
  late TextEditingController _lastRechargedController;

  String? _errorMessage;
  String? selectedManager;
  String? selectedCarrier;
  List<String> managerEmails = [];
  String? selectedCountry; // For the selected country
  bool isLoading = false; // To show a loading state while fetching data and saving
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

  final List<String> carriers = [
    'Airtel', 'BSNL', 'IDEA', 'JIO', 'China Mobile',
    'Vodafone Group', 'America Movil Group', 'Bharti Airtel',
    'Telefonica Group', 'China Unicom', 'VimpelCom Group',
    'Reliance', 'Telenor Group', 'China Telecom', 'MTN Group',
    'France Telecom', 'Telkomsel Group', 'Idea Cellular',
    'Sistema Group', 'Verizon Wireless', 'Deutsche Telekom',
    'AT&T', 'Telecom Italia', 'Movistar', 'Digicel', 'Claro',
    'China Telecom'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the passed phone data or empty values for new phones
    _phoneController = TextEditingController(text: widget.phone ?? '');
    _stateController = TextEditingController(text: widget.state ?? '');
    selectedCarrier = widget.carrier; // Use selectedCarrier for the carrier value
    selectedManager = widget.owner;
     selectedCountry = widget.state;
    _statusController = TextEditingController(text: widget.status ?? '');
    _lastUsedController = TextEditingController(text: widget.lastUsed ?? '');
    _lastRechargedController = TextEditingController(text: widget.lastRecharge ?? ''); 
    final countryViewModel = Provider.of<CountryViewModel>(context, listen: false);
    countryViewModel.fetchCountries();
    _fetchData(); // Fetch the necessary data when the widget initializes
  }




  Future<void> _fetchData() async {
    setState(() {
      isLoading = true; // Show loading while data is being fetched
    });

    try {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      final credentials = await _getCredentials();
      final email = credentials['email'];
      final orgSlug = widget.orgSlug;

      // Fetch organization data
      if (email != null && orgSlug.isNotEmpty) {
        await organizationViewModel.getUserFunction(email, orgSlug);
        // Extract all orgUserEmail values and remove duplicates
        final userOrgs = organizationViewModel.my_org;
        setState(() {
          managerEmails = userOrgs.map((user) => user.orgUserEmail).where((email) => email != null).cast<String>().toSet().toList();
          
          // Ensure selectedManager is valid
          if (!managerEmails.contains(selectedManager)) {
            selectedManager = null; // Reset to null if not found
          }
        });
      }
    } catch (e) {
      // Handle error fetching data
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<Map<String, String>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    final email = await secureStorage.read(key: 'email');
    return {'email': email ?? ''};
  }

  Future<void> _createOrUpdatePhone() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Set loading state
      });

      try {
        final credentials = await _getCredentials();
        final loggedInUserEmail = credentials['email'];

        if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
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
          'email': loggedInUserEmail ?? '', // Ensure email is non-null
          'phone': _phoneController.text, // Phone number from the controller
          'carrier': selectedCarrier ?? '', // Use selectedCarrier here
          'owner': selectedManager, // Pass the selected owner from the dropdown
          'status': _statusController.text, // Status from the controller
          'last_used': _lastUsedController.text, // Last used from the controller
          'last_recharged': _lastRechargedController.text, // Last recharge from the controller
          'country': selectedCountry ?? '', // Ensure selectedCountry is non-null
          'org_slug': widget.orgSlug, // Organization slug
          'org_role_id': widget.orgRoleId, // Organization role ID
          'org_user_id': widget.orgUserId, // Organization user ID
          'org_user_org_id': widget.orgUserorgId, // Organization user organization ID
        };

        // Call the appropriate method for create or update based on whether an ID exists
        final response = await (widget.id == null
            ? organizationViewModel.createPhone(
                loggedInUserEmail, // Pass the email directly
                _phoneController.text, // Pass the phone number directly
                selectedCarrier.toString(), // Use selectedCarrier directly
                selectedManager.toString(), // Pass the selected owner directly
                _statusController.text, // Pass the status directly
                _lastUsedController.text, // Pass the last used date directly
                _lastRechargedController.text, // Pass the last recharge date directly
                widget.orgSlug, // Pass the org slug
                widget.orgRoleId, // Pass the org role ID
                widget.orgUserId, // Pass the org user ID
                widget.orgUserorgId, // Pass the org user organization ID
              selectedCountry.toString(),
              ) // Create new phone
            : organizationViewModel.updatePhone(
                loggedInUserEmail, // Pass the email directly
                _phoneController.text, // Pass the phone number directly
                selectedCarrier.toString(), // Use selectedCarrier directly
                selectedManager.toString(), // Pass the selected owner directly
                _statusController.text, // Pass the status directly
                _lastUsedController.text, // Pass the last used date directly
                _lastRechargedController.text, // Pass the last recharge date directly
                widget.orgSlug, // Pass the org slug
                widget.id.toString(), // Pass the phone ID as a string
                widget.orgRoleId, // Pass the org role ID
                widget.orgUserId, // Pass the org user ID
                widget.orgUserorgId,
            selectedCountry.toString(), // Pass the org user organization ID
              ) // Update existing phone
        );

        setState(() {
          isLoading = false; // Reset loading state
        });

        if (response['success'] == true) {
          print('coming inside response');
          print(response['message']);
          print(response['success']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PhoneScreen(orgSlug: widget.orgSlug),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Failed to create/update phone.')),
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false; // Reset loading state
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating/updating phone: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final countryViewModel = Provider.of<CountryViewModel>(context);    
   return GestureDetector(
       onTap: () {
      FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside
    },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(widget.phone == null ? 'Add New Phone' : 'Edit Phone'),
        content: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView( // Wrap the content in SingleChildScrollView to avoid overflow
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.phone, // Ensure the keyboard is optimized for phone input
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          } else if (!RegExp(r'^\d{10}$').hasMatch(value)) { // Regex to check for exactly 10 digits
                            return 'Please enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
      
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Carrier',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        value: selectedCarrier,
                        items: carriers.map((carrier) {
                          return DropdownMenuItem<String>(
                            value: carrier,
                            child: Text(carrier),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCarrier = value; // Update selectedCarrier with the new value
                          });
                        },
                      ),
      
                      SizedBox(height: 10),                   
                      DropdownButtonFormField<String>(
                        value: selectedManager, 
                        hint: Text(widget.owner != null && widget.owner!.isNotEmpty ? widget.owner! : 'Select Owner'), // Use ternary operator
                        items: managerEmails.map((email) {
                          return DropdownMenuItem<String>(
                            value: email,
                            child: Text(email), // Display email in the dropdown
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedManager = value; // Update selectedManager with the new value
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an owner'; // Validation message
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _statusController,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _lastUsedController,
                        decoration: InputDecoration(
                          labelText: 'Last Used',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _lastRechargedController,
                        decoration: InputDecoration(
                          labelText: 'Last Recharged',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedCountry ?? widget.state, // Initialize with widget.state if selectedCountry is null
                        hint: Text('Select Country'),
                        items: countryViewModel.countries.map((country) {
                          return DropdownMenuItem<String>(
                            value: country.country_name, // Make sure this is the right property
                            child: Text(country.country_name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value; // Update selectedCountry with the new value
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a country';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _createOrUpdatePhone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(widget.phone == null ? 'Add' : 'Update'),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _ownerController.dispose();
    _statusController.dispose();
    _lastUsedController.dispose();
    _lastRechargedController.dispose();
    super.dispose();
  }
}