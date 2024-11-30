import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/model/organization.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class OrganizationScreen extends StatefulWidget {
  const OrganizationScreen({super.key});

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> with NavigationMixin {
  TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Select Filter By';
  bool _isLoggedIn = false;
  String? _email;
  List<Organization> _filteredOrganizations = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final credentials = await _getCredentials();
    await organizationViewModel.getOrganizationData(credentials['email']);
    _filteredOrganizations = organizationViewModel.organizations; // Initialize with full data
    setState(() {});
  }

  void _filterOrganizations(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final allOrganizations = organizationViewModel.organizations;

    setState(() {
      _filteredOrganizations = allOrganizations.where((organization) {
        final orgNameLower = organization.orgName?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();
        final dateString = organization.createdAt?.toLocal().toString().split(' ')[0] ?? '';

        return orgNameLower.contains(queryLower) || dateString.contains(queryLower);
      }).toList();
    });
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  @override
  Widget build(BuildContext context) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context);
    print("Organizations data: ${organizationViewModel.organizations}");

    return buildBaseScreen(
      currentIndex: 0, // Set the appropriate index for the bottom nav bar
      title: 'Wizbrand',
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchData();
        },
        child: Column(
          children: [
            // Single image of the organization at the top
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-dtLtSlAzO6Gehvd4IDlNfV9Cuu-Y3ti89PfgMaqCOiHVsCD4dPNNheQ8o7BTuELN3R8&usqp=CAU',
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            
            // Heading for "Organization"
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Organization',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search by name or date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _filterOrganizations(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredOrganizations.length,
                itemBuilder: (context, index) {
                  final organization = _filteredOrganizations[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ListTile(                  
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            organization.orgName ?? 'Unknown',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Date: ${organization.createdAt?.toLocal().toString().split(' ')[0] ?? 'Unknown'}'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
