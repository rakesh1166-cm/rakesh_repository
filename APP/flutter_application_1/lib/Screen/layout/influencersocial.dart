import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Influencer/cart.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/search_influencer.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:provider/provider.dart';

mixin InfluencersocialListMixin<T extends StatefulWidget> on State<T> {
  Map<String, bool> checkboxSelections = {};

  Widget buildInfluencersocialList(BuildContext context, List<SearchInfluencer> filteredInfluencers, bool isLoggedIn, String? email, List<String> selectedSocialSites) {
    return Consumer<InfluencerViewModel>(
      builder: (context, influencerViewModel, child) {
        print("InfluencersocialListMixin influencerViewModel InfluencersocialListMixin: ${influencerViewModel.influencers.map((c) => c.cartSocials).toList()}");

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
                          // Use socialPrices from view model if available, otherwise decode influencer's socialPrice
                          final influencerFromViewModel = influencerViewModel
                              .influencers
                              .firstWhere((inf) => inf.id == influencer.id,
                                  orElse: () => influencer);
                          socialPrices = influencerFromViewModel.socialPrice !=
                                  null
                              ? jsonDecode(influencerFromViewModel.socialPrice!)
                              : null;
                        } catch (e) {
                          print('Error decoding socialPrice: $e');
                        }
                        // Extract cartSocials for the current influencer
                      final cartSocials =
                            influencerViewModel.influencers.firstWhere(
                          (inf) {
                            print(
                                "Checking influencer id: ${inf.id}, influencer id: ${influencer.id}, adminEmail: ${inf.adminEmail}");
                            return inf.id == influencer.id &&
                                influencer.adminEmail == email;
                          },
                          orElse: () {
                            print(
                                "No matching influencer found for id: ${influencer.id} and email: $email");
                            return influencer;
                          },
                        ).cartSocials;
 bool showGoToCartButton = isLoggedIn &&
                            cartSocials != null &&
                            cartSocials.isNotEmpty &&
                            influencer.adminEmail == email;
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
                                          width:
                                              40, // Set the width and height as per your requirement
                                          height: 40,
                                          child: Image(
                                              height:
                                                  displayHeight(context) * 0.18,
                                              width:
                                                  displayWidth(context) * 0.32,
                                              image: NetworkImage(
                                                influencer.filePic != null
                                                    ? 'https://www.wizbrand.com/storage/images/' +
                                                        influencer.filePic
                                                            .toString()
                                                    : "https://www.wizbrand.com/assets/images/users/default.webp",
                                              ),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    influencer.userName ?? "No Name",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '${influencer.countryName ?? "No Country"} / ${influencer.stateName ?? "No State"} / ${influencer.cityName ?? "No City"}',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                                if (socialPrices != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: Wrap(
                                      spacing: 10.0,
                                      runSpacing: 5.0,
                                      children: socialPrices.entries
                                          .where((entry) => selectedSocialSites.isEmpty || selectedSocialSites.contains(entry.key)) // Show all if no tags are selected
                                          .map((entry) {
                                            final checkboxKey = '${influencer.id}_${entry.key}';
                                           final isInCart = cartSocials
                                                ?.contains(entry.key) ??
                                            false; // Check if the social site is in cartSocials
                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (isLoggedIn) // Only show checkbox if logged in
                                                  isInCart
                                                      ? Icon(Icons.shopping_cart, size: 18.0)
                                                      : Checkbox(
                                                          value: checkboxSelections[checkboxKey] ?? false,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              checkboxSelections[checkboxKey] = value ?? false;
                                                              influencerViewModel.updateInfluencerSelection(
                                                                influencer.id.toString(),
                                                                entry.key,
                                                                value ?? false,
                                                                email ?? "", // Pass email parameter here
                                                              );
                                                            });
                                                          },
                                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                          visualDensity: VisualDensity.compact,
                                                        ),
                                                Chip(
                                                  avatar: CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    child: Icon(influencerViewModel.getSocialIcon(entry.key),
                                                      color: influencerViewModel.getSocialIconColor(entry.key),
                                                      size: 18.0, // Set the icon size here
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
                                        if (showGoToCartButton)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      width: double.infinity, // Full width
                                  child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CartScreen()), // Replace with your CartScreen widget
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 226, 225, 222), // Set the background color to green
                            textStyle: TextStyle(color: Colors.white), // Set the text color (optional)
                          ),
                          child: Text('Go to Cart'),
                        ),
                                                            ),
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