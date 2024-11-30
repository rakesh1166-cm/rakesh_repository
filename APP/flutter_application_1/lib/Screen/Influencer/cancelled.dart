import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Influencer/cart.dart';
import 'package:flutter_application_1/Screen/layout/influencermixins.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';

class Cancelled extends StatefulWidget {
  @override
  _CancelledState createState() => _CancelledState();
}

class _CancelledState extends State<Cancelled> with NavigationMixin, InfluencerListMixin {
  @override
  Widget build(BuildContext context) {
    return buildBaseScreen(
      currentIndex: 0, // Set the appropriate index for the bottom nav bar   
      title: 'Payment Cancelled',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 80,
              ),
              SizedBox(height: 20),
              Text(
                'Payment Cancelled',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Your payment was not successful. Please try again or review your cart.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: navigateToCart,
                child: Text('Go to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToCart() {
    // Replace with the navigation logic for the cart screen 
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartScreen()),
      );
  }
}