import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Influencer/influencerdetail.dart';
import 'package:flutter_application_1/Screen/Influencer/myorder.dart';
import 'package:flutter_application_1/Screen/Influencer/notfound.dart';
import 'package:flutter_application_1/Screen/Influencer/orderdetail.dart';
import 'package:flutter_application_1/Screen/Influencer/ordertrack.dart';
import 'package:flutter_application_1/Screen/Influencer/update_task_form.dart';
import 'package:flutter_application_1/model/order.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:provider/provider.dart';

mixin OrderListMixin {
  static String noOrdersMessage = 'No orders found';

  Widget buildOrderList(BuildContext context, List<Order> filteredOrders, String? email) {
    if (filteredOrders.isEmpty) {
      return NoOrdersMessage(message: noOrdersMessage);
    }

    return Expanded(
      child: ListView.builder(
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          print("data buildOrderList is coming");
          print(order);
          print(order.taskLockStatus);

          // Parse productIds from String to List<int>
          final productIds = List<int>.from(json.decode(order.productId));
          print(productIds);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.purple,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Number: ${order.orderId}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Amount: ${order.amount} ${order.currency}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Cart Id: ${order.cartId}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text('Payment Id: ${order.paymentId}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text('Payment Date: ${order.payDate}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Products:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 8),
                        Column(
                          children: [
                            for (var entry in productIds.asMap().entries)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Product ID: ${entry.value}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                        SizedBox(height: 4),
                                        if (order.influencerEmail != null && order.influencerName != null && order.influencerEmail!.length > entry.key && order.influencerName!.length > entry.key)
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Influencer email: ${order.influencerEmail![entry.key]}', style: TextStyle(fontSize: 14)),
                                              SizedBox(height: 4),
                                              Text('Influencer name: ${order.influencerName![entry.key]}', style: TextStyle(fontSize: 14)),
                                            ],
                                          ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Center the icons and manage space
                                          children: [
                                            IconButton(
                                              onPressed: order.taskLockStatus![entry.value.toString()] == 'place' ? null : () async {
                                                try {
                                                  // Call the API to lock the task
                                                  await Provider.of<InfluencerViewModel>(context, listen: false).lockTask(order.orderId, entry.value);
                                                  _showTaskLockSuccessMessage(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => MyOrderScreen()),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('Failed to lock task. Please try again.'),
                                                    ),
                                                  );
                                                }
                                              },
                                              icon: Icon(
                                                order.taskLockStatus![entry.value.toString()] == 'place' ? Icons.lock : Icons.lock_open,
                                                color: order.taskLockStatus![entry.value.toString()] == 'place' ? Colors.grey : Colors.green,
                                              ),
                                              tooltip: order.taskLockStatus![entry.value.toString()] == 'place' ? 'Task Locked' : 'Task Unlocked',
                                            ),
                                            IconButton(
                                              onPressed: order.taskLockStatus![entry.value.toString()] == 'place' ? null : () async {
                                                Map<String, dynamic> response = {};
                                                try {
                                                  response = await Provider.of<InfluencerViewModel>(context, listen: false).updateTask(entry.value, order.orderId);
                                                } catch (e) {
                                                  // Handle error
                                                  print(e);
                                                }
                                                if (response.isNotEmpty) {
                                                  String ordersIdDynamic = response['orders_id'];
                                               
                                                  String taskTitle = response['task_title'] ?? 'No Title';
                                                  String description = response['description'] ?? 'No Description';
                                                  String videoLink = response['Video_link'] ?? 'No Video Link';
                                                  List<dynamic> imageLinks = jsonDecode(response['image_link'] ?? '[]');
                                                  _showUpdateTaskForm(context, entry.value, ordersIdDynamic, taskTitle, description, videoLink, imageLinks);
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('Failed to update task. Please try again.'),
                                                    ),
                                                  );
                                                }
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: order.taskLockStatus![entry.value.toString()] == 'place' ? Colors.grey : Colors.green,
                                              ),
                                              tooltip: 'Update Task',
                                            ),
                                            IconButton(
                                             onPressed: () {
                                                                Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetail(
                              productId: entry.value.toString(),
                              influencerAdminId: order.influencerName != null && order.influencerName!.length > entry.key ? order.influencerName![entry.key] : 'Unknown',
                              adminId: order.adminId ?? 'Unknown Admin',
                               
                                    influadmin_id: order.influencerAdminId?[entry.value.toString()] ?? '',
                              cartId: order.cartId?.toString() ?? 'No Cart ID',
                              order_id: order.orderId?.toString() ?? 'No Cart ID',
                              suggestion: order.suggestion?[entry.value.toString()] ?? '',                              
                              description: order.description?[entry.value.toString()] ?? '',
                             influencerPaymentId: order.influencerPaymentId?[entry.value.toString()] ?? '',
                              
                              work_desc: order.workDesc?[entry.value.toString()] ?? '',
                              currency: order.currency?.toString() ?? 'Unknown Currency',
                              image_link: order.imageLink?.toString() ?? 'No Image Link',                              
                              userName: order.userName?.toString() ?? 'Unknown User',
                              status: order.status?[entry.value.toString()] ?? 'Unknown Status',
                              adminEmail: order.adminEmail?.toString() ?? 'Unknown Email',
                              influencerEmail: order.influencerEmail != null && order.influencerEmail!.length > entry.key ? order.influencerEmail![entry.key] : 'Unknown Email',
                              taskLockStatus: order.taskLockStatus?[entry.value.toString()] ?? 'Unknown Status',
                              taskDates: order.taskDates?[entry.value.toString()] ?? '',
                              statusDate: order.statusDate?[entry.value.toString()] ?? '',
                               task_title: order.taskTitle?[entry.value.toString()] ?? '',
                              taskCreated: order.taskCreated?[entry.value.toString()] ?? '',
                              workurl: order.workUrl?[entry.value.toString()] ?? '',
                              videourl: order.videoLink?[entry.value.toString()] ?? '',
                              cartCreated: order.cartCreated?[entry.value.toString()] ?? '',
                              orderCreated: order.orderCreated?[entry.value.toString()] ?? '',
                              pubStatus: order.pubStatus?[entry.value.toString()] ?? 'Unknown',
                              influencerName: order.influencerName != null && order.influencerName!.length > entry.key ? order.influencerName![entry.key] : 'Unknown Influencer',
                            ),
                          ),
                        );
                                            },
                                              icon: Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.green,
                                              ),
                                              tooltip: 'View Task',
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => OrderTrackingPage(
                                                    productId: entry.value.toString(), // Pass only the current productId
                                                    influencerAdminId: order.influencerName![entry.key], // Convert List<int> to a single String
                                                    adminId: order.adminId,
                                                    userName: order.userName.toString(),
                                                    status: order.status![entry.value.toString()] ?? '',  // Convert Map<int, String> to a JSON string
                                                    adminEmail: order.adminEmail.toString(),
                                                    influencerEmail: order.influencerEmail![entry.key], 
                                                    taskLockStatus: order.taskLockStatus![entry.value.toString()] ?? '', // Provide a default value if the key is not found
                                                    taskDates: order.taskDates![entry.value.toString()] ?? '', 
                                                    statusDate: order.statusDate![entry.value.toString()] ?? '',   
                                                    taskCreated: order.taskCreated![entry.value.toString()] ?? '',
                                                    cartCreated: order.cartCreated![entry.value.toString()] ?? '', 
                                                    orderCreated: order.orderCreated![entry.value.toString()] ?? '',   
                                                    pubStatus: order.pubStatus![entry.value.toString()] ?? '', 
                                                    influencerName: order.influencerName![entry.key], // Join the List<String>? to a single String or use an empty string if null
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.location_on), // Add your preferred icon here
                                            label: Text('Order Track'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUpdateTaskForm(BuildContext context, int productId, String orderId, String taskTitle, String description, String videoLink, List<dynamic> imageLinks) {
  print("myorder mixin is");
    print(orderId);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to be fully displayed
      builder: (BuildContext context) {
        return UpdateTaskForm(
          productId: productId,
          orderId: orderId,
          taskTitle: taskTitle,
          description: description,
          videoLink: videoLink,
          imageLinks: imageLinks,
        );
      },
    );
  }

  void _showTaskLockSuccessMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Success'),
          content: Text('Task locked successfully!'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
