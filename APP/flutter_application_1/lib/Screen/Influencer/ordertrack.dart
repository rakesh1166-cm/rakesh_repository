import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class OrderTrackingPage extends StatefulWidget {
  final String productId;
  final String influencerAdminId;
  final String adminId;
  final String userName;
  final String status;
  final String adminEmail;
  final String influencerEmail;
  final String taskLockStatus;
  final String taskDates;
  final String statusDate;
  final String taskCreated;
  final String cartCreated;
  final String orderCreated;
  final String pubStatus;
  final String influencerName;

  OrderTrackingPage({
    required this.productId,
    required this.influencerAdminId,
    required this.adminId,
    required this.userName,
    required this.status,
    required this.adminEmail,
    required this.influencerEmail,
    required this.taskLockStatus,
    required this.taskDates,
    required this.statusDate,
    required this.taskCreated,
    required this.cartCreated,
    required this.orderCreated,
    required this.pubStatus,
    required this.influencerName,
  });

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> with NavigationMixin {
  @override
  Widget build(BuildContext context) {
    print('OrderTrackingPage - taskLockStatus: ${widget.taskLockStatus}');
    return buildBaseScreen(
      currentIndex: 0, // Set the appropriate index for the bottom nav bar
      title: 'Order Tracking',
      body: content(),
    );
  }

  Widget content() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: [
                    Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbYXdbAmlfaigFPAjUhCbc7wT9NS0ghXD2aQ&s',
                      height: 200,
                    ),
                    Text(
                      'Order Tracking',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OrderTrackingSteps(
                taskLockStatus: widget.taskLockStatus,
                pubStatus: widget.pubStatus,
                status: widget.status),
          ),
        ],
      ),
    );
  }
}

class OrderTrackingSteps extends StatelessWidget {
  final String taskLockStatus;
  final String pubStatus;
  final String status;
  final int currentStep;

  OrderTrackingSteps(
      {required this.taskLockStatus, required this.pubStatus, required this.status})
      : currentStep = determineCurrentStep(taskLockStatus, pubStatus, status);

  static int determineCurrentStep(String taskLockStatus, String pubStatus, String status) {
    if (taskLockStatus != 'place') {
      return 2; // If taskLockStatus is not 'place', the furthest step is 2
    } else if (status == 'completed') {
      return 4;
    } else if (status != 'not approved' && status != 'reject') {
      return 3;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StepProgressIndicator(
          totalSteps: 4,
          currentStep: currentStep,
          selectedColor: Colors.green,
          unselectedColor: Colors.grey[200]!,
        ),
        SizedBox(height: 20),
        for (int i = 1; i <= 2; i++)
          ListTile(
            leading: Icon(
              getIconForStep(i),
              color: getColorForStep(i),
            ),
            title: Text('Step $i: ${stepDescription(i)}'),
          ),
        if (taskLockStatus == 'place') ...[
          ListTile(
            leading: Icon(
              getIconForStep(3),
              color: getColorForStep(3),
            ),
            title: Text('Step 3: ${stepDescription(3)}'),
          ),
          if (shouldShowStep4()) // Conditionally render step 4
            ListTile(
              leading: Icon(
                getIconForStep(4),
                color: getColorForStep(4),
              ),
              title: Text('Step 4: ${stepDescription(4)}'),
            ),
        ]
      ],
    );
  }

  bool shouldShowStep4() {
    // Only show step 4 if status is not "reject" or "not approved"
    return status != 'reject' && status != 'not approved';
  }

  IconData getIconForStep(int step) {
    if (step == 3 && status == 'reject') {
      return Icons.cancel;
    }
    if (step == 2 && taskLockStatus != 'place') {
      return Icons.radio_button_unchecked;
    }
    return step <= currentStep ? Icons.check_circle : Icons.radio_button_unchecked;
  }

  Color getColorForStep(int step) {
    if (step == 3 && status == 'reject') {
      return Colors.red;
    }
    if (step == 2 && taskLockStatus != 'place') {
      return Colors.grey;
    }
    return step <= currentStep ? Colors.green : Colors.grey;
  }

  String stepDescription(int step) {
    switch (step) {
      case 1:
        return 'Task Submitted';
      case 2:
        return taskLockStatus == 'place' ? 'Task Placed' : 'Awaiting Task Lock';
      case 3:
        return status == 'reject' ? 'Reject' : status == 'not approved' ? 'Not Approved' : 'Approved';
      case 4:
        return status == 'completed' ? 'Completed' : status;
      default:
        return '';
    }
  }
}