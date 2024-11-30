import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Auth/loginscreen.dart';
import 'package:wizbrand/Screen/Influencer/dashboard.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/view_modal/Login_view_model.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with NavigationMixin {
  String _searchQuery = '';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _fetchData(); // Initial data fetch
  }

  Future<void> _fetchData() async {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final credentials = await _getCredentials();
    await organizationViewModel.getuserOrganizationData(credentials['email']); // Fetching filtered data
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    return {'email': email};
  }
  void _logout() async {
    await secureStorage.delete(key: 'email');
    await secureStorage.delete(key: 'password');
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    loginViewModel.logout(context).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context); // Access view model

    return buildBaseScreen(
      currentIndex: 0, // Set the appropriate index for the bottom nav bar
      title: 'Wizbrand',
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchData(); // Refresh data on pull-to-refresh
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTopButtons(), // Add organization button and logout icon
              _buildSearchField(), // Search field for organizations
              Expanded(
                child: _buildCardList(organizationViewModel), // Organization cards
              ),
              _buildPagination(), // Pagination if needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () async {
                final credentials = await _getCredentials();
                final email = credentials['email'];
                if (email != null) {
                  _showAddOrganizationModal(
                    email: email,
                    onSave: (name) async {
                      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
                      await organizationViewModel.saveOrganization(context,email, name);
                      await _fetchData();
                    },
                    viewModel: Provider.of<OrganizationViewModel>(context, listen: false),
                  );
                }
              },
              child: Text('+Add Organization', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.power_settings_new, color: Colors.blue),
          onPressed: () {
             _logout();
          },
        ),
      ],
    );
  }

  void _showAddOrganizationModal({
    required String email,
    String? organizationName,
    required Function(String) onSave,
    required OrganizationViewModel viewModel,
    String? organizationId,
  }) {
    final TextEditingController _controller = TextEditingController(text: organizationName);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                organizationName == null ? 'Add New Organization' : 'Edit Organization',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Organization Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final name = _controller.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Organization name cannot be empty')));
                      return;
                    }
                    try {
                      if (organizationId != null) {
                        final response = await viewModel.updateOrganization(email, organizationId, name);
                        if (response['success']) {
                          await _fetchData();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
                        }
                      } else {
                        onSave(name);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
                    }
                  },
                  child: Text(organizationName == null ? 'Add' : 'Save', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 59, 59, 255)),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search by Organization Name',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase(); // Update search query
          });
          _fetchData(); // Re-fetch data based on search query
        },
      ),
    );
  }

  Widget _buildCardList(OrganizationViewModel organizationViewModel) {
    // Use filtereduserOrganizations directly
    if (organizationViewModel.isLoading) {
      return Center(child: CircularProgressIndicator()); // Show loading spinner
    }

    if (organizationViewModel.filtereduserOrganizations.isEmpty) {
      return Center(child: Text('No organizations found.')); // Show message when no data
    }

    return ListView.builder(
      itemCount: organizationViewModel.filtereduserOrganizations.length,
      itemBuilder: (context, index) {
        final organization = organizationViewModel.filtereduserOrganizations[index];
print("Organization at index $index: ${organization.toJson()}");
        return _buildCard(
          id: organization.id.toString(),
          name: organization.orgName ?? 'Unknown',
      //    : organization.orgUserEmail ?? 'Unknown',
          onContinue: () async {
              final secureStorage = FlutterSecureStorage();
        await secureStorage.delete(key: 'orgRoleId'); // Delete orgRoleId
        await secureStorage.delete(key: 'orgUserId'); // Delete orgRoleId
        await secureStorage.delete(key: 'orgUserorgId'); // Delete orgRoleId

          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              orgSlug: organization.orgSlug!, // Existing parameter
              orgRoleId: organization.orgRoleId!, // New parameter
              orgUserId: organization.orgUserId.toString(), // New parameter
              orgUserorgId: organization.id.toString(), // New parameter
            ),
          ),
        );
          },
          onEdit: () {
            _showAddOrganizationModal(
              email: organization.orgUserEmail!,
              organizationName: organization.orgName,
              onSave: (newName) async {
                final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
                await organizationViewModel.saveOrganization(context,organization.orgUserEmail!, newName);
                await _fetchData(); // Refresh data
              },
              viewModel: organizationViewModel,
              organizationId: organization.id.toString(),
            );
          },
          onDelete: () async {
            final confirmation = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Delete Organization'),
                content: Text('Are you sure you want to delete this organization?'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Cancel')),
                  TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Delete')),
                ],
              ),
            );
if (confirmation == true) {
  final response = await organizationViewModel.deleteOrganization(
    organization.orgUserEmail!,
    organization.id.toString(),
  );

  if (response['success']) {
    // If delete is successful, navigate to HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  } else {
    // If delete fails, show a dialog box
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Failed'),
          content: Text('The organization could not be deleted.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
          },
        );
      },
    );
  }

  Widget _buildCard({
    required String id,
    required String name,
    required VoidCallback onContinue,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: onContinue, child: Text('Continue Dashboard'), style: ElevatedButton.styleFrom(backgroundColor: Colors.teal)),
                Row(
                  children: [
                    IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
                    IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Showing 1 to ${Provider.of<OrganizationViewModel>(context).filtereduserOrganizations.length} entries'),
          Row(
            children: [
              IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
              Text('1'),
              IconButton(icon: Icon(Icons.arrow_forward), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}