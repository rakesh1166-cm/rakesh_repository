import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_application_1/Screen/Influencer/update_task_form.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';


class OrderSuccessScreen extends StatefulWidget {
  final String orderId; // OrderId passed from the previous screen

  OrderSuccessScreen({required this.orderId});

  @override
  _OrderSuccessScreenState createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with NavigationMixin {
  
  String? _influencerName;
  String? _productId;
  String? _paymentId;
  String? _paymentDate;
  double? _amount;

  @override
  void initState() {
    super.initState();
    _fetchOrderData(); // Fetch order details when the screen initializes
  }

Future<void> _fetchOrderData() async {
  final influencerViewModel = Provider.of<InfluencerViewModel>(context, listen: false);
  final credentials = await _getCredentials();
  final email = credentials['email'];

  if (email != null && widget.orderId.isNotEmpty) {
    // Call the API to get order details
    final orderData = await influencerViewModel.getOrderDetails(widget.orderId, email);

    if (orderData != null && orderData.isNotEmpty) {
      // Assuming you want the first item from the list
      final firstOrder = orderData[0]; // Access the first order detail from the list

      setState(() {
        // Process Product ID whether it's a single or multiple items in an array or JSON-encoded string
        if (firstOrder['product_id'] != null) {
          var productId = firstOrder['product_id'];
          if (productId is String) {
            try {
              // Attempt to parse JSON-encoded string into a list
              var decodedProductIds = jsonDecode(productId);
              if (decodedProductIds is List) {
                _productId = decodedProductIds.join('|'); // Join product IDs with '|'
              } else {
                _productId = productId; // It's just a string, no need to parse
              }
            } catch (e) {
              // If parsing fails, it's just a string
              _productId = productId;
            }
          } else if (productId is List) {
            _productId = productId.join('|'); // Join product IDs with '|'
          } else {
            _productId = productId.toString();
          }
        }

        // Process Influencer Name whether it's a single or multiple items in an array or JSON-encoded string
        if (firstOrder['influencer_name'] != null) {
          var influencerName = firstOrder['influencer_name'];
          if (influencerName is String) {
            try {
              // Attempt to parse JSON-encoded string into a list
              var decodedNames = jsonDecode(influencerName);
              if (decodedNames is List) {
                _influencerName = decodedNames.join('|'); // Join names with '|'
              } else {
                _influencerName = influencerName; // It's just a string, no need to parse
              }
            } catch (e) {
              // If parsing fails, it's just a string
              _influencerName = influencerName;
            }
          } else if (influencerName is List) {
            _influencerName = influencerName.join('|'); // Join influencer names with '|'
          } else {
            _influencerName = influencerName.toString();
          }
        }

        _paymentId = firstOrder['payment_id'] != null ? firstOrder['payment_id'].toString() : null;
        _paymentDate = firstOrder['Pay_date'] != null ? firstOrder['Pay_date'].toString() : null;
        _amount = firstOrder['amount'] != null ? (firstOrder['amount'] as num).toDouble() : null;
      });
    } else {
      // Handle the case where no order data is returned
      print("No order details found.");
    }
  }
}
  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    return {'email': email};
  }

  // Function to open the bottom sheet
void _showUpdateTaskForm(BuildContext context, String orderId) {
  print("order id aaraha hain");
  print(orderId);
  
  // Extract only the numeric part from the orderId
  String numericOrderId = orderId.replaceAll(RegExp(r'[^0-9]'), '');
  print("Extracted numeric Order ID: $numericOrderId");

  // Convert the numeric string to an integer
  int? parsedOrderId = int.tryParse(numericOrderId);
  print(parsedOrderId);

  if (parsedOrderId == null) {
    print("Error: Order ID is not a valid integer");
    return; // Handle the error case or show a message
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return UpdateTaskForm(
        productId: int.tryParse(_productId ?? '0') ?? 0,
        orderId: orderId,  // Pass the parsed integer orderId here
        taskTitle: "",
        description: "",
        videoLink: "",
        imageLinks: [],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Payment Successful'),
      ),
      body: buildBaseScreen(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.green,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Payment Successful',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         _buildDetailRow(context, 'Order Id:', widget.orderId),
    _buildDetailRow(context, 'Product Id:', _productId ?? 'Loading...'),
    _buildDetailRow(context, 'Payment Date:', _paymentDate ?? 'Loading...'),
  _buildDetailRow(
  context,
  'Influencer Name:',
  _influencerName != null
      ? _influencerName!.replaceAll('-', ' ') // Replace dashes with spaces
      : 'Loading...',
),
    _buildDetailRow(context, 'Payment-Id:', _paymentId ?? 'Loading...'),
    _buildDetailRow(context, 'Amount:', '${_amount?.toString() ?? 'Loading...'} INR'),
                          SizedBox(height: 32),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _showUpdateTaskForm(context, widget.orderId);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 237, 235, 235),
                              ),
                              child: Text('Add Work Details to Influencers'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        currentIndex: 0,
        title: 'Order Success',
      ),
    );
  }

  // Widget _buildDetailRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //         Text(value, style: TextStyle(fontSize: 16)),
  //       ],
  //     ),
  //   );
  // }
Widget _buildDetailRow(BuildContext context, String label, String value) {
  double screenWidth = displayWidth(context); // Using your defined method

  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: screenWidth * 0.05, // Dynamically adjust horizontal padding
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: screenWidth * 0.4, // Restrict label width to 40% of screen width
          child: Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
            maxLines: 1, // Restrict to a single line
          ),
        ),
      ],
    ),
  );
}


}