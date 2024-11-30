import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/layout/influencermixins.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';
import 'package:flutter_application_1/model/search_influencer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/Screen/layout/influencersocial.dart';
import 'package:flutter_application_1/view_modal/tagviewmodel.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TagFilterScreen extends StatefulWidget {
  @override
  _TagFilterScreenState createState() => _TagFilterScreenState();
}

class _TagFilterScreenState extends State<TagFilterScreen>
    with NavigationMixin, InfluencerListMixin, InfluencersocialListMixin {
  List<String> _selectedTags = [];
  bool _isLoggedIn = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Provider.of<TagViewModel>(context, listen: false).fetchTags();

      Map<String, String?> credentials = await _getCredentials();
      String? email = credentials['email'];
      String? password = credentials['password'];

      if (email != null && password != null) {
        setState(() {
          _isLoggedIn = true;
          _email = email;
        });
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
    final tagViewModel = Provider.of<TagViewModel>(context);
    final influencerViewModel = Provider.of<InfluencerViewModel>(context);

    // Filter influencers based on selected tags
    List<SearchInfluencer> filteredInfluencers = influencerViewModel.influencers.where((influencer) {
      if (_selectedTags.isEmpty) {
        return true;
      }
      if (influencer.socialPrice == null) {
        return false;
      }
      // Decode the socialPrice JSON string
      Map<String, dynamic> socialPriceMap = json.decode(influencer.socialPrice!);
      bool matchesTags = _selectedTags.any((tag) => socialPriceMap.containsKey(tag));
      return matchesTags;
    }).toList();

    return buildBaseScreen(
      currentIndex: 1, // Set the appropriate index for the bottom nav bar
      title: 'Filter by Tags',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: tagViewModel.isLoading
                ? CircularProgressIndicator()
                : DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      labelText: "Select and remove Tags",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (newValue) {
                      if (newValue != null && !_selectedTags.contains(newValue)) {
                        setState(() {
                          _selectedTags.add(newValue);
                        });
                      }
                    },
                    items: tagViewModel.tags
                        .map((tag) => DropdownMenuItem<String>(
                              value: tag,
                              child: Text(tag),
                            ))
                        .toList(),
                  ),
          ),
          // Display selected tags as chips with delete button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              spacing: 8.0,
              children: _selectedTags.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  deleteIcon: Icon(Icons.close, color: Colors.red),
                  onDeleted: () {
                    setState(() {
                      _selectedTags.remove(tag);
                    });
                  },
                );
              }).toList(),
            ),
          ),
          buildInfluencersocialList(context, filteredInfluencers, _isLoggedIn, _email, _selectedTags),
        ],
      ),
    );
  }
}