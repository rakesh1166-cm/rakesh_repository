import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wizbrand_influencer/Screen/Influencer/profilescreen.dart';
import 'package:wizbrand_influencer/model/search_influencer.dart';
import 'package:wizbrand_influencer/view_modal/influencer_view_model.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand_influencer/main.dart';


mixin InfluencerListMixin<T extends StatefulWidget> on State<T> {
  Map<String, bool> checkboxSelections = {};

  Widget buildInfluencerList(BuildContext context, List<SearchInfluencer> filteredInfluencers, bool isLoggedIn, String? email) {
    return Consumer<InfluencerViewModel>(
      builder: (context, influencerViewModel, child) {
        return Expanded(
          child: influencerViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredInfluencers.isEmpty
                  ? const Center(child: Text('No influencers found'))
                  : ListView.builder(
                      itemCount: filteredInfluencers.length,
                      itemBuilder: (context, index) {
                        final influencer = filteredInfluencers[index];
                        Map<String, dynamic>? socialPrices;
                        try {
                          final influencerFromViewModel = influencerViewModel.influencers.firstWhere((inf) => inf.id == influencer.id, orElse: () => influencer);
                          socialPrices = influencerFromViewModel.socialPrice != null ? jsonDecode(influencerFromViewModel.socialPrice!) : null;
                        } catch (e) {
                          print('Error decoding socialPrice: $e');
                        }

                        final cartSocials = influencerViewModel.influencers
                            .firstWhere(
                              (inf) => inf.id == influencer.id && inf.adminEmail == email,
                              orElse: () => influencer,
                            )
                            .cartSocials;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.all(4.0),
                                  leading:  Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40, // Set the width and height as per your requirement
                          height: 40,
                          child: Image(
                                                                                        height: displayHeight(
                                                                                                context) *
                                                                                            0.18,
                                                                                        width: displayWidth(
                                                                                                context) *
                                                                                            0.32,
                                                                                        image:
                                                                                            NetworkImage(
                                                                                        influencer.filePic !=
                                                                                                  null
                                                                                              ? 'https://www.wizbrand.com/storage/images/' +
                                                                                                  influencer.filePic.toString()
                                                                                              : "https://www.wizbrand.com/assets/images/users/default.webp",
                                                                                        ),
                                                                                        fit: BoxFit
                                                                                            .cover),
                        ),
                      ),
                    ],
                  ),
                title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text(
              (influencer.userName ?? "No Name").length > 20
                ? (influencer.userName ?? "No Name").substring(0, 20) + "..."
                : (influencer.userName ?? "No Name"),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
                          TextButton(
                          onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(userEmail: influencer.userEmail.toString()),
                  ),
                );
              },
                            child: Text('View Profile'),
                          ),
                        ],
                      ),
                                  subtitle: Text(
                                    '${influencer.countryName?? "No Country"} / ${influencer.stateName ?? "No State"} / ${influencer.cityName ?? "No City"}',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                                if (socialPrices != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: Wrap(
                                      spacing: 10.0,
                                      runSpacing: 5.0,
                                      children: socialPrices.entries.map((entry) {
                                        final checkboxKey = '${influencer.id}_${entry.key}';
                                        final isInCart = cartSocials?.contains(entry.key) ?? false;
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Chip(
                                              avatar: CircleAvatar(
                                                backgroundColor: Colors.transparent,
                                                child: Icon(
                                                  influencerViewModel.getSocialIcon(entry.key),
                                                  color: influencerViewModel.getSocialIconColor(entry.key),
                                                  size: 18.0,
                                                ),
                                              ),
                                              label: Text(
                                                isLoggedIn ? '${entry.value} ${influencer.socialCurrency}' : '',
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: Text('No social data'),
                                  ),
                           
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}