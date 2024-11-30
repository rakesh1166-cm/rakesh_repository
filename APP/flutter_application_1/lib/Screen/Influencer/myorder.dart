import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';
import 'package:flutter_application_1/model/order.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_application_1/Screen/layout/ordermixins.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});
  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}
class _MyOrderScreenState extends State<MyOrderScreen> with NavigationMixin, OrderListMixin {
  TextEditingController _searchController = TextEditingController();
  bool _isLoggedIn = false;
  String? _email;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Map<String, String?> credentials = await _getCredentials();
      String? email = credentials['email'];
      String? password = credentials['password'];
      if (email != null && password != null) {
        setState(() {
          _isLoggedIn = true;
          _email = email;
        });
        Provider.of<InfluencerViewModel>(context, listen: false).fetchOrders(email);
      }
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
    final influencerViewModel = Provider.of<InfluencerViewModel>(context);
    print("Available influencerViewModel: ${influencerViewModel.influencers.map((c) => c.cartSocials).toList()}");

    List<Order> filteredOrders = influencerViewModel.orders.where((order) {
      bool matchesSearch = order.orderId != null &&
          order.orderId!.toLowerCase().contains(_searchController.text.toLowerCase());          
      bool matchesStatus = order.status != null &&
          order.status.toString().contains(_searchController.text.toLowerCase());
      return matchesSearch || matchesStatus;
    }).toList();

    return buildBaseScreen(
      currentIndex: 0, // Set the appropriate index for the bottom nav bar
      title: 'My Orders',
      body: RefreshIndicator(
        onRefresh: () async {
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
            buildOrderList(context, filteredOrders, _email), // Pass email here
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