import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Influencer/Influencerscreen.dart';
import 'package:flutter_application_1/Screen/Influencer/dashboard.dart';
import 'package:flutter_application_1/Screen/Influencer/paydetail.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';
import 'package:flutter_application_1/Screen/Influencer/locationfilter.dart';
import 'package:flutter_application_1/Screen/Influencer/socialsitefilter.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/cart.dart';
import 'package:flutter_application_1/model/search_influencer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'dart:convert'; // Import for JSON decoding

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with NavigationMixin<CartScreen> {
  TextEditingController _searchController = TextEditingController();
  String? _selectedCurrency;
  bool _isLoggedIn = false;
  String? _email;
bool _isUpdatingCurrency = false; // Add this variable to track loading state
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    Map<String, String?> credentials = await _getCredentials();
    String? email = credentials['email'];
    String? password = credentials['password'];
    if (email != null && password != null) {
      setState(() {
        _isLoggedIn = true;
        _email = email;
      });
      // Fetch the cart data initially
      await Provider.of<InfluencerViewModel>(context, listen: false).fetchCart(email);
    }
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  @override
@override
Widget build(BuildContext context) {
  final influencerViewModel = Provider.of<InfluencerViewModel>(context);

  // Filter cart items based on the search query
List<UserCart> filteredCarts = influencerViewModel.fetchcart.where((cartItem) {
  final String userName = cartItem.userName?.toLowerCase() ?? '';  // Handle null by using an empty string
  final String slug = cartItem.slug?.toLowerCase() ?? '';  // Handle null by using an empty string
  final String cartSocials = cartItem.cartSocials?.toLowerCase() ?? '';
  final String cartId = cartItem.cartId.toLowerCase(); // Assuming cartId is always non-null based on your model.
  // Print debugging information
  print("Checking userName: ${userName}, slug: ${slug}, cartId: ${cartId}");
  // Filter by userName, slug, cartSocials, or cartId
  return slug.contains(_searchController.text.toLowerCase()) ||
         userName.contains(_searchController.text.toLowerCase()) ||
         cartSocials.contains(_searchController.text.toLowerCase()) ||
         cartId.contains(_searchController.text.toLowerCase());
}).toList();
// Debug output for filtered results
print("Filtered cart items: ${filteredCarts.length}");
filteredCarts.forEach((cart) {
  print("Filtered cart userName: ${cart.userName}, slug: ${cart.slug}");
});


  // Check if the filtered carts have valid social data
  bool noSocialData = filteredCarts.isEmpty || filteredCarts.every((cartItem) {
    Map<String, dynamic>? socialPrices;
    try {
      socialPrices = jsonDecode(cartItem.cartSocials ?? '{}');
    } catch (e) {
      print('Error decoding socialPrice: $e');
    }
    return socialPrices == null || socialPrices.isEmpty;
  });

  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Wizbrand'),
    ),
    body: Stack(
      children: [
    buildBaseScreen(
  body: Column(
    children: [
      _buildSearchField(),
      _buildCurrencySelector(influencerViewModel, filteredCarts),
      // Cart list
      Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            await influencerViewModel.fetchCart(_email); // Reload cart on pull-to-refresh
          },
          child: influencerViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : noSocialData
                  ? const Center(child: Text('No cart is added'))
                  : _buildCartList(filteredCarts, influencerViewModel),
        ),
      ),
      // Add button below all card data
Padding(
  padding: const EdgeInsets.all(16.0),
  child: ElevatedButton(
    onPressed: _isUpdatingCurrency
        ? null // Disable button while updating currency
        : () async {
            if (_selectedCurrency == null) {
              // Show a message to select a currency if not selected
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please select a currency to proceed.'),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (filteredCarts.isEmpty) {
              // Show a message if there are no cart items
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('No cart items available. Add items to proceed.'),
                  backgroundColor: Colors.orange,
                ),
              );
            } else {
              setState(() {
                _isUpdatingCurrency = true; // Start loading
              });

              try {
                // Wait for the currency update to finish
                await influencerViewModel.updateCurrency(
                  _selectedCurrency!,
                  filteredCarts.map((cartItem) => cartItem.cartId).toList(),
                  _email!,
                );

                // Navigate to AnotherScreen if currency is selected and cart has items
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnotherScreen(
                      totalSum: influencerViewModel.totalSum ?? 0.0,
                      gst: influencerViewModel.gst ?? 0.0,
                      sumGst: influencerViewModel.sumGst ?? 0.0,
                      cartId: influencerViewModel.cartId ?? [],
                      email: influencerViewModel.email ?? '',
                      cartDetail: influencerViewModel.cartDetail ?? [],
                      currency: _selectedCurrency!, // Use selected currency here
                      proid: influencerViewModel.proid ?? [],
                      influencername: influencerViewModel.influencername ?? [],
                      influenceremail: influencerViewModel.influenceremail ?? [],
                      influnceradminid: influencerViewModel.influnceradminid ?? [],
                    ),
                  ),
                );
              } catch (e) {
                print("Error during Checkout: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update currency. Please try again.'),
                    backgroundColor: Colors.red,
                  ),
                );
              } finally {
                setState(() {
                  _isUpdatingCurrency = false; // End loading
                });
              }
            }
          },
    style: ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, 50), // Full width button
    ),
    child: _isUpdatingCurrency
        ? CircularProgressIndicator(color: Colors.white) // Show loading spinner
        : Text('Checkout'),
  ),
),
        ],
      ),
      currentIndex: 0, // Set the current index accordingly
      title: 'My Cart',
    ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => influencerViewModel.fetchCart(_email), // Manual refresh button
          child: const Icon(Icons.refresh),
        ),
      );
    }

  // Search field widget
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Search keyword',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {}); // Trigger rebuild on search query change
        },
      ),
    );
  }

  // Currency selector widget
  Widget _buildCurrencySelector(InfluencerViewModel influencerViewModel, List<UserCart> filteredCarts) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          DropdownButton<String>(
            isExpanded: true,
            value: _selectedCurrency,
            hint: Text('Select Currency'),
            onChanged: (newValue) async {
              setState(() {
                _selectedCurrency = newValue;
              });
              if (_selectedCurrency != null && _email != null) {
                List<String> cartIds = filteredCarts
                    .map((cartItem) => cartItem.cartId)
                    .where((cartId) => cartId != null)
                    .toList()
                    .cast<String>();
                 try {
              await influencerViewModel.updateCurrency(_selectedCurrency!, cartIds, _email!);            
            } catch (e) {
              // Handle any errors that might occur during the updateCurrency call
              print("Error during updateCurrency: $e");
            }
              }
            },
            items: ['INR', 'USD', 'EUR'].map((currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(currency),
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          if (_selectedCurrency == null)
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.red.withOpacity(0.2),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Please select a currency to proceed.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
                    ],
      ),
    );
  }
  // Cart list widget
  Widget _buildCartList(List<UserCart> filteredCarts, InfluencerViewModel influencerViewModel) {
    return ListView.builder(
      itemCount: filteredCarts.length,
      itemBuilder: (context, index) {
        final cartItem = filteredCarts[index];
        Map<String, dynamic>? socialPrices;
        try {
          socialPrices = jsonDecode(cartItem.cartSocials ?? '{}');
        } catch (e) {
          print('Error decoding socialPrice: $e');
        }

        // Calculate total price
        double totalPrice = 0.0;
        if (socialPrices != null) {
          socialPrices.forEach((key, value) {
            totalPrice += double.tryParse(value) ?? 0.0;
          });
        }

        return cartItem.cartId != null
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      _buildCartItemHeader(cartItem, totalPrice),
                      socialPrices != null && socialPrices.isNotEmpty
                          ? _buildSocialPrices(socialPrices, cartItem, influencerViewModel)
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink();
      },
    );
  }

  // Cart item header widget
  Widget _buildCartItemHeader(UserCart cartItem, double totalPrice) {
    return Container(
      color: Colors.purple,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                child: Image(
                  height: displayHeight(context) * 0.18,
                  width: displayWidth(context) * 0.32,
                  image: NetworkImage(
                    cartItem.filePic != null
                        ? 'https://www.wizbrand.com/storage/images/' + cartItem.filePic.toString()
                        : "https://www.wizbrand.com/assets/images/users/default.webp",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
            (cartItem.slug != null)
                ? cartItem.slug!.replaceAll('-', ' ') // Replace dashes with spaces
                : "No Name",  // Fallback for null slug
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
                  SizedBox(height: 4.0),
                  Text(
                    'Cart Id: ${cartItem.cartId}',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Total Price: $totalPrice ${_selectedCurrency ?? ''}',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Remove cart item icon
            IconButton(
          icon: Icon(Icons.delete, color: Colors.white),
          onPressed: () async {
            // Access influencerViewModel inside onPressed using Provider.of
            final influencerViewModel = Provider.of<InfluencerViewModel>(context, listen: false);
            
            try {
              // Use cartItem.addcartsid instead of influencer.addcartsid
              await influencerViewModel.removeFromCart(cartItem.id.toString(), _email!);
              await influencerViewModel.fetchCart(_email);  // Refresh the cart data
              setState(() {});  // Call setState to rebuild the UI if necessary
            } catch (error) {
              print("Error: $error");
            }
          },
        ),
          ],
        ),
      ),
    );
  }

  // Social prices widget
  Widget _buildSocialPrices(Map<String, dynamic> socialPrices, UserCart cartItem, InfluencerViewModel influencerViewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 10.0,
        runSpacing: 5.0,
        children: socialPrices.entries.map((entry) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 100) / 3,
            child: Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  influencerViewModel.getSocialIcon(entry.key),
                  color: influencerViewModel.getSocialIconColor(entry.key),
                  size: 18.0,
                ),
              ),
              label: Text('${entry.value} ${cartItem.currency}'),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}