import 'dart:convert';  // Add this import for jsonDecode
import 'package:flutter/material.dart';
import 'package:wizbrand_influencer/Screen/layout/mixins.dart';
import 'package:wizbrand_influencer/Screen/layout/influencermixins.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../view_modal/influencer_view_model.dart';

class InfluencerStatics extends StatefulWidget {
  @override
  _InfluencerStaticsState createState() => _InfluencerStaticsState();
}

class _InfluencerStaticsState extends State<InfluencerStatics> with NavigationMixin, InfluencerListMixin {
  bool _isLoggedIn = false;
  String? _email;
  String _searchQuery = '';

  final List<Map<String, dynamic>> socialMediaSites = [
    {'name': 'facebook', 'icon': FontAwesomeIcons.facebook, 'color': Color(0xFF3b5998)}, // Facebook blue
    {'name': 'twitter', 'icon': FontAwesomeIcons.twitter, 'color': Color(0xFF1DA1F2)}, // Twitter blue
    {'name': 'instagram', 'icon': FontAwesomeIcons.instagram, 'color': Color(0xFFE1306C)}, // Instagram pink
    {'name': 'youtube', 'icon': FontAwesomeIcons.youtube, 'color': Color(0xFFc4302b)}, // YouTube red
    {'name': 'wordpress', 'icon': FontAwesomeIcons.wordpress, 'color': Color(0xFF21759B)}, // WordPress blue
    {'name': 'tumblr', 'icon': FontAwesomeIcons.tumblr, 'color': Color(0xFF35465C)}, // Tumblr blue
    {'name': 'pinterest', 'icon': FontAwesomeIcons.pinterest, 'color': Color(0xFFBD081C)}, // Pinterest red
    {'name': 'quora', 'icon': FontAwesomeIcons.quora, 'color': Color(0xFFB92B27)}, // Quora red
    {'name': 'reddit', 'icon': FontAwesomeIcons.reddit, 'color': Color(0xFFFF4500)}, // Reddit orange
    {'name': 'telegram', 'icon': FontAwesomeIcons.telegram, 'color': Color(0xFF0088cc)}, // Telegram blue
    {'name': 'linkedin', 'icon': FontAwesomeIcons.linkedin, 'color': Color(0xFF0077B5)}, // LinkedIn blue
  ];

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
        Provider.of<InfluencerViewModel>(context, listen: false).fetchInfluencersData(email);
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
    final becomeInfluencers = influencerViewModel.becomeinfluencers;

    print("Available becomeinfluencers: ${becomeInfluencers.map((c) => c.socialPrice).toList()}");

    Map<String, dynamic>? socialPrices;
    if (becomeInfluencers.isNotEmpty) {
      try {
        socialPrices = jsonDecode(becomeInfluencers.first.socialPrice ?? '{}');
      } catch (e) {
        print('Error decoding socialPrice: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Influencers'),
      ),
      body: buildBaseScreen(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: socialMediaSites.length, // Adjusted to dynamic number of items
                itemBuilder: (context, index) {
                  final socialSite = socialMediaSites[index];
                  final socialPrice = socialPrices?[socialSite['name']] ?? 'Not Available';
                  final hasPrice = socialPrice != 'Not Available';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    color: socialSite['color'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: FaIcon(socialSite['icon'], color: Colors.white),
                      title: Row(
                        children: [
                          FaIcon(
                            socialSite['icon'],
                            color: socialSite['color'],
                          ),
                          SizedBox(width: 8), // Adds some spacing between the icon and the text
                          Expanded(
                            child: Text(
                              _truncateWithEllipsis(30, socialSite['name']), // Limit to 30 characters
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: hasPrice ? Colors.white : Colors.white,
                              ),
                            ),
                          ),
                          if (hasPrice)
                            Icon(
                              Icons.check,
                              color: Color.fromARGB(255, 2, 245, 67),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Followers/Subscriber: "No Details"',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            'Number of Post: "No Influencer"',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            'Cost Per Video: $socialPrice',
                            style: TextStyle(color: Colors.white70),
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
        currentIndex: 0,
        title: 'Influencer Statics',
      ),
    );
  }

  String _truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
  }
}