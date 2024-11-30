import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wizbrand_influencer/Screen/Influencer/notfound.dart';
import 'package:wizbrand_influencer/Screen/Influencer/taskboard.dart';
import 'package:wizbrand_influencer/model/mytask.dart';
import 'package:wizbrand_influencer/view_modal/influencer_view_model.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand_influencer/Screen/Influencer/influencerdetail.dart';
import 'package:wizbrand_influencer/Screen/Influencer/tasktrack.dart';

mixin taskListMixin {
  static String noOrdersMessage = 'No task found'; 
  Widget buildOrderList(BuildContext context, List<Mytask> filteredOrders, String? email) {
    if (filteredOrders.isEmpty) {
      return NoOrdersMessage(message: noOrdersMessage);
    }
    return Expanded(
      child: ListView.builder(
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          print("data taskListMixin is coming");
           print(order);
          print(order.imageLink);
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
                        Center(
                          child: Text('Approve or Reject Publisher Task',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)
                          )
                        ),
                        SizedBox(height: 8),
                        Text('Title: ${order.taskTitle}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text('Date: ${order.orderPayDate}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            Spacer(),
                            Text('Task Id: task_${order.id}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 8),
                  Text('Amount: ${order.payAmount} ${order.currency ?? ''}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
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
                        Text('Action:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InfluencerDetailScreen(order: order),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: Text('View Detail'),
                            ),
                            if (order.status == 'not approved')
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await Provider.of<InfluencerViewModel>(context, listen: false).approveTask(order.id.toString());
                                    // Handle success
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Task approved successfully'),
                                      ),
                                    );
                                  } catch (e) {
                                    // Handle failure
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to approve task. Please try again.'),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Approve'),
                              ),
                            if (order.status == 'not approved')
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await Provider.of<InfluencerViewModel>(context, listen: false).rejectTask(order.id.toString());
                                    // Handle success
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Task rejected successfully'),
                                      ),
                                    );
                                  } catch (e) {
                                    // Handle failure
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to reject task. Please try again.'),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Reject'),
                              ),
                            if (order.status != 'not approved' && order.status != 'reject')
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TabDesign()),
                                  );
                                },
                                child: Text('Task Board'),
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                        if (order.status != 'not approved' && order.status != 'reject')
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            SizedBox(width: 8),
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
                                                    influencerAdminId: order.payInfluencerName.toString(), 
                                                    adminId: order.adminId.toString(),
                                                     taskid: order.id.toString(),
                                                    userName: order.userName.toString(),
                                                    status: order.status.toString(),
                                                    adminEmail: order.adminEmail.toString(),
                                                    influencerEmail: order.influencerEmail.toString(), 
                                                    taskLockStatus: order.tasklockdate.toString(),                                               
                                                    pubStatus: order.publisherStatus.toString(), 
                                                    influencerName: order.payInfluencerName.toString(), 
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.location_on),
                                            label: Text('Task Track'),
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
}