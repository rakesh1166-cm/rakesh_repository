import 'package:flutter/material.dart';

class NoOrdersMessage extends StatelessWidget {
  final String message; // add this line

  const NoOrdersMessage({Key? key, required this.message}) : super(key: key); // update the constructor

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            if (message == 'No orders found') // add this condition
              Text(
                'No Orders Assigned',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
               if (message == 'No task found') // add this condition
               Text(
                'No Task Assigned',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}