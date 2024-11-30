import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';
import 'package:flutter_application_1/model/influencerwork.dart';
import 'package:flutter_application_1/model/order.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_application_1/Screen/layout/influencerworkmixin.dart';

class MyInfluncerWork extends StatefulWidget {
  const MyInfluncerWork({super.key});

  @override
  State<MyInfluncerWork> createState() => _MyInfluncerWorkState();
}

class _MyInfluncerWorkState extends State<MyInfluncerWork>
    with NavigationMixin, InfluncerWorkMixin {
  TextEditingController _searchController = TextEditingController();
  bool _isLoggedIn = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    Map<String, String?> credentials = await _getCredentials();
    String? email = credentials['email'];
    String? password = credentials['password'];
    if (email != null && password != null) {
      setState(() {
        _isLoggedIn = true;
        _email = email;
      });
      // Fetch data only after login is confirmed
      Provider.of<InfluencerViewModel>(context, listen: false)
          .fetchWorkdetail(email);
    }
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  @override
  Widget build(BuildContext context) {
    final influencerViewModel = Provider.of<InfluencerViewModel>(context);

    List<InfluncerWork> filteredOrders =
        influencerViewModel.fetchwork.where((order) {
      bool matchesSearch = order.ordersId != null &&
          order.ordersId!.toLowerCase().contains(_searchController.text.toLowerCase());
      bool matchesStatus = order.status != null &&
          order.status.toString().contains(_searchController.text.toLowerCase());
      return matchesSearch || matchesStatus;
    }).toList();

    return Scaffold(
      body: buildBaseScreen(
        currentIndex: 0,
        title: 'Influencer Work Detail',
        body: RefreshIndicator(
          onRefresh: () async {
            // Manually trigger the refresh
            await influencerViewModel.fetchOrders(_email);
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by name or status',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              buildInfluencerworkList(context, filteredOrders, _email), // Pass email here
            ],
          ),
        ),
      ),
 
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Manual refresh when the button is pressed
          await influencerViewModel.fetchWorkdetail(_email);
          setState(() {}); // Update the UI after refreshing
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
