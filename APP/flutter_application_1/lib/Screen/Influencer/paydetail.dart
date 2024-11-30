import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Influencer/ordersuccess.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';
import 'package:flutter_application_1/Screen/layout/influencermixins.dart';
import 'package:flutter_application_1/model/currencyupdate.dart';
import 'package:paytm/paytm.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/Screen/Influencer/locationfilter.dart';
import 'package:flutter_application_1/Screen/Influencer/socialsitefilter.dart';
import 'package:flutter_application_1/model/search_influencer.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AnotherScreen extends StatefulWidget {
  final double totalSum;
  final double gst;
  final double sumGst;
  final List<String> cartId;
  final String email;
  final List<CartDetail> cartDetail;
  final String currency;
  final List<int> proid;
  final List<String> influencername;
  final List<String> influenceremail;
  final List<int> influnceradminid;

  AnotherScreen({
    required this.totalSum,
    required this.gst,
    required this.sumGst,
    required this.cartId,
    required this.email,
    required this.cartDetail,
    required this.currency,
    required this.proid,
    required this.influencername,
    required this.influenceremail,
    required this.influnceradminid,
  });

  @override
  State<AnotherScreen> createState() => _AnotherScreenState();
}

class _AnotherScreenState extends State<AnotherScreen>
    with NavigationMixin, InfluencerListMixin {
  @override
  Widget build(BuildContext context) {
    var influencerViewModel = Provider.of<InfluencerViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Influencer'),
      ),
      body: buildBaseScreen(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: Colors.blue,
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Information',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Cart Id: CART-${widget.cartId.join(", ")}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Influencer Name: ${widget.influencername.join(", ")}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Product-id: ${widget.proid}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Price:',
                              '${widget.totalSum.toString()} ${widget.currency}'),
                          _buildDetailRow('GST:',
                              '${widget.gst.toString()} ${widget.currency}'),
                          _buildDetailRow('Total(including GST):',
                              '${widget.sumGst.toString()} ${widget.currency}'),
                          SizedBox(height: 20),
                        Center(
              child: ElevatedButton(
              onPressed: () async {
              try {
                await influencerViewModel.makePayment(
                  totalSum: widget.totalSum,
                  gst: widget.gst,
                  sumGst: widget.sumGst,
                  cartId: widget.cartId,
                  email: widget.email,
                  cartDetail: widget.cartDetail,
                  currency: widget.currency,
                  proid: widget.proid,
                  influencername: widget.influencername,
                  influenceremail: widget.influenceremail,
                  influnceradminid: widget.influnceradminid,
                  context: context,  // Pass context to the ViewModel
                );
              } catch (e, stackTrace) {
                print('Error making payment: $e');
                print('StackTrace: $stackTrace');
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
                child: Text(
                  'Pay with Paytm',
                  style: TextStyle(fontSize: 16),
                ),
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
        title: 'Payment Detail',
      ),
    );
  }
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    ),
  );
}
