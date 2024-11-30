import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OrderTrackingPage extends StatefulWidget {
  final String influencerAdminId;
  final String adminId;
  final String userName;
  final String status;
  final String taskid;
  final String adminEmail;
  final String influencerEmail;
  final String taskLockStatus;
  final String pubStatus;
  final String influencerName;

  OrderTrackingPage({
    required this.influencerAdminId,
    required this.adminId,
    required this.userName,
    required this.taskid,
    required this.status,
    required this.adminEmail,
    required this.influencerEmail,
    required this.taskLockStatus,
    required this.pubStatus,
    required this.influencerName,
  });

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
      ),
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
                      height: 150,
                    ),
                    Text(
                      'Task Tracking',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Task ID: task_' + widget.taskid,
                      style: TextStyle(fontSize: 20),
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
              status: widget.status,
              pubStatus: widget.pubStatus,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderTrackingSteps extends StatelessWidget {
  final String taskLockStatus;
  final String status;
  final String? pubStatus;
  final int currentStep;

  OrderTrackingSteps({
    required this.taskLockStatus,
    required this.status,
    required this.pubStatus,
  }) : currentStep = taskLockStatus == 'place' ? 4 : 3;

  @override
  Widget build(BuildContext context) {
    final bool hideSteps = status == 'reject' || status == 'not approved';
    final bool hideStep3 = status != 'completed' && pubStatus == 'modify';
    final bool hideStep4 = hideStep3 || status == 'not approved' || pubStatus == null;

    return Column(
      children: [
        for (int i = 1; i <= 4; i++) ...[
          if (i == 1 ||
              (!hideSteps && i == 2) ||
              (!hideStep3 && i == 3) ||
              (!hideStep4 && i == 4)) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CustomStepIcon(
                      step: i,
                      status: stepStatus(i),
                      isActive: currentStep >= i,
                      pubStatus: pubStatus,
                    ),
                    if (i != 4)
                      Container(
                        width: 2,
                        height: 50,
                        color: (currentStep >= i )
                            ? Colors.green
                            : Colors.grey[200],
                      ),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text('${i == 4 ? 'Publisher' : 'Influencer'} $i: ${stepDescription(i)}'),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  String stepDescription(int step) {
    switch (step) {
      case 1:
        return status == 'not approved'
            ? 'Not Approved'
            : status == 'reject'
                ? 'Reject'
                : 'Approve';
      case 2:
        return (status != 'not approved' && status != 'completed')
            ? status
            : 'todo';
      case 3:
        return status != 'not approved' && status == 'todo'
            ? 'Modify'
            : status != 'not approved' && status != 'todo'
                ? 'Completed'
                : '';
      case 4:
        return (status != 'not approved' && pubStatus != null) 
            ? '$pubStatus' 
            : 'Not Approved'; // Display 'Not Approved' when pubStatus is null
      default:
        return '';
    }
  }

  String stepStatus(int step) {
    switch (step) {
      case 1:
        return status;
      case 2:
        return (status != 'not approved' && status != 'completed') ? status : '';
      case 3:
        return status == 'completed' ? 'completed' : '';
      case 4:
        return (status != 'not approved' && pubStatus != null) ? 'publisher' : 'not approved'; // Return 'not approved' when pubStatus is null
      default:
        return '';
    }
  }
}

class CustomStepIcon extends StatelessWidget {
  final int step;
  final String status;
  final bool isActive;
  final String? pubStatus;

  CustomStepIcon({
    required this.step,
    required this.status,
    required this.isActive,
    this.pubStatus,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    if (step == 4 && pubStatus != null) {
      if (pubStatus == 'approve') {
        iconData = Icons.check_circle;
        iconColor = Colors.green;
      } else {
        iconData = Icons.radio_button_unchecked;
        iconColor = Colors.grey;
      }
    } else {
      if (isActive) {
        iconData = Icons.check_circle;
        iconColor = Colors.green;
      } else {
        iconData = Icons.radio_button_unchecked;
        iconColor = Colors.grey;
      }
    }

    return Column(
      children: [
        Icon(
          iconData,
          color: iconColor,
        ),
      ],
    );
  }
}