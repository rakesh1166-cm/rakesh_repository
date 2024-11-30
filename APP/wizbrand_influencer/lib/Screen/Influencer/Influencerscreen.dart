import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wizbrand_influencer/Screen/layout/mixins.dart';
import 'package:wizbrand_influencer/Screen/layout/influencermixins.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand_influencer/model/search_influencer.dart';
import 'package:wizbrand_influencer/view_modal/influencer_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InfluencerScreen extends StatefulWidget {
  const InfluencerScreen({super.key});

  @override
  State<InfluencerScreen> createState() => _InfluencerScreenState();
}

class _InfluencerScreenState extends State<InfluencerScreen> with NavigationMixin, InfluencerListMixin {
  TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Select Filter By';
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
      // Pass email to fetchInfluencers
      Provider.of<InfluencerViewModel>(context, listen: false).fetchInfluencers(email);
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

    List<SearchInfluencer> filteredInfluencers = influencerViewModel.influencers.where((influencer) {
      bool matchesSearch = influencer.userName != null &&
          influencer.userName!.toLowerCase().contains(_searchController.text.toLowerCase());
      bool matchesCountry = influencer.countryName != null &&
          influencer.countryName!.toLowerCase().contains(_searchController.text.toLowerCase());
      bool matchesState = influencer.stateName != null &&
          influencer.stateName!.toLowerCase().contains(_searchController.text.toLowerCase());
      bool matchesCity = influencer.cityName != null &&
          influencer.cityName!.toLowerCase().contains(_searchController.text.toLowerCase());

      Map<String, dynamic>? socialPrices;
      try {
        socialPrices = jsonDecode(influencer.socialPrice ?? '{}');
      } catch (e) {
        print('Error decoding socialPrice: $e');
      }

      bool matchesSocialSite = socialPrices != null &&
          socialPrices.keys.any((key) => key.toLowerCase().contains(_searchController.text.toLowerCase()));

      return matchesSearch || matchesCountry || matchesState || matchesCity || matchesSocialSite;
    }).toList();

    return buildBaseScreen(
      currentIndex: 0, // Set the appropriate index for the bottom nav bar
      title: 'Influencer Profile',
      body: RefreshIndicator(
        onRefresh: () async {
          await influencerViewModel.fetchInfluencers(_email.toString());
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search by name, country, state, city or social site',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
         
             buildInfluencerList(context, filteredInfluencers, _isLoggedIn, _email),
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