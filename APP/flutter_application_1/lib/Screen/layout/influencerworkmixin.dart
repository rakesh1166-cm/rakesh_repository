import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Influencer/influencer_work_detail.dart';
import 'package:flutter_application_1/Screen/Influencer/influencerdetail.dart';
import 'package:flutter_application_1/Screen/Influencer/notfound.dart';
import 'package:flutter_application_1/model/influencerwork.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:provider/provider.dart';


mixin InfluncerWorkMixin {
  static String noOrdersMessage = 'No task found'; 
Widget buildInfluencerworkList(BuildContext context, List<InfluncerWork> filteredOrders, String? email) {
  if (filteredOrders.isEmpty) {
    return NoOrdersMessage(message: noOrdersMessage);
  }
  return Expanded(
    child: ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            width: double.infinity, // Make sure the container takes full width
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
                        Center(child: Text('Title: ${order.taskTitle}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                        SizedBox(height: 8),
                        Text(
                          'Date: ${order.orderPayDate} | Amount: ${order.payAmount}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text('Influencer Name: ${order.payInfluencerName}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Task Id: ${order.ordersId}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Influencer Status: ${order.status}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
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
                                      child: Text('View'),
                                    ),
                                    SizedBox(width: 8),
                                       SizedBox(width: 8),
                                      if (order.status == 'completed')
                                        ElevatedButton(
                                          onPressed: order.publisherStatus == 'approve'
                                              ? null
                                              : () async {
                                                  // Approve action
                                                  await Provider.of<InfluencerViewModel>(context, listen: false).approveTask(order.id.toString());
                                                },
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                          child: Text('Approve'),
                                        ),
                                    if (order.publisherStatus != 'approve')
                                      ElevatedButton(
                                        onPressed: () {
                                          // Show bottom sheet for modify, now passing `email`
                                          _showUpdateTaskForm(context, order.id.toString(), order.suggestion.toString(), email);
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                        child: Text('Modify'),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

void _showUpdateTaskForm(BuildContext context, String orderId, String? suggestion, String? email) {
  // Use an empty string if 'suggestion' is null
  final TextEditingController descriptionController = TextEditingController(
    text: suggestion != null && suggestion != 'null' ? suggestion : '',
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow the bottom sheet to expand fully
    builder: (BuildContext context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Modify Task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  controller: descriptionController,
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final influencerViewModel = Provider.of<InfluencerViewModel>(context, listen: false);
                          await influencerViewModel.modifyTask(orderId, descriptionController.text);
                        
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyInfluncerWork(),
                            ),
                          );
                        } catch (e) {
                          // Handle error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to update task. Please try again.'),
                            ),
                          );
                        }
                      },
                      child: Text('Submit'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

}